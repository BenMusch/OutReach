class CampaignSetting < ApplicationRecord
  def self.instantiate_if_not_exists!
    CampaignSetting.transaction do
      if CampaignSetting.count == 0
        CampaignSetting.create!
      end
    end
  end

  def self.current
    instantiate_if_not_exists!
    CampaignSetting.first
  end
end
