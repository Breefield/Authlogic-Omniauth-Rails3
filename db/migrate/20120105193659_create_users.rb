class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string  :email
      t.string  :crypted_password,  :null => false
      t.string  :password_salt,     :null => false
      t.string  :persistence_token, :null => false
      
      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
