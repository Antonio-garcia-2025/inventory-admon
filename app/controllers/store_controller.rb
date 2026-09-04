class StoreController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @categories = Category.order(:name)

    scope = Product.includes(:user, :category).with_attached_image.where('stock > 0')

    # Filtro 1: Por categoría si existe
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?

    # Filtro 2: Búsqueda compatible con SQLite y PostgreSQL
    if params[:query].present?
      search_term = "%#{params[:query].strip.downcase}%"
      # LOWER(...) LIKE LOWER(...) funciona en cualquier motor de base de datos
      scope = scope.where('LOWER(products.name) LIKE ?', search_term)
    end

    @products = scope.distinct.order(created_at: :desc)
  end

  def buy
    authenticate_user!

    @product = Product.find(params[:id])

    if @product.stock.to_i > 0
      @product.decrement!(:stock)

      seller = @product.user
      seller.sales.create(product: @product, price: @product.price) if defined?(Sale) && seller.respond_to?(:sales)

      redirect_to store_path, notice: "🎉 ¡Compra exitosa! Has adquirido '#{@product.name}'."
    else
      redirect_to store_path, alert: "Lo sentimos, '#{@product.name}' se ha agotado."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to store_path, alert: 'El producto ya no está disponible.'
  end

  scope = Product.includes(:user, :category, reviews: :user).with_attached_image.where('stock > 0')
end
