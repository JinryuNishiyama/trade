class Game < ApplicationRecord
  validates :name, presence: true
  validates :purpose, presence: true
  validates :description, presence: true
end
