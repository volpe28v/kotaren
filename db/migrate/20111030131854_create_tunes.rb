class CreateTunes < ActiveRecord::Migration[4.2]
  def change
    create_table :tunes do |t|
      t.string :title
      t.integer :tuning_id

      t.timestamps :null => false
    end
  end
end
