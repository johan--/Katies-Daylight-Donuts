class CreateSms < ActiveRecord::Migration
  def self.up
    create_table :sms do |t|
      t.string  :state
      t.text    :body
      t.integer :prefix
      t.integer :user_id
      t.timestamps
    end
    
    # Anonymous user for unsubscribed users
    User.create(:email => "nobody@katiesdaylightdonuts.com", 
      :username => "nobody", :password => "j0hnl0ng", :password_confirmation => "j0hnl0ng")
    
  end

  def self.down
    drop_table :sms
  end
end
