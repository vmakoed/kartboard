class CreateContests < ActiveRecord::Migration[7.1]
  def change
    create_table :contests do |t|
      t.timestamps
    end
  end
end
