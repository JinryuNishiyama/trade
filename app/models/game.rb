class Game < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :purpose, presence: true
  validates :description, presence: true
end
