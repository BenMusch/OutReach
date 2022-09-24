class CampaignSettingsController < ApplicationController
  before_action :require_admin, :ensure_one_settings_entry

  def edit
  end

  def update
    if @campaign_setting.update_attributes(campaign_settings_params)
      redirect_to edit_campaign_settings_path, success: 'Settings updated!'
    else
      render action: "edit"
    end
  end

  private

  def campaign_settings_params
    params.require(:campaign_setting).permit(:name, :home_image_url, :script_content_markdown)
  end

  def require_admin
    unless current_user.is_admin
      flash[:danger] = 'You are not authorized to view that page'
      redirect_to relationships_path
    end
  end

  def ensure_one_settings_entry
    CampaignSetting.transaction do
      if CampaignSetting.count == 0
        CampaignSetting.create!
      end

      @campaign_setting = CampaignSetting.first
    end
  end
end
