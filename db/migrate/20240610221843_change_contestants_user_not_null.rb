class ChangeContestantsUserNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :contestants, :user_id, true
    remove_foreign_key :contestants, :users
  end
end
