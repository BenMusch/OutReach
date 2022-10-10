class AddElectionTimeToCampaignSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :campaign_settings, :election_time, :datetime
  end
end
