# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :sales, dependent: :destroy

  has_many :received_reviews, through: :products, source: :reviews
  has_many :sold_items, through: :products, source: :order_items

  def display_name
    username.presence || email.split('@').first.capitalize
  end

  # Ingresos acumulados reales
  def total_revenue
    items_total = sold_items.includes(:product).sum { |item| (item.quantity || 0) * (item.unit_price || 0.0) }
    return items_total if items_total > 0

    # Respaldo si existen ventas guardadas en la tabla 'sales'
    sales.sum(:price) || 0.0
  end

  # Total de piezas vendidas
  def total_pieces_sold
    items_count = sold_items.sum(:quantity)
    return items_count if items_count > 0

    sales.count
  end

  # Conteo de órdenes atendidas
  def total_sales_count
    sold_items.select(:order_id).distinct.count
  end

  def seller_rating
    return 0.0 if received_reviews.empty?
    received_reviews.average(:rating).to_f.round(1)
  end

  def seller_stars
    avg = seller_rating.round
    ('★' * avg) + ('☆' * (5 - avg))
  end
end