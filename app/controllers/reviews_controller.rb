# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product

  def create
    # 1. Verificar si el usuario ha comprado este producto
    has_purchased = current_user.orders.joins(:order_items)
                                .where(order_items: { product_id: @product.id })
                                .exists?

    unless has_purchased
      redirect_to product_path(@product), alert: "Debes comprar este producto antes de calificarlo."
      return
    end

    # 2. Buscar si ya tenía una reseña previa o crear una nueva
    # Si prefieres que cada compra actualice su calificación global:
    @review = @product.reviews.find_or_initialize_by(user: current_user)
    @review.assign_attributes(review_params)

    if @review.save
      redirect_to product_path(@product), notice: "⭐ ¡Gracias! Tu reseña ha sido registrada exitosamente."
    else
      redirect_to product_path(@product), alert: @review.errors.full_messages.to_sentence
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end