class WebSiteController < ApplicationController
skip_before_action :authorize_request


  def plogs_landing
    plogs= Plog.published.map do |plog|
      {
        id: plog.id,
        title_ar: plog.title_ar,
        title_en: plog.title_en,
        category: plog.category,
        slug: plog.slug,
        photo_url: plog.photo_id.attached? ? url_for(plog.photo_id) : nil,
        image_alt_text_ar: plog.image_alt_text_ar,
        image_alt_text_en: plog.image_alt_text_en,
      }
    end
    render json: plogs
  end
  def plog_show
    plog = Plog.find_by(slug: params[:slug])
    if plog
      data = {
            id: plog.id,
            title_ar: plog.title_ar,
            title_en: plog.title_en,
            category: plog.category,
            slug: plog.slug,
            photo_url: plog.photo_id.attached? ? url_for(plog.photo_id) : nil,
            meta_description_ar: plog.meta_description_ar,
            meta_description_en: plog.meta_description_en,
            image_alt_text_ar: plog.image_alt_text_ar,
            image_alt_text_en: plog.image_alt_text_en,
            meta_title_ar: plog.meta_title_ar,
            meta_title_en: plog.meta_title_en,
            contents: plog.contents.where(is_deleted: false, is_published: true).map do |content|
              {
                id: content.id,
                content_ar: content.content_ar,
                content_en: content.content_en,
                photos: content.content_photos.map do |cp|
                  {
                    url: cp.photo.attached? ? url_for(cp.photo) : nil,
                    alt_ar: cp.alt_ar,
                    alt_en: cp.alt_en
                  }
                end
              }
            end,
            faqs: plog.faqs.where(is_deleted: false, is_published: true).map do |faq|
              {
                id: faq.id,
                question_ar: faq.question_ar,
                question_en: faq.question_en,
                answer_ar: faq.answer_ar,
                answer_en: faq.answer_en,
              }
            end
          }

      render json: data
    else
      render json: { error: 'Plog not found' }, status: :not_found
    end
  end
end