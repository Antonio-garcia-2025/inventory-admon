class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product

  def create
    # Evitar que el vendedor se califique a sí mismo
    if @product.user == current_user
      redirect_to @product, alert: 'No puedes calificar tu propio producto.'
      return
    end

    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: '⭐ ¡Gracias por tu reseña!'
    else
      redirect_to @product, alert: @review.errors.full_messages.to_sentence
    end
  end

  def destroy
    @review = @product.reviews.find(params[:id])

    # Solo el autor o un administrador puede borrar la reseña
    if @review.user == current_user || (current_user.respond_to?(:admin?) && current_user.admin?)
      @review.destroy
      redirect_to @product, notice: 'Reseña eliminada con éxito.'
    else
      redirect_to @product, alert: 'No tienes permiso para eliminar esta reseña.'
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
