# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!

  # GET /orders (Historial de compras del usuario)
  def index
    @orders = current_user.orders.includes(order_items: :product).order(created_at: :desc)
  end

  # GET /orders/:id (Detalle de un pedido específico)
  def show
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: "Pedido no encontrado."
  end
end