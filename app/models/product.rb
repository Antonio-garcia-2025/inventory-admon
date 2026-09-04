# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :sales, dependent: :destroy
  has_one_attached :image
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  has_many :reviews, dependent: :destroy


  #metodo para calcualar el promedio de las estrellas redondeando a 1 decimal
  def average_rating
    return 0.0 if reviews.empty?
    reviews.average(:rating).to_f.round(1)
  end
  
  #representacion de las estrellas en formato de texto
  def star_rating
    avg =average_rating.round
    "★" * avg + "☆" * (5 - avg)
  end
end


