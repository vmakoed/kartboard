class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.datetime :completed_at

      t.timestamps
    end
  end
end
