# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  # Validaciones de calificación y comentario
  validates :rating, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  validates :comment, presence: true, length: { minimum: 5, maximum: 500 }

  # El usuario solo puede dejar una reseña por producto
  validates :user_id, uniqueness: { scope: :product_id, message: "ya has dejado una reseña para este producto" }
end