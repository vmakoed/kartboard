class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.belongs_to :game, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :score, null: false, default: 1000

      t.timestamps
    end
  end
end
