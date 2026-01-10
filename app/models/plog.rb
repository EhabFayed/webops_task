class Plog < ApplicationRecord
  extend Enumerize

  validates :title_ar, :title_en, presence: true

  enumerize :category, in: {
    all: 0,
    Branding: 1,
    Web_design: 2,
    Graphic_design: 3,
    digital_marketing: 4,
    e_commerce: 5
  }

  scope :not_deleted, -> { where(is_deleted: false) }
  scope :published, -> { where(is_deleted: false, is_published: true) }

  has_many :faqs
  has_many :contents
  has_one_attached :photo_id
end
