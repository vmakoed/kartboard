class AddAasmStateToRuns < ActiveRecord::Migration[7.1]
  def change
    add_column :runs, :aasm_state, :string
  end
end
