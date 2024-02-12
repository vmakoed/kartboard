class CreateScoreLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :score_logs do |t|
      t.belongs_to :contestant, null: false, foreign_key: true, index: { unique: true }
      t.integer :previous_score, null: false
      t.integer :new_score, null: false
      t.integer :score_difference, null: false

      t.timestamps
    end
  end
end
