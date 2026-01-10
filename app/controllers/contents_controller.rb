class ContentsController < ApplicationController
  # skip_before_action :authorize_request, only: [:create]
  # GET /plog/:plog_id/contents
  def index
    plog = Plog.find(params[:plog_id])
    contents = plog.contents.where(is_deleted: false).map do |content|
      {
        id: content.id,
        content_ar: content.content_ar,
        content_en: content.content_en,
        photos: content.content_photos.map do |cp|
          {
            cp_id: cp.id,
            url: cp.photo.attached? ? url_for(cp.photo) : nil,
            alt_ar: cp.alt_ar,
            alt_en: cp.alt_en
          }
        end
      }
    end
    render json: contents
  end

  # POST /plog/:plog_id/contents
  def create
    plog = Plog.find(params[:plog_id])
    content = plog.contents.build(content_params)
    content.user_id = current_user.id
    if content.save
      render json: {message: 'Content created successfully'}, status: :created
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /plog/:plog_id/contents/:id
  def update
    content = Content.find(params[:id])
    if content.update(content_params)
      render json: {message: 'Content updated successfully'}, status: :ok
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # DELETE /plog/:plog_id/contents/:id
  def destroy
    content = Content.find(params[:id])
      content.update(is_deleted: true)
      render json: { message: 'Content deleted successfully' }, status: :ok
  end

  private
  def content_params
  params.require(:content).permit(
    :content_ar,
    :content_en,
    :is_published,
    content_photos_attributes: [
      :id,
      :alt_ar,
      :alt_en,
      :photo,
      :_destroy
    ]
  )
  end

end