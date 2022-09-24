module ApplicationHelper
  def camapign_name
    @campaign_name ||= campaign_settings ? campaign_settings.name : "Set Campaign Name!"
  end

  def home_image_url
    @home_image_url ||= campaign_settings ? campaign_settings.home_image_url : ""
  end

  def campaign_script
    @campaign_script ||= campaign_settings ? campaign_settings.script_content_markdown : "Need to set a script!"
  end

  def campaign_settings
    @campaign_settings ||= CampaignSetting.first
  end

  def markdown(text)
    options = [:hard_wrap, :autolink, :no_intra_emphasis]
    Markdown.new(text, *options).to_html.html_safe
  end
end
