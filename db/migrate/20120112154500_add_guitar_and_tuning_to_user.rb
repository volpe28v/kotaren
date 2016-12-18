class AddGuitarAndTuningToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :guitar, :string
    add_column :users, :tuning, :string
  end
end
