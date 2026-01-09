class FaqsController < ApplicationController


  # GET /plog/:plog_id/faqs
  def index
    plog = Plog.find(params[:plog_id])
    faqs = plog.faqs
    render json: faqs
  end

  # POST /plog/:plog_id/faqs
  def create
    plog = Plog.find(params[:plog_id])

    faq = plog.faqs.build(faq_params)
    faq.user_id = current_user.id
    if faq.save
      render json: faq, status: :created
    else
      render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT plog/:plog_id/faqs/:id
  def update
    faq = Faq.find(params[:id])

    if faq.user_id == current_user.id
      if faq.update(faq_params)
        render json: faq
      else
        render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not authorized to update this faq' }, status: :unauthorized
    end
  end

  # DELETE plog/:plog_id/faqs/:id
  def destroy
    faq = Faq.find(params[:id])

    if faq.user_id == current_user.id
      faq.update(is_deleted: true)
      head :no_content
    else
      render json: { error: 'Not authorized to delete this faq' }, status: :unauthorized
    end
  end

  private

  def faq_params
    params.require(:faq).permit(plog_id: params[:plog_id], :question_ar, :question_en, :answer_ar, :answer_en, :is_published)
  end
end
