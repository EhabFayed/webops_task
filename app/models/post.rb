class Post < ApplicationRecord

  belongs_to :user, foreign_key: "user_id"
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :tags, presence: true
  validate :must_have_at_least_one_tag

  private
  def must_have_at_least_one_tag
    errors.add(:tags, "must have at least one tag") if tags.blank? || tags.split(',').length < 1
  end
end
