class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :sales, dependent: :destroy

  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end