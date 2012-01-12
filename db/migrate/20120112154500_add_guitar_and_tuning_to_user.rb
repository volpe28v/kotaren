class AddGuitarAndTuningToUser < ActiveRecord::Migration
  def change
    add_column :users, :guitar, :string
    add_column :users, :tuning, :string
  end
end
