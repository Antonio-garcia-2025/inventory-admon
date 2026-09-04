# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:checkout]

  # GET /cart
  def show
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(:product)
  end

  # POST /cart/add
  def add
    product = Product.find(params[:product_id])
    quantity = (params[:quantity] || 1).to_i

    cart = current_cart
    cart_item = cart.cart_items.find_or_initialize_by(product: product)
    
    nueva_cantidad = (cart_item.persisted? ? cart_item.quantity : 0) + quantity

    if nueva_cantidad > product.stock
      redirect_back fallback_location: store_path, alert: "No hay suficiente stock disponible."
      return
    end

    cart_item.quantity = nueva_cantidad
    cart_item.save!

    redirect_to cart_path, notice: "🛒 Producto agregado al carrito."
  end

  # DELETE /cart/remove/:id
  def remove
    cart_item = current_cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Producto eliminado del carrito."
  end

  # POST /cart/checkout
  def checkout
    cart = current_cart
    items = cart.cart_items.includes(:product)

    if items.empty?
      redirect_to store_path, alert: "Tu carrito está vacío."
      return
    end

    ActiveRecord::Base.transaction do
      # 1. Crear la orden principal
      order = current_user.orders.create!(
        total_price: cart.total_price,
        status: "completado"
      )

      items.each do |item|
        product = item.product

        if product.stock < item.quantity
          raise ActiveRecord::Rollback, "Stock insuficiente para #{product.name}."
        end

        # 2. Descontar inventario
        product.update!(stock: product.stock - item.quantity)

        # 3. Registrar venta para el vendedor
        seller = product.user
        if defined?(Sale) && seller.respond_to?(:sales)
          item.quantity.times do
            seller.sales.create!(product: product, price: product.price)
          end
        end

        # 4. Guardar cada producto en la orden del comprador
        order.order_items.create!(
          product: product,
          quantity: item.quantity,
          unit_price: product.price
        )
      end

      # 5. Vaciar el carrito
      cart.cart_items.destroy_all

      redirect_to orders_path, notice: "🎉 ¡Compra procesada exitosamente! Aquí tienes el recibo de tu pedido."
    end
  rescue => e
    redirect_to cart_path, alert: "Hubo un problema al procesar la compra: #{e.message}"
  end

  private

  private

  def current_cart
    if user_signed_in?
      # Si el usuario inició sesión, buscamos su carrito existente o lo creamos asignado a él
      current_user.cart || current_user.create_cart!
    elsif session[:cart_id]
      Cart.find_by(id: session[:cart_id]) || create_cart
    else
      create_cart
    end
  end

  def create_cart
    # Si hay usuario autenticado se le asigna; si no, intenta crearlo
    cart = Cart.create!(user: current_user)
    session[:cart_id] = cart.id
    cart
  end
end