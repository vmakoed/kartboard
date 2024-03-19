class AddNullFalseToContestsCreatedBy < ActiveRecord::Migration[7.1]
  def change
    change_column_null :contests, :created_by_id, false
  end
end
