class CartsController < ApplicationController
  def show
    @cart = current_cart
    @line_items = @cart.line_items.includes(:product)
  end

  def destroy
    current_cart.line_items.destroy_all
    redirect_to root_path, notice: "Cart emptied."
  end
end
