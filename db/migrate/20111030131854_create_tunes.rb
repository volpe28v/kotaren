class CreateTunes < ActiveRecord::Migration
  def change
    create_table :tunes do |t|
      t.string :title
      t.integer :tuning_id

      t.timestamps
    end
  end
end
