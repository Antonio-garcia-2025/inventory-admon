class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[show edit update destroy sell]

  # GET /products
  def index
    @products = current_user.products.order(created_at: :desc)
    @total_products = @products.count
    @total_stock = @products.sum(:stock)
    
    # Formulario embebido
    @product ||= current_user.products.build

    # Categorías para el selector
    @categories = current_user.categories.order(:name)

    # Ventas recientes (evita que @recent_sales sea nil)
    if current_user.respond_to?(:sales)
      @recent_sales = current_user.sales.order(created_at: :desc).limit(10)
    else
      @recent_sales = []
    end
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
    @product = current_user.products.build(product_params)

    if @product.save
      redirect_to products_path, notice: "Producto creado exitosamente."
    else
      @products = current_user.products.order(created_at: :desc)
      @total_products = @products.count
      @total_stock = @products.sum(:stock)
      @categories = current_user.categories.order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Producto actualizado exitosamente."
    else
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
      redirect_to products_path, notice: "Venta registrada para '#{@product.name}'. Stock restante: #{@product.stock}"
    else
      redirect_to products_path, alert: "No hay existencias suficientes para vender '#{@product.name}'."
    end
  end

  private

  def set_product
    @product = current_user.products.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Producto no encontrado o no tienes permiso para acceder a él."
  end

  def product_params
    params.require(:product).permit(:name, :price, :stock, :category_id)
  end
end