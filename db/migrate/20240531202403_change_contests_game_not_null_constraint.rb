class ChangeContestsGameNotNullConstraint < ActiveRecord::Migration[7.1]
  def change
    change_column_null :contests, :game_id, false
    add_foreign_key :contests, :games
  end
end
