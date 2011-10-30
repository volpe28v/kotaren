class CreateTunings < ActiveRecord::Migration
  def change
    create_table :tunings do |t|
      t.string :name
      t.integer :capo

      t.timestamps
    end
  end
end
