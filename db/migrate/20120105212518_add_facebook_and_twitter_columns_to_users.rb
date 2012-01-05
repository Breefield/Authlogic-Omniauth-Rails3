class AddFacebookAndTwitterColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_uid, :string
    add_column :users, :twitter_uid,  :string
    add_column :users, :avatar_url,   :string
    add_column :users, :name,         :string
  end
end
