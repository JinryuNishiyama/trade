class Game < ApplicationRecord
  belongs_to :user

  with_options presence: true do
    validates :name
    validates :purpose
    validates :description
    validates :user_id
  end
end
