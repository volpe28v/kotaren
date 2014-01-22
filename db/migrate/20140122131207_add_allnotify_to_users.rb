class AddAllnotifyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :all_notify, :boolean, :default => false
  end
end
