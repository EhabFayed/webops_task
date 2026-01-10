class Content < ApplicationRecord
  validates :content_ar, :content_en, presence: true

  belongs_to :plog
  belongs_to :user

  has_many :content_photos, dependent: :destroy
  accepts_nested_attributes_for :content_photos, allow_destroy: true

end
