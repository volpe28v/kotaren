class CreateActivities < ActiveRecord::Migration[4.2]
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.date :date
      t.integer :count, :default => 0

      t.timestamps :null => false
    end
  end
end
