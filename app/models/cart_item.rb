# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Calcula el subtotal de esta línea: cantidad * precio del producto
  def total_price
    (product&.price || 0) * (quantity || 1)
  end
end
