class Content < ApplicationRecord
  validates :content_ar, :content_en, presence: true

  belongs_to :plog
  belongs_to :user

  has_many_attached :photos
end
