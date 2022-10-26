class AddIndexOnSosIdSupportScores < ActiveRecord::Migration[6.0]
  def change
    add_index :voters, [:sos_id, :support_score]
  end
end
