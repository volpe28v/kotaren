class ChangeUserResetPasswordToken < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :reset_password_token, :string, default: nil, null: true
  end
end
