class AddIconUrlToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :icon_url, :string
  end
end
