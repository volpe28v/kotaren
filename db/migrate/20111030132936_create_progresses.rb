class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.string :status
      t.integer :percent
      t.integer :tune_id
      t.integer :user_id

      t.timestamps
    end
  end
end
