class CreateParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :participants do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :match, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end

    add_index :participants, [:match_id, :user_id], unique: true
  end
end
