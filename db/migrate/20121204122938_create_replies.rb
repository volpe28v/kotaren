class CreateReplies < ActiveRecord::Migration[4.2]
  def change
    create_table :replies do |t|
      t.integer :comment_id
      t.string :text
      t.integer :user_id

      t.timestamps :null => false
    end
  end
end
