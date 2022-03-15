class Post < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :likes, dependent: :destroy

  with_options presence: true do
    validates :text
    validates :chat_num
    validates :user_id
    validates :game_id
  end
end
