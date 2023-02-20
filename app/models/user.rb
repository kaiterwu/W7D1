# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, uniqueness: true, presence: true 
    validates :password_digest, presence: true 
    before_validation
    
    attr_reader :password 

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password 
    end 

    def is_password?(password)
        bcrypt_obj = BCrypt::Password.new(self.password_digest)
        bcrypt_obj.is_password?(password)
    end 

    def self.find_by_credentials(username,password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user 
        else   
            nil  
        end 
    end 

    def reset_session_token!

    end 
    private
    def generate_unique_session_token 
        token = SecureRandom::urlsafe_base64
        while User.exists?(session_token:token)
            token = SecureRandom::urlsafe_base64
        end 
        token 
    end 

    def ensure_session_token

    end 
end
