class AddCodeToMatch < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :code, :string, null: false, limit: 6
    add_index :matches, :code, unique: true
  end
end
