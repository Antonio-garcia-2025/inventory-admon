module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    def index
      @total_sellers_count = User.count
      @total_products_count = Product.count
      @total_inventory_stock = Product.sum(:stock)

      # Métricas Globales de Ventas e Ingresos
      if defined?(Sale)
        @total_global_sales = Sale.count
        @total_global_revenue = Sale.sum(:price)
        @recent_global_sales = Sale.includes(:user, :product).order(created_at: :desc).limit(10)
      else
        @total_global_sales = 0
        @total_global_revenue = 0.0
        @recent_global_sales = []
      end

      # Métricas individuales por cada vendedor
      @sellers = User.all.map do |seller|
        seller_sales_count = seller.respond_to?(:sales) ? seller.sales.count : 0
        seller_revenue = seller.respond_to?(:sales) ? seller.sales.sum(:price) : 0.0

        {
          id: seller.id,
          email: seller.email,
          created_at: seller.created_at,
          products_count: seller.products.count,
          total_stock: seller.products.sum(:stock),
          sales_count: seller_sales_count,
          total_revenue: seller_revenue
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
      admin_email = "antonioggguerrero@gmail.com"
      is_admin = (current_user.respond_to?(:admin?) && current_user.admin?) || (current_user.email.to_s.downcase == admin_email.downcase)

      unless is_admin
        redirect_to root_path, alert: "Acceso restringido. Se requieren privilegios de Administrador."
      end
    end
  end
end