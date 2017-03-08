class Post < ApplicationRecord
  has_many :results, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  belongs_to :user, required: false
  belongs_to :workout, required: false
  attr_accessor :results_attributes
  validates_length_of :comment, maximum: 141, allow_blank: true
end