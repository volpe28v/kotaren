class AddAllnotifyToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :all_notify, :boolean, :default => false
  end
end
