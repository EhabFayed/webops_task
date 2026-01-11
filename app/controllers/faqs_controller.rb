class FaqsController < ApplicationController


  # GET /plog/:plog_id/faqs
  def index
    plog = Plog.find(params[:plog_id])
    faqs = plog.faqs.where(is_deleted: false).order(:id).map do |faq|
      {
        id: faq.id,
        question_ar: faq.question_ar,
        question_en: faq.question_en,
        answer_ar: faq.answer_ar,
        answer_en: faq.answer_en,
        is_published: faq.is_published
      }
    end
    render json: faqs
  end

  # POST /plog/:plog_id/faqs
  def create
    plog = Plog.find(params[:plog_id])

    faq = plog.faqs.build(faq_params)
    faq.user_id = current_user.id
    if faq.save
      render json: {message: 'Faq created successfully'}, status: :created
    else
      render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /faqs
  # This action allows creating a FAQ without a plog reference
  def create_without_plog
    faq = Faq.new(faq_params)
    faq.user_id = current_user.id
    if faq.save
      render json: {message: 'Faq created successfully'}, status: :created
    else
      render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # GET /faqs
  def index_without_plog
    faqs = Faq.where(is_deleted: false, plog_id: nil).order(:id).map do |faq|
      {
        id: faq.id,
        question_ar: faq.question_ar,
        question_en: faq.question_en,
        answer_ar: faq.answer_ar,
        answer_en: faq.answer_en,
        is_published: faq.is_published
      }
    end
    render json: faqs
  end
  # PATCH/PUT /faqs/:id
  def update_without_plog
    faq = Faq.find(params[:id])
    if faq.update(faq_params)
      render json: {message: 'Faq updated successfully'}, status: :ok
    else
      render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # DELETE /faqs/:id
  def delete_without_plog
    faq = Faq.find(params[:id])
    faq.update(is_deleted: true)
    render json: { message: 'Faq deleted successfully' }, status: :ok
  end
  # PATCH/PUT plog/:plog_id/faqs/:id
  def update
    faq = Faq.find(params[:id])
      if faq.update(faq_params)
        render json: {message: 'Faq updated successfully'}, status: :ok
      else
        render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
      end
  end

  # DELETE plog/:plog_id/faqs/:id
  def destroy
    faq = Faq.find(params[:id])
    faq.destroy
    render json: { message: 'Faq deleted successfully' }, status: :ok
  end

  private

  def faq_params
    params.require(:faq).permit(:question_ar, :question_en, :answer_ar, :answer_en, :is_published)
  end
end
