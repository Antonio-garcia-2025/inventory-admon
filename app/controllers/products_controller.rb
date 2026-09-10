# frozen_string_literal: true

class ProductsController < ApplicationController
  # Permite que visitantes no autenticados puedan ver el detalle del producto (show)
  skip_before_action :authenticate_user!, only: %i[show]
  
  # Acciones públicas de lectura
  before_action :set_public_product, only: %i[show]

  # Acciones privadas del vendedor (solo el dueño puede editar, borrar o vender)
  before_action :set_seller_product, only: %i[edit update destroy sell]

  # GET /products
  def index
    cargar_datos_index
  end

  # GET /products/1
  def show
    # @product ya está cargado limpiamente por :set_public_product
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
      'LOWER(name) = ? AND category_id IS NOT DISTINCT FROM ?',
      product_params[:name].to_s.strip.downcase,
      product_params[:category_id].presence
    ).first

    if existing_product
      additional_stock = product_params[:stock].to_i
      new_price = product_params[:price].presence || existing_product.price

      existing_product.stock += additional_stock
      existing_product.price = new_price

      if existing_product.save
        redirect_to products_path,
                    notice: "Se sumaron #{additional_stock} unidades a '#{existing_product.name}'. Stock total: #{existing_product.stock}."
      else
        cargar_datos_index
        render :index, status: :unprocessable_content
      end
    else
      @product = current_user.products.build(product_params)

      if @product.save
        redirect_to products_path, notice: "Producto '#{@product.name}' creado exitosamente."
      else
        cargar_datos_index
        render :index, status: :unprocessable_content
      end
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Producto '#{@product.name}' actualizado exitosamente."
    else
      @categories = current_user.categories.order(:name)
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_path, notice: 'Producto eliminado correctamente.'
  end

  # POST /products/1/sell
  def sell
    if @product.stock.to_i.positive?
      @product.decrement!(:stock)

      current_user.sales.create(product: @product, price: @product.price) if defined?(Sale) && current_user.respond_to?(:sales)

      redirect_to products_path, notice: "¡Venta registrada para '#{@product.name}'! Stock restante: #{@product.stock}"
    else
      redirect_to products_path, alert: "No hay existencias para vender '#{@product.name}'."
    end
  end

  private

  # Para SHOW: cualquier usuario puede ver los detalles de cualquier producto
  def set_public_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to store_path, alert: 'El producto solicitado no existe o fue retirado.'
  end

  # Para EDIT, UPDATE, DESTROY, SELL: solo el vendedor dueño del producto tiene permiso
  def set_seller_product
    @product = current_user.products.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: 'Producto no encontrado o no tienes permiso para modificarlo.'
  end

def cargar_datos_index
    @products = current_user.products.order(created_at: :desc)
    @total_products = @products.count
    @total_stock = @products.sum(:stock)
    @product ||= current_user.products.build
    @categories = current_user.categories.order(:name)

    # Reputación
    @seller_rating = current_user.seller_rating
    @seller_reviews_count = current_user.received_reviews.count
    @recent_reviews = current_user.received_reviews.includes(:user, :product).order(created_at: :desc).limit(5)

    # Ventas reales calculadas desde OrderItem
    @total_revenue = current_user.total_revenue
    @total_pieces_sold = current_user.total_pieces_sold
    @total_sales_count = current_user.total_sales_count
    @recent_sales = current_user.sold_items.includes(:product, :order).order(created_at: :desc).limit(10)
  end

  def product_params
    params.expect(product: %i[name price stock category_id image])
  end
end