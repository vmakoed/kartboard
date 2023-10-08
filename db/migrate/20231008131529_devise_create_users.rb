# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end
  end
end
