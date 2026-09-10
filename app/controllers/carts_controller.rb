# frozen_string_literal: true

class CartsController < ApplicationController
  # Si no está autenticado, Devise lo redirige de inmediato a /users/sign_in
  before_action :authenticate_user!

  def show
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(:product)
  end

  def add
    product = Product.find(params[:product_id] || params[:id])
    quantity = params[:quantity].to_i
    quantity = 1 if quantity <= 0

    cart = current_cart
    cart_item = cart.cart_items.find_or_initialize_by(product: product)

    nueva_cantidad = (cart_item.persisted? ? cart_item.quantity : 0) + quantity

    if nueva_cantidad > product.stock
      redirect_back fallback_location: store_path, alert: "No hay suficiente stock disponible (disponibles: #{product.stock})."
      return
    end

    cart_item.quantity = nueva_cantidad
    cart_item.save!

    redirect_to cart_path, notice: "🛒 #{quantity} #{quantity == 1 ? 'pieza agregada' : 'piezas agregadas'} al carrito."
  end

  def remove
    cart_item = current_cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Producto eliminado del carrito."
  end

  def checkout
    cart = current_cart
    items = cart.cart_items.includes(:product)

    if items.empty?
      redirect_to store_path, alert: "Tu carrito está vacío."
      return
    end

    ActiveRecord::Base.transaction do
      # 1. Crear orden para el comprador
      order = current_user.orders.create!(
        total_price: cart.total_price,
        status: "completado"
      )

      items.each do |item|
        product = item.product

        if product.stock < item.quantity
          raise ActiveRecord::Rollback, "Stock insuficiente para #{product.name}."
        end

        # 2. Descontar stock del producto
        product.update!(stock: product.stock - item.quantity)

        # 3. Registrar el detalle de la orden (para ventas e historial)
        order.order_items.create!(
          product: product,
          quantity: item.quantity,
          unit_price: product.price
        )

        # 4. Registrar venta para el vendedor
        seller = product.user
        if seller.present?
          item.quantity.times do
            seller.sales.create!(product: product, price: product.price)
          end
        end
      end

      # 5. Vaciar carrito tras la compra exitosa
      cart.cart_items.destroy_all
      redirect_to orders_path, notice: "🎉 ¡Compra procesada exitosamente! Stock actualizado y venta registrada."
    end
  rescue => e
    redirect_to cart_path, alert: "Hubo un problema al procesar la compra: #{e.message}"
  end

  private

  def current_cart
    current_user.cart || current_user.create_cart!
  end
end