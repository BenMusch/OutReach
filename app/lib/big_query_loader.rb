# frozen_string_literal: true
require "google/cloud/bigquery"
require "logger"

my_logger = Logger.new $stderr
my_logger.level = Logger::ERROR

# Set the Google API Client logger
Google::Apis.logger = my_logger

class BigQueryLoader
  def initialize(batch_size: nil, sleep_seconds: nil)
    @batch_size = batch_size || ENV.fetch('LOADER_BATCH_SIZE', 1000).to_i
    @sleep_seconds = sleep_seconds || ENV.fetch('LOADER_SLEEP_SECONDS', 1).to_i
  end

  def load_relationships
    unless CampaignSetting.current.relationships_query.present?
      raise "No relationships query!"
    end

    batch_upsert_from_bigquery(CampaignSetting.current.relationships_query,
                               model_cls: Relationship,
                               unique_by: [:user_id, :voter_sos_id]) do |row|
      {
        user_id:      row[:user_id],
        voter_sos_id: row[:sos_id],
        relationship: row[:relationship_type],
      }
    end
    puts("Finished relationship import!")
  end

  def load_users
    unless CampaignSetting.current.users_query.present?
      raise "No users query!"
    end

    batch_upsert_from_bigquery(CampaignSetting.current.users_query,
                               model_cls: User,
                               key: :user_id) do |row|
      {
        id: row[:user_id],
        last_name: row[:last_name],
        first_name: row[:first_name],
        email_address: row[:email_address],
        phone_number: row[:phone_number],
      }
    end
    puts("Finished user import!")
  end

  def load_voters
    load_voters_shared(CampaignSetting.current.voters_query)
  end

  private

  attr_reader :batch_size, :sleep_seconds

  def client
    # Can't memo-ize the client because credentials could update at any time
    credentials = CampaignSetting.current.bigquery_credentials_json
    credentials_parsed = JSON.parse(credentials)

    Google::Cloud::Bigquery.configure do |config|
      config.project_id  = credentials["project_id"]
      config.credentials = credentials
    end

    Google::Cloud::Bigquery.new
  end

  def load_voters_shared(q)
    batch_upsert_from_bigquery(q,
                               model_cls: Voter,
                               key: :sos_id) do |row|
      {
        last_name: row[:last_name],
        first_name: row[:first_name],
        middle_name: row[:middle_name],
        primary_phone_number: row[:primary_phone_number],
        voting_street_address: row[:voting_street_address],
        voting_city: row[:voting_city],
        voting_zip: row[:voting_zip],
        sos_id: row[:sos_id],
      }
    end
    puts("Finished voter import")
  end

  def batch_upsert_from_bigquery(query, key: nil, model_cls:, unique_by: nil)
    raise "need a block!" unless block_given?

    failed = false
    cur_batch = {}
    data = client.query(query, max: batch_size)

    loop do
      data.each do |row|
        cur_key = key.present? ? row[key] : cur_batch.size.to_s

        result = yield row
        unless result.nil?
          cur_batch[cur_key] = result.merge(created_at: Time.now,
                                            updated_at: Time.now)
        end
      end

      puts("Got batch of #{cur_batch.size}, up-serting!")
      begin
        model_cls.upsert_all(cur_batch.values, unique_by: unique_by)
      rescue StandardError => e
        puts("Upsert failed, continuing rest of batch")
        puts("#{e.class} -- #{e.message}")
        puts("#{e.backtrace.join("\n")}")
        failed = true
      end

      puts("Sleeping #{sleep_seconds} seconds")
      sleep sleep_seconds
      cur_batch = {}

      if data.next?
        data = data.next
      else
        break
      end
    end

    !failed
  end
end
