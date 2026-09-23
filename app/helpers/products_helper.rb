module ProductsHelper
  def product_author(product)
    product.user&.name.presence || "Unknown seller"
  end
end
