# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :received_reviews, through: :products, source: :reviews, dependent: :destroy
  has_many :carts, dependent: :destroy
  
  #calificacion promedio global del vendedor
  def seller_rating
    return 0.0 if received_reviews.empty?
    received_reviews.average(:rating).to_f.round(1)
  end
  #representacion visual de las estrellas

  def seller_stars
    avg = seller_rating.round
    ('★' * avg) + ('☆' * (5 - avg))
  end

  # RELACIÓN CON EL CARRITO
  has_one :cart, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }, on: :create

  before_save :make_me_admin

  def display_name
    username.presence || email.to_s.split('@').first
  end

  private

  def make_me_admin
    return unless email.to_s.downcase == 'admin@admin.com'

    self.admin = true
  end
end
