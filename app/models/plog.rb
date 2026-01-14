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
  has_one_attached :photo_id, dependent: :destroy


  # app/models/plog.rb
  def self.find_by_any_slug(slug)
    find_by("slug = :s OR slug_ar = :s", s: slug)
  end

end
