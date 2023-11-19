class AddCodeToRun < ActiveRecord::Migration[7.1]
  def change
    add_column :runs, :code, :string, null: false, limit: 6
    add_index :runs, :code, unique: true
  end
end
