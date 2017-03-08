class Workout < ApplicationRecord
	has_many :exercises, :dependent => :destroy
	has_many :posts, :dependent => :destroy
	has_many :results, through: :posts, :dependent => :destroy
	accepts_nested_attributes_for :exercises, reject_if: proc { |attr| attr['exercise_description'].blank? }
end
