class Faq < ApplicationRecord
  validates :question, presence: true
  validates :answer, presence: true
  belongs_to :plog, optional: true

  scope :published, -> { where(is_published: true, is_deleted: false) }
  scope :global, -> { where(plog_id: nil) }
end
