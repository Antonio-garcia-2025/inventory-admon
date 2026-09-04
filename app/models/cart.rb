# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total_price
    cart_items.includes(:product).sum { |item| item.product ? (item.quantity * item.product.price) : 0 }
  end

  # Conteo total de piezas en el carrito
  def total_items_count
    cart_items.sum(:quantity) || 0
  end
  alias_method :total_items, :total_items_count
end