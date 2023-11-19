class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :run, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end

    add_index :players, [:run_id, :user_id], unique: true
  end
end
