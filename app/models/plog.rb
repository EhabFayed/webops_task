class Plog < ApplicationRecord
  extend Enumerize
  validates :title_ar, presence: true
  validates :title_en, presence: true

  enumerize :category, in: {all: 0, Branding: 1, Web_design: 2, Graphic_design: 3, digital_marketing: 4, e_commerce: 5 }
  # Optionally, you can add logic for "archived" or "deleted" posts
  scope :published, -> { where(is_deleted: false, is_published: true) }
  scope :not_ready, -> { where(is_published: false) }
  scope :deleted, -> { where(is_deleted: true) }

  has_many :faqs
  has_many :contents
  has_many :photos



  class << self
    def plog_boilerplate
      data=[]
      Plog.published.each do |plog|
        data << {
          id: plog.id,
          photo_id: plog.photo_id,
          title_ar: plog.title_ar,
          title_en: plog.title_en,
          category: plog.category,
        }
      end
      data
    end

    def plog_details(plog_id)
      plog = Plog.find_by(id: plog_id)
      return nil unless plog

      {
        id: plog.id,#i guess we dont need it here again
        photo_id: plog.photo_id,
        title_ar: plog.title_ar,
        title_en: plog.title_en,
        category: plog.category,
        # photos: plog.photos,
        contents: plog.contents.where(plog_id: plog.id).map do |content|
          {
            id: content.id,
            content: content.content
          }
        end,
        faqs: plog.faqs.where(is_deleted: false , is_published: false).map do |faq|
          {
            id: faq.id,
            question: faq.question,
            answer: faq.answer
          }
        end
      }
    end
  end
end
