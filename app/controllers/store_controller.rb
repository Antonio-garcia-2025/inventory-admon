# frozen_string_literal: true

class StoreController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @categories = Category.order(:name)

    scope = Product.includes(:user, :category).with_attached_image.where('stock > 0')

    # Filtro 1: Por categoría si existe
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?

    # Filtro 2: Búsqueda compatible con SQLite y PostgreSQL
    if params[:query].present?
      search_term = "%#{params.fetch(:query).strip.downcase}%"
      # LOWER(...) LIKE LOWER(...) funciona en cualquier motor de base de datos
      scope = scope.where('LOWER(products.name) LIKE ?', search_term)
    end

    @products = scope.distinct.order(created_at: :desc)
  end
end
