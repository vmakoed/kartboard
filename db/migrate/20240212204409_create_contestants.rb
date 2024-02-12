class CreateContestants < ActiveRecord::Migration[7.1]
  def change
    create_table :contestants do |t|
      t.belongs_to :contest, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :contestants, [:user_id, :contest_id], unique: true
  end
end
