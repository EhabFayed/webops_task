class ContentsController < ApplicationController
  # skip_before_action :authorize_request, only: [:create]
  def index
    plog = Plog.find(params[:plog_id])
    contents = plog.contents
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
    params.require(:content).permit(:content_ar, :content_en, :plog_id,:is_published)
  end
end