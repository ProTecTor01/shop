module CurrentCart
  extend ActiveSupport::Concern

  included do
    helper_method :current_cart
  end

  private

  def current_cart
    return @current_cart if defined?(@current_cart)

    guest_cart = Cart.find_by(id: session[:cart_id]) if session[:cart_id]

    if user_signed_in?
      @current_cart = current_user.cart || current_user.create_cart!
      if guest_cart && guest_cart != @current_cart && guest_cart.user_id.nil?
        @current_cart.merge!(guest_cart)
      end
      session.delete(:cart_id)
    else
      @current_cart = guest_cart && guest_cart.user_id.nil? ? guest_cart : Cart.create!
      session[:cart_id] = @current_cart.id
    end

    @current_cart
  end
end
