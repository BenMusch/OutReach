class AddBackHouseholdIdIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :voters, [:household_id, :last_call_status]
    add_index :voters, [:sos_id, :household_id]
    add_index :voters, :household_id
  end
end
