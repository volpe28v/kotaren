class AddYoutubeAndTwitterToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users ,:youtube_name, :string
    add_column :users ,:twitter_name, :string
  end
end
