class CreateTunings < ActiveRecord::Migration[4.2]
  def change
    create_table :tunings do |t|
      t.string :name
      t.integer :capo

      t.timestamps :null => false
    end
  end
end
