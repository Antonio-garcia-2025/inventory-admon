class StoreController < ApplicationController
  # Permitir ver la tienda pública sin obligar a iniciar sesión inmediatamente
  skip_before_action :authenticate_user!, only: [:index]

  # GET / (o /store)
  def index
    # Trae todos los productos con stock disponible y que tengan vendedor asociado
    @categories = Category.order(:name)
    
    if params[:category_id].present?
      @products = Product.includes(:user, :category).where(category_id: params[:category_id]).where("stock > 0").order(created_at: :desc)
      @selected_category = Category.find_by(id: params[:category_id])
    else
      @products = Product.includes(:user, :category).where("stock > 0").order(created_at: :desc)
    end
  end

  # POST /store/buy/:id
  def buy
    # Para comprar sí requerimos que el usuario tenga sesión
    authenticate_user!

    @product = Product.find(params[:id])

    if @product.stock.to_i > 0
      @product.decrement!(:stock)

      # Registrar la venta en la cuenta del vendedor que posee el producto
      seller = @product.user
      if defined?(Sale) && seller.respond_to?(:sales)
        seller.sales.create(product: @product, price: @product.price)
      end

      redirect_to store_path, notice: "🎉 ¡Compra exitosa! Has adquirido '#{@product.name}' por #{helpers.number_to_currency(@product.price)}."
    else
      redirect_to store_path, alert: "Lo sentimos, '#{@product.name}' se ha agotado."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to store_path, alert: "El producto seleccionado ya no está disponible."
  end
end