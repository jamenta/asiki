class Contest < ApplicationRecord
	belongs_to :user
	has_many :contestants, :dependent => :destroy
	has_many :contest_comments, :dependent => :destroy
	has_many :invitations, :dependent => :destroy
	accepts_nested_attributes_for :contestants
end
