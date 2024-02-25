class AddPositionToContestants < ActiveRecord::Migration[7.1]
  def change
    add_column :contestants, :place, :integer, null: false
  end
end
