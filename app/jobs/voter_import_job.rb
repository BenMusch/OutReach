class VoterImportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    BigQueryLoader.new.load_voters
  end
end
