class Message < ApplicationRecord
belongs_to :user
validates :sender_id, presence: true
end
