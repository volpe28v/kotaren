class AddDeviseToUsers < ActiveRecord::Migration[4.2]
  def change
    change_table :users do |t|
      t.string :email, :null => false, :default => ''
      t.string :encrypted_password, :limit => 128, :null => false, :default => ''
      t.string :reset_password_token, :null => false, :default => ''
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
  end
end
