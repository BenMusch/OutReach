class AddMoreColumnsToCampaignSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :campaign_settings, :gtag, :string
    add_column :campaign_settings, :reach_guide_url, :string
  end
end
