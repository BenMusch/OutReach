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

  def credentials_json
    raw_value = super
    raw_value.present? ? crypt.decrypt_and_verify(raw_value) : raw_value
  end

  def credentials_json=(raw_value)
    if raw_value.present?
      encrypted_value = crypt.encrypt_and_sign(raw_value)
      super(encrypted_value)
    else
      Rails.logger.info("Skipping update of credentials_json to non-present value")
    end
  end

  private

  def crypt
    ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
  end
end
