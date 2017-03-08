class Result < ApplicationRecord
  belongs_to :exercise, required: false
  belongs_to :post, required: false
  belongs_to :workout, required: false
  belongs_to :user, required: false
  validates_presence_of :reps
end
