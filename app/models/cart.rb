# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total_price
    cart_items.includes(:product).sum { |item| item.product ? (item.quantity * item.product.price) : 0 }
  end

  def total_items
    cart_items.sum(:quantity)
  end
end