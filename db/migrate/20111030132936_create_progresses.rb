class CreateProgresses < ActiveRecord::Migration[4.2]
  def change
    create_table :progresses do |t|
      t.string :status
      t.integer :percent
      t.integer :tune_id
      t.integer :user_id

      t.timestamps :null => false
    end
  end
end
