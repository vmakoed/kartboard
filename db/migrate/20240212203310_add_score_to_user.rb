class AddScoreToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :score, :integer, null: false, default: 1000
  end
end
