class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items, dependent: :destroy

  def add_product(product)
    item = line_items.find_or_initialize_by(product: product)
    item.quantity = item.new_record? ? 1 : item.quantity + 1
    item.save!
    item
  end

  def remove_one(item)
    if item.quantity > 1
      item.update!(quantity: item.quantity - 1)
    else
      item.destroy!
    end
  end

  def item_count
    line_items.sum(:quantity)
  end

  def total_price
    line_items.includes(:product).sum { |item| item.product.price * item.quantity }
  end

  def merge!(guest_cart)
    transaction do
      guest_cart.line_items.includes(:product).each do |item|
        existing = line_items.find_or_initialize_by(product: item.product)
        existing.quantity = (existing.new_record? ? 0 : existing.quantity) + item.quantity
        existing.save!
      end
      guest_cart.destroy!
    end
  end
end
