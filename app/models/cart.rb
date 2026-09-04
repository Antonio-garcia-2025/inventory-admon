# frozen_string_literal: true

class Cart < ApplicationRecord
  # optional: true permite carritos de visitantes anónimos si quisiéramos en el futuro
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # Suma el total_price de cada uno de los items del carrito
  def total_price
    cart_items.includes(:product).sum(&:total_price)
  end

  # Cantidad total de productos sumados (para mostrar en el badge del navbar)
  def total_items_count
    cart_items.sum(:quantity)
  end
end
