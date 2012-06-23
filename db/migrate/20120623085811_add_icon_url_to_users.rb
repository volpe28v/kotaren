class AddIconUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :icon_url, :string
  end
end
