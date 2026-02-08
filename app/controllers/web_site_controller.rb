class WebSiteController < ApplicationController
  skip_before_action :authorize_request

  def plogs_landing
    plogs = Plog.published
                .includes(plog_photos: { photo_attachment: :blob })

    render json: plogs.map { |plog|
      {
        id: plog.id,
        title_ar: plog.title_ar,
        title_en: plog.title_en,
        category: plog.category,
        slug: plog.slug,
        slug_ar: plog.slug_ar,
        photos: plog.plog_photos.map { |photo|
          {
            id: photo.id,
            url: photo.cached_photo_url,
            alt: photo.is_arabic ? photo.alt_ar : photo.alt_en,
            is_arabic: photo.is_arabic
          }
        }
      }
    }
  end

  def plog_show
    plog = Plog
      .includes(
        plog_photos: { photo_attachment: :blob },
        contents: { content_photos: { photo_attachment: :blob } },
        faqs: []
      )
      .find_by_any_slug(params[:slug])

    return render json: { error: "Plog not found" }, status: :not_found unless plog

    render json: {
      id: plog.id,
      title_ar: plog.title_ar,
      title_en: plog.title_en,
      category: plog.category,
      slug: plog.slug,
      slug_ar: plog.slug_ar,
      photos: plog.plog_photos.map { |photo|
        {
          id: photo.id,
          url: photo.cached_photo_url,
          alt: photo.is_arabic ? photo.alt_ar : photo.alt_en,
          is_arabic: photo.is_arabic
        }
      },
      meta_description_ar: plog.meta_description_ar,
      meta_description_en: plog.meta_description_en,
      meta_title_ar: plog.meta_title_ar,
      meta_title_en: plog.meta_title_en,
      contents: plog.contents
        .where(is_deleted: false, is_published: true)
        .order(:id)
        .map { |content|
          {
            id: content.id,
            content_ar: content.content_ar,
            content_en: content.content_en,
            photos: content.content_photos.map { |cp|
              {
                url: cp.cached_photo_url,
                alt_ar: cp.alt_ar,
                alt_en: cp.alt_en
              }
            }
          }
        },
      faqs: plog.faqs
        .where(is_deleted: false, is_published: true)
        .order(:id)
        .map { |faq|
          {
            id: faq.id,
            question_ar: faq.question_ar,
            question_en: faq.question_en,
            answer_ar: faq.answer_ar,
            answer_en: faq.answer_en
          }
        }
    }
  end

  def faq_about_us
    faqs = Faq.where(is_deleted: false, is_published: true, plog_id: nil)
              .order(:id)

    render json: faqs.map { |faq|
      {
        id: faq.id,
        question_ar: faq.question_ar,
        question_en: faq.question_en,
        answer_ar: faq.answer_ar,
        answer_en: faq.answer_en
      }
    }
  end
end
