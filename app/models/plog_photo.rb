class PlogPhoto < ApplicationRecord
  belongs_to :plog
  has_one_attached :photo

  # validates :alt_ar, :alt_en, presence: true
end
