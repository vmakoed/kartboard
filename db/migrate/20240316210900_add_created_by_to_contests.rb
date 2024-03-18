class AddCreatedByToContests < ActiveRecord::Migration[7.1]
  def change
    add_reference :contests, :created_by, foreign_key: { to_table: :users }
  end
end
