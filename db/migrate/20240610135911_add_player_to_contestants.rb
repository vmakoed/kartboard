class AddPlayerToContestants < ActiveRecord::Migration[7.1]
  def change
    add_reference :contestants, :player
  end
end
