class PlogsController < ApplicationController

  # GET /plogs
  def index
    plogs = Plog
      .not_deleted
      .includes(plog_photos: { photo_attachment: :blob })
      .order(:id)

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
            url: photo.photo.attached? ? url_for(photo.photo) : nil,
            alt: photo.is_arabic ? photo.alt_ar : photo.alt_en,
            is_arabic: photo.is_arabic
          }
        },
        meta_description_ar: plog.meta_description_ar,
        meta_description_en: plog.meta_description_en,
        meta_title_ar: plog.meta_title_ar,
        meta_title_en: plog.meta_title_en,
        is_published: plog.is_published
      }
    }
end

  # GET /plogs/:id
  def show
    plog = Plog
      .includes(
        plog_photos: { photo_attachment: :blob },
        contents: { content_photos: { photo_attachment: :blob } },
        faqs: []
      )
      .find(params[:id])

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
      is_published: plog.is_published,
      contents: plog.contents
        .where(is_deleted: false)
        .order(:id)
        .map { |content|
          {
            id: content.id,
            content_ar: content.content_ar,
            content_en: content.content_en,
            is_published: content.is_published,
            photos: content.content_photos.map { |cp|
              {
                id: cp.id,
                url: cp.cached_photo_url,
                alt_ar: cp.alt_ar,
                alt_en: cp.alt_en
              }
            }
          }
        },
      faqs: plog.faqs
        .where(is_deleted: false)
        .order(:id)
        .map { |faq|
          {
            id: faq.id,
            question_ar: faq.question_ar,
            question_en: faq.question_en,
            answer_ar: faq.answer_ar,
            answer_en: faq.answer_en,
            is_published: faq.is_published
          }
        }
    }
  end
  # POST /plogs
  def create
    plog = Plog.new(plog_params)

    if plog.save
      render json: {message: 'Plog created successfully'}, status: :created
    else
      render json: { error: plog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /plogs/:id
  def update
    plog = Plog.find(params[:id])

    if plog.update(plog_params)
      render json: {message: 'Plog updated successfully'}, status: :ok
    else
      render json: { error: plog.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
    plog = Plog.find(params[:id])
    plog.destroy
    render json: { message: 'Plog deleted successfully' }, status: :ok
  end

  private

  def plog_params
    params.require(:plog).permit(
      :title_ar,
      :title_en,
      #:image_alt_text_ar,
      #:image_alt_text_en,
      :meta_title_ar,
      :meta_title_en,
      :slug,
      :meta_description_ar,
      :meta_description_en,
      :category,
      :is_published,
      # :photo_id,
      :slug_ar,
      plog_photos_attributes: [:id, :photo, :alt_ar, :alt_en, :is_arabic, :_destroy]
    )
  end
end
