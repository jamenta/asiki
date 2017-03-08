class Invitation < ApplicationRecord
validates_uniqueness_of :email, :scope => :contest_id
belongs_to :contest
end
