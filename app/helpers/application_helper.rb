module ApplicationHelper
  def camapign_name
    @campaign_name ||= campaign_settings.name ? campaign_settings.name : "Set Campaign Name!"
  end

  def home_image_url
    @home_image_url ||= campaign_settings.home_image_url ? campaign_settings.home_image_url : ""
  end

  def polls_close_time
    @polls_close_time ||= campaign_settings && campaign_settings.election_time
  end

  def campaign_script
    @campaign_script ||= campaign_settings.script_content_markdown ? campaign_settings.script_content_markdown : "Need to set a script!"
  end

  def gtag
    campaign_settings.gtag
  end

  def reach_guide_url
    campaign_settings.reach_guide_url || "TODO"
  end

  def campaign_settings
    @campaign_settings ||= CampaignSetting.current
  end

  def is_admin?
    current_user && current_user.is_admin?
  end

  def markdown(text)
    options = [:hard_wrap, :autolink, :no_intra_emphasis]
    Markdown.new(text || "No script yet", *options).to_html.html_safe
  end
end
