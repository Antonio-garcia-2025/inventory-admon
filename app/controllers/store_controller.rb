class StoreController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @categories = Category.order(:name)

    scope = Product.includes(:user, :category).with_attached_image.where("stock > 0")

    if params[:category_id].present?
      @products = scope.where(category_id: params[:category_id]).distinct.order(created_at: :desc)
    else
      @products = scope.distinct.order(created_at: :desc)
    end
  end

  def buy
    authenticate_user!

    @product = Product.find(params[:id])

    if @product.stock.to_i > 0
      @product.decrement!(:stock)

      seller = @product.user
      if defined?(Sale) && seller.respond_to?(:sales)
        seller.sales.create(product: @product, price: @product.price)
      end

      redirect_to store_path, notice: "🎉 ¡Compra exitosa! Has adquirido '#{@product.name}'."
    else
      redirect_to store_path, alert: "Lo sentimos, '#{@product.name}' se ha agotado."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to store_path, alert: "El producto ya no está disponible."
  end
end