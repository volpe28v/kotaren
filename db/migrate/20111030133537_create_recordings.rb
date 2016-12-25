class CreateRecordings < ActiveRecord::Migration[4.2]
  def change
    create_table :recordings do |t|
      t.integer :tune_id
      t.integer :album_id

      t.timestamps :null => false
    end
  end
end
