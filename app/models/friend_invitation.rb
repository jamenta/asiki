class FriendInvitation < ApplicationRecord
  belongs_to :user
  before_save { |x| x.email = x.email.downcase }
  validates_uniqueness_of :email, :scope => :user_id, :case_sensitive => false
end
