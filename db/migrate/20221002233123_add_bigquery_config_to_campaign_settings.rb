class AddBigqueryConfigToCampaignSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :campaign_settings, :credentials_json, :string
    add_column :campaign_settings, :users_query, :string
    add_column :campaign_settings, :relationships_query, :string
    add_column :campaign_settings, :voters_query, :string
  end
end
