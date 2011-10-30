class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.integer :tune_id
      t.integer :album_id

      t.timestamps
    end
  end
end
