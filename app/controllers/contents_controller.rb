class ContentsController < ApplicationController

  def index
    plog = Plog.find(params[:plog_id])
    contents = plog.contents
    render json: contents
  end
    # POST /plog/:plog_id/contents
  def create
    plog = Plog.find(params[:plog_id])
    content = plog.contents.build(content_params)
    if content.save
      render json: content, status: :created
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # PATCH/PUT /plog/:plog_id/contents/:id
  def update
    content = Content.find(params[:id])
    if content.update(content_params)
      render json: content
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # DELETE /plog/:plog_id/contents/:id
  def destroy
    content = Content.find(params[:id])
    if content.user_id == current_user.id
      content.update(is_deleted: true)
      render json: { message: 'Content deleted successfully' }, status: :ok
    else
      render json: { error: 'Not authorized to delete this content' }, status: :unauthorized
    end
  end

  private
  def content_params
    params.require(:content).permit(:content_ar, :content_en, :plog_id,:is_published)
  end
end