class Content < ApplicationRecord
validates :content, presence: true
belongs_to :plog, required: true


def sections_data(plog_id)
  contents = Content.where(plog_id: plog_id)
  contents.map do |content|
    {
      id: content.id,
      content: content.content
    }
  end

end