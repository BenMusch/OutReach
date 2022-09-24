class CreateCampaignSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :campaign_settings do |t|
      t.string :name
      t.string :home_image_url
      t.text :script_content_markdown

      t.timestamps
    end
  end
end
