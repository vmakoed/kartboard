class AddPositionAttributesToScoreLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :score_logs, :previous_position, :integer
    add_column :score_logs, :new_position, :integer
    add_column :score_logs, :position_difference, :integer
  end
end
