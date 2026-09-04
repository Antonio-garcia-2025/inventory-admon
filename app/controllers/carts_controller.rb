# POST /cart/checkout (Comprar todo el carrito y generar la orden)
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