class Contestant < ApplicationRecord
	belongs_to :contest, required: false
	belongs_to :user, required: false
    validates_uniqueness_of :user_id, :scope => :contest_id
	attr_accessor :email
end
