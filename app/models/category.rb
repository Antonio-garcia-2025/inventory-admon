class Category < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :nullify

  validates :name, presence: true
end