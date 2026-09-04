# frozen_string_literal: true

class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :user
end
