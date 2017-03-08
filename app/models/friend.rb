class Friend < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :friend_id, :scope => :user_id
end
