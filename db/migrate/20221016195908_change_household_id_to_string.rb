class ChangeHouseholdIdToString < ActiveRecord::Migration[6.0]
  def change
    change_column :voters, :household_id, :string
  end
end
