# frozen_string_literal: true

class Voter < ApplicationRecord
  self.primary_key = :sos_id

  has_many :relationships, foreign_key: :voter_sos_id
  has_many :users, through: :relationships

  enum last_call_status: [ :not_yet_called, :should_call_again, :do_not_call, :successfully_completed ]
  enum voter_data_status: [:reach_match, :manual_match, :unmatched]
  enum voter_registration_status: [:registered_in_district, :registered_in_state, :registereted_out_of_state, :unregistered]

  CALL_STATUS_TEXT = {
    not_yet_called: "Not called",
    should_call_again: "Need to follow up",
    do_not_call: "Don't contact",
    successfully_completed: "Vote plan finalized",
  }.freeze

  def last_call_status_display
    CALL_STATUS_TEXT.fetch(last_call_status.to_sym, "Unknown")
  end

  def polling_place_display
    nil # TODO: implement voting location search if possible
  end

  def phone_number_display
    PhoneNumberUtils.display(primary_phone_number)
  end

  def display_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def household_members
    if household_id.nil?
      Voter.none
    else
      Voter.where(household_id: household_id).where.not(sos_id: sos_id)
    end
  end
end
