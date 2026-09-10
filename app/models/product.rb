# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  has_one_attached :image

  has_many :reviews, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :sales, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Calificación numérica promedio
  def average_rating
    return 0.0 if reviews.empty?
    reviews.average(:rating).to_f.round(1)
  end

  # Representación en estrellas
  def star_rating
    avg = average_rating.round
    ('★' * avg) + ('☆' * (5 - avg))
  end

  # Alias para compatibilidad con vistas previas
  def rating_stars
    star_rating
  end
end