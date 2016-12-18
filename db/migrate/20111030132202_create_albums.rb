class CreateAlbums < ActiveRecord::Migration[4.2]
  def change
    create_table :albums do |t|
      t.string :title
      t.date :release

      t.timestamps :null => false
    end
  end
end
