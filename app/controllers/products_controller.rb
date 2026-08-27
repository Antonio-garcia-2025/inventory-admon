class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[show edit update destroy sell]

  # GET /products
  def index
    cargar_datos_index
  end

  # GET /products/1
  def show
  end

  # GET /products/new
  def new
    @product = current_user.products.build
    @categories = current_user.categories.order(:name)
  end

  # GET /products/1/edit
  def edit
    @categories = current_user.categories.order(:name)
  end

  # POST /products
  def create
    existing_product = current_user.products.where(
      "LOWER(name) = ? AND category_id IS NOT DISTINCT FROM ?",
      product_params[:name].to_s.strip.downcase,
      product_params[:category_id].presence
    ).first

    if existing_product
      additional_stock = product_params[:stock].to_i
      new_price = product_params[:price].presence || existing_product.price

      existing_product.stock += additional_stock
      existing_product.price = new_price

      if existing_product.save
        redirect_to products_path, notice: "Se sumaron #{additional_stock} unidades a '#{existing_product.name}'. Stock total: #{existing_product.stock}."
      else
        cargar_datos_index
        render :index, status: :unprocessable_entity
      end
    else
      @product = current_user.products.build(product_params)

      if @product.save
        redirect_to products_path, notice: "Producto '#{@product.name}' creado exitosamente."
      else
        cargar_datos_index
        render :index, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Producto '#{@product.name}' actualizado exitosamente."
    else
      @categories = current_user.categories.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_path, notice: "Producto eliminado correctamente."
  end

  # POST /products/1/sell
  def sell
    if @product.stock.to_i > 0
      @product.decrement!(:stock)

      if defined?(Sale) && current_user.respond_to?(:sales)
        current_user.sales.create(product: @product, price: @product.price)
      end

      redirect_to products_path, notice: "¡Venta registrada para '#{@product.name}'! Stock restante: #{@product.stock}"
    else
      redirect_to products_path, alert: "No hay existencias para vender '#{@product.name}'."
    end
  end

  private

  def set_product
    @product = current_user.products.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Producto no encontrado o no tienes permiso para acceder a él."
  end

  def cargar_datos_index
    @products = current_user.products.order(created_at: :desc)
    @total_products = @products.count
    @total_stock = @products.sum(:stock)
    @product ||= current_user.products.build
    @categories = current_user.categories.order(:name)

    if defined?(Sale) && current_user.respond_to?(:sales)
      @recent_sales = current_user.sales.includes(:product).order(created_at: :desc).limit(10)
      @total_sales_count = current_user.sales.count
      @total_revenue = current_user.sales.sum(:price)
    else
      @recent_sales = []
      @total_sales_count = 0
      @total_revenue = 0.0
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :stock, :category_id)
  end
end