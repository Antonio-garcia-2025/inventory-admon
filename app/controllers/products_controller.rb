# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_public_product, only: %i[show]
  before_action :set_seller_product, only: %i[edit update destroy sell]
  skip_before_action :authenticate_user!, only: %i[show]

  def index
    cargar_datos_index
  end

  def show; end

  def new
    @product = current_user.products.new
    @categories = current_user.categories.order(:name)
  end

  def edit
    @categories = current_user.categories.order(:name)
  end

  # POST /products
  def create
    attributes = product_params_with_category

    existing_product = current_user.products.where(
      'LOWER(name) = ? AND category_id IS NOT DISTINCT FROM ?',
      attributes[:name].to_s.strip.downcase,
      attributes[:category_id].presence
    ).first

    if existing_product
      additional_stock = attributes[:stock].to_i
      new_price = attributes[:price].presence || existing_product.price

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
      @product = current_user.products.build(attributes)

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
    if @product.update(product_params_with_category)
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
    quantity = params[:quantity].to_i.positive? ? params[:quantity].to_i : 1

    if @product.stock.to_i >= quantity
      @product.decrement!(:stock, quantity)

      if defined?(Sale) && current_user.respond_to?(:sales)
        quantity.times do
          current_user.sales.create(product: @product, price: @product.price)
        end
      end

      redirect_to products_path,
                  notice: "¡Venta mayorista exitosa! Se despacharon #{quantity} unidades de '#{@product.name}'. Stock restante: #{@product.stock}"
    else
      redirect_to products_path,
                  alert: "Stock insuficiente. Intentas vender #{quantity} unidades, pero solo hay #{@product.stock} disponibles."
    end
  end

  private

  def set_public_product
    @product = Product.find(params.expect(:id))
  rescue ActiveRecord::RecordNotFound
    redirect_to store_path, alert: 'El producto solicitado no existe o fue retirado.'
  end

  def set_seller_product
    @product = current_user.products.find(params.expect(:id))
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: 'Producto no encontrado o no tienes permiso para modificarlo.'
  end

  def product_params_with_category
    attributes = product_params
    category_name_cleaned = params.fetch(:category_name, '').to_s.strip
    return attributes if category_name_cleaned.blank?

    category_name_cleaned = category_name_cleaned.capitalize
    category = current_user.categories.find_or_create_by(name: category_name_cleaned)
    attributes.merge(category_id: category.id)
  end

  def cargar_datos_index
    @products = current_user.products.order(created_at: :desc)
    @total_products = @products.count
    @total_stock = @products.sum(:stock)
    @product ||= current_user.products.build
    @categories = current_user.categories.order(:name)

    @seller_rating = current_user.seller_rating
    @seller_reviews_count = current_user.received_reviews.count
    @recent_reviews = current_user.received_reviews.includes(:user, :product).order(created_at: :desc).limit(5)

    @total_revenue = current_user.total_revenue
    @total_pieces_sold = current_user.total_pieces_sold
    @total_sales_count = current_user.total_sales_count
    @recent_sales = current_user.sold_items.includes(:product, :order).order(created_at: :desc).limit(10)
  end

  def product_params
    params.expect(product: %i[name price stock category_id image])
  end
end
