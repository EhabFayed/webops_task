class User < ApplicationRecord
  has_secure_password
  has_many :plogs
  has_many :faqs
  has_many :contents
  has_one_attached :image

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-zA-Z\d\-.]+\.[a-zA-Z]+\z/, message: "must be a valid email format" }
  validates :password, presence: true, length: { minimum: 6 }
  validate :email_unchanged, on: :update

  def email_unchanged
    if email_changed?
      errors.add(:email, "cannot be changed once set")
    end
  end
end
