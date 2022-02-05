class Game < ApplicationRecord
  belongs_to :user
  has_many :posts

  with_options presence: true do
    validates :name
    validates :purpose
    validates :description
    validates :user_id
  end
end
