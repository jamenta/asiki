class Exercise < ApplicationRecord
  belongs_to :workout, required: false
  has_many :results
  accepts_nested_attributes_for :results
end
