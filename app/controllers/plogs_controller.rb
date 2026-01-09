class PlogsController < ApplicationController

  # GET /plogs
  def index
    plogs = Plog.plog_boilerplate
    render json: plogs
  end

  # GET /plogs/:id
  def show
    plog = Plog.plog_details(params[:id])
    render json: plog
  end

  # POST /plogs
  def create
    plog = current_user.plogs.build(plog_params)
    if plog.save
      render json: plog, status: :created
    else
      render json: { error: plog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /plogs/:id
  def update
    plog = Plog.find(params[:id])

    if plog.user_id == current_user.id
      if plog.update(plog_params)
        render json: plog
      else
        render json: { error: plog.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not authorized to update this plog' }, status: :unauthorized
    end
  end

  # DELETE /plogs/:id
  def destroy
    plog = Plog.find(params[:id])

    if plog.user_id == current_user.id
      plog.update(is_deleted: true)
      render json: { message: 'Plog deleted successfully' }, status: :ok
    else
      render json: { error: 'Not authorized to delete this plog' }, status: :unauthorized
    end
  end

  private

  def plog_params
    params.require(:plog).permit( :title_ar, :title_en, :image_alt_text_ar, :image_alt_text_en,
                                 :meta_title_ar, :meta_title_en, :slug, :meta_description_ar, :meta_description_en,:category,:is_published )
  end
end
