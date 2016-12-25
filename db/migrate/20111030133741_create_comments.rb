class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.integer :tune_id
      t.integer :user_id
      t.string :text

      t.timestamps :null => false
    end
  end
end
