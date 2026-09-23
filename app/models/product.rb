class Product < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy

  mount_uploader :image, ImageUploader
  BRAND_SUGGESTIONS = %w[Ferrari Opel Lenovo Fossil Fender].freeze

  def self.brand_suggestions
    (BRAND_SUGGESTIONS + distinct.where.not(brand: [nil, '']).pluck(:brand)).uniq.sort
  end

  validates :title, :brand, :price, :model, :description, :condition, presence: true
  # Set max lenght to the description, price and title
  validates :description, length: { maximum: 1000, too_long: "%{count} characters is the maximum aloud. "}
  validates :title, length: { maximum: 140, too_long: "%{count} characters is the maximum aloud. "}
  validates :price, numericality: { greater_than: 0 }

  CONDITION = %w{ New Excellent Mint Used Fair Poor }

end
