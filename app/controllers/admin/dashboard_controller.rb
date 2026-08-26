module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    def index
      @total_sellers_count = User.count
      @total_products_count = Product.count
      @total_inventory_stock = Product.sum(:stock)

      @sellers = User.all.map do |seller|
        {
          id: seller.id,
          email: seller.email,
          created_at: seller.created_at,
          products_count: seller.products.count,
          total_stock: seller.products.sum(:stock)
        }
      end
    end

    def destroy_user
      @user_to_delete = User.find(params[:id])

      if @user_to_delete == current_user
        redirect_to admin_dashboard_path, alert: "No puedes eliminar tu propia cuenta de Administrador."
      else
        user_email = @user_to_delete.email
        @user_to_delete.destroy
        redirect_to admin_dashboard_path, notice: "La cuenta de #{user_email} ha sido eliminada."
      end
    end

    private

    def require_admin!
      is_admin = current_user.admin? || (current_user.email.downcase == "antonioggguerrero@gmail.com")

      unless is_admin
        redirect_to root_path, alert: "Acceso restringido. Se requieren privilegios de Administrador."
      end
    end
  end
end