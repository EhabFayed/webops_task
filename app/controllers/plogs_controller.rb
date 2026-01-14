class PlogsController < ApplicationController

  # GET /plogs
  def index
    plogs = Plog.not_deleted.order(:id).map do |plog|
      {
        id: plog.id,
        title_ar: plog.title_ar,
        title_en: plog.title_en,
        category: plog.category,
        slug: plog.slug,
        slug_ar: plog.slug_ar,
        photo_url: plog.photo_id.attached? ? url_for(plog.photo_id) : nil,
        meta_description_ar: plog.meta_description_ar,
        meta_description_en: plog.meta_description_en,
        image_alt_text_ar: plog.image_alt_text_ar,
        image_alt_text_en: plog.image_alt_text_en,
        meta_title_ar: plog.meta_title_ar,
        meta_title_en: plog.meta_title_en,
        is_published: plog.is_published
      }
    end

    render json: plogs
  end

  # GET /plogs/:id
  def show
    plog = Plog.find(params[:id])
    data = {
          id: plog.id,
          title_ar: plog.title_ar,
          title_en: plog.title_en,
          category: plog.category,
          slug: plog.slug,
          slug_ar: plog.slug_ar,
          photo_url: plog.photo_id.attached? ? url_for(plog.photo_id) : nil,
          meta_description_ar: plog.meta_description_ar,
          meta_description_en: plog.meta_description_en,
          image_alt_text_ar: plog.image_alt_text_ar,
          image_alt_text_en: plog.image_alt_text_en,
          meta_title_ar: plog.meta_title_ar,
          meta_title_en: plog.meta_title_en,
          is_published: plog.is_published,
          contents: plog.contents.where(is_deleted: false).order(:id).map do |content|
            {
              id: content.id,
              content_ar: content.content_ar,
              content_en: content.content_en,
              is_published: content.is_published,
              photos: content.content_photos.map do |cp|
                {
                  id: cp.id,
                  url: cp.photo.attached? ? url_for(cp.photo) : nil,
                  alt_ar: cp.alt_ar,
                  alt_en: cp.alt_en
                }
              end
            }
          end,
          faqs: plog.faqs.where(is_deleted: false).order(:id).map do |faq|
            {
              id: faq.id,
              question_ar: faq.question_ar,
              question_en: faq.question_en,
              answer_ar: faq.answer_ar,
              answer_en: faq.answer_en,
              is_published: faq.is_published
            }
          end
        }

    render json: data
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
      :image_alt_text_ar,
      :image_alt_text_en,
      :meta_title_ar,
      :meta_title_en,
      :slug,
      :meta_description_ar,
      :meta_description_en,
      :category,
      :is_published,
      :photo_id,
      :slug_ar
    )
  end
end
