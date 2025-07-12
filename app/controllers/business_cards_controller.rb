class BusinessCardsController < ApplicationController
  def new
    @business_card = BusinessCard.new
  end

  def create
    @business_card = BusinessCard.new(business_card_params)
    
    if @business_card.save
      # Gemini APIで解析
      analysis_result = GeminiService.analyze_business_card(@business_card.image)
      
      if analysis_result[:success]
        @business_card.update(analysis_result[:data])
        redirect_to @business_card, notice: '名刺を正常に読み取りました'
      else
        @business_card.update(raw_response: analysis_result[:error])
        redirect_to @business_card, alert: '読み取りに失敗しました'
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @business_card = BusinessCard.find(params[:id])
  end

  private

  def business_card_params
    params.require(:business_card).permit(:image)
  end
end