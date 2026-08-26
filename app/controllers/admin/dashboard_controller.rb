module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    def index
      # Métricas Globales
      @total_platform_revenue = Sale.sum(:price)
      @total_platform_sales_count = Sale.count
      @total_sellers_count = User.count
      @total_products_count = Product.count

      # Desglose por vendedor
      @sellers = User.all.map do |seller|
        {
          id: seller.id,
          email: seller.email,
          created_at: seller.created_at,
          products_count: seller.products.count,
          total_stock: seller.products.sum(:stock),
          sales_count: seller.sales.count,
          total_earnings: seller.sales.sum(:price)
        }
      end.sort_by { |s| -s[:total_earnings] }
    end

    def destroy_user
        @user_to_delate = User.find(params[:id])
        if @user_to_delat = current_user
            redirect_to admin_dashboard_path, alert: "No puedes eliminar tu propia cuenta." 
        else 
            user_email = @user_to_delate.email
            @user_to_delate.destroy
            redirect_to admin_dashboard_path, notice: "Usuario #{user_email} eliminado exitosamente."
        end
    end
    

    private

    def require_admin!
      unless current_user.admin?
        redirect_to root_path, alert: "Acceso restringido. Se requieren privilegios de Administrador."
      end
    end
  end
end