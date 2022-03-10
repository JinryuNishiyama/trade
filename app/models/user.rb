class User < ApplicationRecord
  has_many :games
  has_many :posts
  has_many :likes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 16 }
  validates :admin, inclusion: { in: [true, false] }

  mount_uploader :icon, ImageUploader

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.name = "ゲストユーザー"
      user.password = "guestuser"
    end
  end

  def already_liked?(post)
    likes.exists?(post_id: post.id)
  end
end
