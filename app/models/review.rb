# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :rating, presence: true, inclusion: { in: 1..5, message: "debe estar entre 1 y 5 estrellas" }
  validates :comment, presence: true, length: { minimum: 3, maximum: 500 }
end