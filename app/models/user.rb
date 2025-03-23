class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Attach an image to the user
  has_one_attached :image

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-zA-Z\d\-.]+\.[a-zA-Z]+\z/, message: "must be a valid email format" }
  validates :password, presence: true, length: { minimum: 6 }
end
