class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def create
    @category = current_user.categories.build(category_params)

    if @category.save
      redirect_to root_path, notice: "Categoría '#{@category.name}' creada exitosamente."
    else
      redirect_to root_path, alert: "Error al crear la categoría: #{@category.errors.full_messages.to_sentence}"
    end
  end

  def destroy
    @category = current_user.categories.find(params[:id])
    @category.destroy
    redirect_to root_path, notice: "Categoría eliminada exitosamente."
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Categoría no encontrada."
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
