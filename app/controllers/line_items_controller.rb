class LineItemsController < ApplicationController
  def create
    product = Product.find(params.require(:product_id))
    current_cart.add_product(product)
    redirect_back fallback_location: products_path, notice: "Added to your cart"
  end

  def destroy
    item = current_cart.line_items.find(params[:id])
    current_cart.remove_one(item)
    redirect_to cart_path, notice: "Removed from your cart"
  end
end
