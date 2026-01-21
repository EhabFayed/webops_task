class Plog < ApplicationRecord
  extend Enumerize

  validates :title_ar, :title_en, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :slug_ar, uniqueness: true, presence: true


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

  has_many :faqs, dependent: :destroy
  has_many :contents, dependent: :destroy
  # has_one_attached :photo_id, dependent: :destroy # Deprecated in favor of plog_photos
  has_many :plog_photos, dependent: :destroy
  accepts_nested_attributes_for :plog_photos, allow_destroy: true, reject_if: :all_blank

  validates :plog_photos, length: { maximum: 2, message: "can have at most 2 photos" }


  # app/models/plog.rb
  def self.find_by_any_slug(slug)
    find_by("slug = :s OR slug_ar = :s", s: slug)
  end

end
