class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :sales, dependent: :destroy 

  validates :email, presence: true, uniqueness: {case_sensitive: false}, length: {maximum: 3, maximum: 25}, on: :create


  before_save :make_me_admin

  #aqui es el controlador para privacidad e identidad.
  def display_name
    username.presence || email.split('@').first
  end

  private

  def make_me_admin
    if email.downcase == "admin@admin.com"
      self.admin = true
    end
  end
end