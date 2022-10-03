class ChangePrimaryKeyForVoters < ActiveRecord::Migration[6.0]
  def change
    execute 'alter table voters drop constraint voters_pkey'
    execute 'alter table voters add primary key (sos_id)'
    change_column_null :voters, :reach_id, true
  end
end
