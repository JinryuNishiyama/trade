class Post < ApplicationRecord
  belongs_to :user
  belongs_to :game

  with_options presence: true do
    validates :text
    validates :user_id
    validates :game_id
  end
end
