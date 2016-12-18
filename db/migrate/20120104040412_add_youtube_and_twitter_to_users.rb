class AddYoutubeAndTwitterToUsers < ActiveRecord::Migration
  def change
    add_column :users ,:youtube_name, :string
    add_column :users ,:twitter_name, :string
  end
end
