# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def create
    @category = current_user.categories.build(category_params)

    if @category.save
      redirect_to products_path, notice: "Categoría '#{@category.name}' creada exitosamente."
    else
      redirect_to products_path, alert: "Error al crear la categoría: #{@category.errors.full_messages.to_sentence}"
    end
  end

  def destroy
    @category = current_user.categories.find(params.expect(:id))
    @category.destroy
    redirect_to products_path, notice: 'Categoría eliminada exitosamente.'
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: 'Categoría no encontrada.'
  end

  private

  def category_params
    params.expect(category: [:name])
  end
end
