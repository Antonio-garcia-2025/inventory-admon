class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :sales, dependent: :destroy 

  before_save :make_me_admin

  private

  def make_me_admin
    if email.downcase == "admin@admin.com"
      self.admin = true
    end
  end
end