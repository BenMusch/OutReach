class CampaignSettingsController < ApplicationController
  before_action :require_admin, :ensure_one_settings_entry

  def edit
  end

  def update
    if campaign_settings_params.key?(:bigquery_credentials_json) && !campaign_settings_params[:bigquery_credentials_json].present?
      # Ensure that empty value default from the UI doesn't over-write the
      # actual credentials
      campaign_settings_params.delete(:bigquery_credentials_json)
    end

    if @campaign_setting.update_attributes(campaign_settings_params)
      redirect_to edit_campaign_settings_path, success: 'Settings updated!'
    else
      render action: "edit"
    end
  end

  private

  def campaign_settings_params
    params.require(:campaign_setting).permit(
      :name, :home_image_url, :script_content_markdown,
      :voters_query, :users_query, :relationships_query,
      :bigquery_credentials_json)
  end

  def require_admin
    unless current_user.is_admin
      flash[:danger] = 'You are not authorized to view that page'
      redirect_to relationships_path
    end
  end

  def ensure_one_settings_entry
    CampaignSetting.instantiate_if_not_exists!
    @campaign_setting = CampaignSetting.current
  end
end
