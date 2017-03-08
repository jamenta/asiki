class User < ApplicationRecord
     has_secure_password
     before_save { |user| user.email = user.email.downcase }
     validates :password, presence: true, length: { minimum: 8 }, on: :create
     validates :email, presence: true, uniqueness: {:case_sensitive => false}
     validates :state, presence: true
     validates :first_name, presence: true, length: { maximum: 25 }
     validates :last_name, presence: true, length: { maximum: 25 }
	
	has_many :results
	has_many :contests
	has_many :contestants
	has_many :contest_comments
	has_many :posts
	has_many :friends
	has_many :friend_invitations
	has_many :notifications
	has_many :messages
	
end
