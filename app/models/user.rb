class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validate_email_field = false
    c.validate_password_field = false
  end
  
  validates :password, :presence => { :if => :password_required? }, :confirmation => true
  validates :email, :presence => { :if => :email_available?}, :confirmation => true
  
  def self.find_or_create_from_oauth(auth_hash)
    provider = auth_hash["provider"]
    uid = auth_hash["uid"]
    case provider
      when 'facebook'
        if user = self.find_by_email(auth_hash["info"]["email"])
          user.update_user_from_facebook(auth_hash)
          return user
        elsif user = self.find_by_facebook_uid(uid)
          return user
        else
          return self.create_user_from_facebook(auth_hash)
        end
      when 'twitter'
        if user = self.find_by_twitter_uid(uid)
          return user
        else
          return self.create_user_from_twitter(auth_hash)
        end
    end
  end
  
  def self.create_user_from_twitter(auth_hash)
    self.create({
      :twitter_uid => auth_hash["uid"],
      :name => auth_hash["info"]["name"],
      :avatar_url => auth_hash["info"]["image"],
      :crypted_password => "twitter",
      :password_salt => "twitter",
      :persistence_token => "twitter"
    })
    
  end
  
  def self.create_user_from_facebook(auth_hash)
    self.create({
      :facebook_uid => auth_hash["uid"],
      :name => auth_hash["info"]["name"],
      :avatar_url => auth_hash["info"]["image"],
      :email => auth_hash["info"]["email"],
      :crypted_password => "facebook",
      :password_salt => "facebook",
      :persistence_token => "facebook"
    })
  end
  
  def image
    avatar_url || "http://placehold.it/48x48"
  end
  
  def password_required?
    facebook_uid.blank? && twitter_uid.blank?
  end
  
  def email_available?
    twitter_uid.blank?
  end
  
  def update_user_from_facebook(auth_hash)
    self.update_attributes({
      :facebook_uid => auth_hash["uid"],
      :avatar_url => auth_hash["info"]["image"]
    })
  end
  
end