class Product < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy

  mount_uploader :image, ImageUploader
  CATEGORIES = ['Cars', 'Electronics', 'Watches', 'Musical instruments', 'Clothing', 'Home & garden', 'Other'].freeze

  validates :title, :brand, :price, :model, :description, :condition, :finish, presence: true
  validates :category, inclusion: { in: CATEGORIES }
  # Set max lenght to the description, price and title
  validates :description, length: { maximum: 1000, too_long: "%{count} characters is the maximum aloud. "}
  validates :title, length: { maximum: 140, too_long: "%{count} characters is the maximum aloud. "}
  validates :price, numericality: { greater_than: 0 }

  # You can input more brands finish and condition here
  BRAND = %w{ Ferrari Opel Lenovo Fossil Fender Other }
  FINISH = %w{ Black White Navy Blue Red Clear Satin Yellow Seafoam }
  CONDITION = %w{ New Excellent Mint Used Fair Poor }

end
