class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :sales, dependent: :destroy

  before_save :set_default_admin

  private

  def set_default_admin
    # Reemplaza con tu correo exacto
    if email == "admin@inventory-admon.com"
      self.admin = true
    end
  end
end