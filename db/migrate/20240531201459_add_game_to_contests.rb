class AddGameToContests < ActiveRecord::Migration[7.1]
  def change
    add_reference :contests, :game
  end
end
