class AddVoterKeyToCampaignSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :campaign_settings, :voter_key, :integer
  end
end
