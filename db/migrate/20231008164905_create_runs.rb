class CreateRuns < ActiveRecord::Migration[7.1]
  def change
    create_table :runs do |t|
      t.datetime :completed_at

      t.timestamps
    end
  end
end
