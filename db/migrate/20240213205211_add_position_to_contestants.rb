class AddPositionToContestants < ActiveRecord::Migration[7.1]
  def change
    add_column :contestants, :place, :integer, null: false
    add_index :contestants, [:contest_id, :place], unique: true
  end
end
