require 'test_helper'

class ShopFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @seller = User.create!(name: 'First Seller', email: 'first@example.com', password: 'password')
    @buyer = User.create!(name: 'Second Seller', email: 'second@example.com', password: 'password')
    @product = product_for(@seller, 'Camera', 25)
  end

  test 'registration creates a named user who can sign in and update account' do
    post user_registration_path, params: { user: {
      name: 'New Seller', email: 'new@example.com', password: 'password',
      password_confirmation: 'password'
    } }
    assert_response :redirect
    new_user = User.find_by!(email: 'new@example.com')
    assert_equal 'New Seller', new_user.name

    delete destroy_user_session_path
    post user_session_path, params: { user: { email: 'new@example.com', password: 'password' } }
    assert_response :redirect
    get edit_user_registration_path
    assert_response :success

    put user_registration_path, params: { user: {
      name: 'Updated Seller', email: 'new@example.com', current_password: 'password'
    } }
    assert_response :redirect
    assert_equal 'Updated Seller', new_user.reload.name
  end

  test 'only the seller can edit and delete a product' do
    sign_in @buyer
    get edit_product_path(@product)
    assert_response :forbidden
    patch product_path(@product), params: { product: { title: 'Stolen title' } }
    assert_response :forbidden
    delete product_path(@product)
    assert_response :forbidden
    assert_equal 'Camera', @product.reload.title

    post products_path, params: { product: product_attributes('Buyer item') }
    assert_response :redirect
    post products_path, params: { product: product_attributes('Buyer item two') }
    assert_response :redirect
    buyer_product = Product.find_by!(title: 'Buyer item')
    assert_equal @buyer, buyer_product.user
    assert_equal 2, @buyer.products.count

    sign_out @buyer
    sign_in @seller
    get root_path
    assert_match 'Buyer item', response.body
    assert_match 'Buyer item two', response.body
    sign_out @seller
    sign_in @buyer
    get edit_product_path(buyer_product)
    assert_response :success
    patch product_path(buyer_product), params: { product: { title: 'Updated item' } }
    assert_response :redirect
    assert_equal 'Updated item', buyer_product.reload.title
    delete product_path(buyer_product)
    assert_response :redirect
    assert_not Product.exists?(buyer_product.id)

    get root_path
    assert_response :success
    assert_match 'Sold by: First Seller', response.body
    assert_match 'Cart (0)', response.body
  end

  test 'cart counts units, calculates total, removes one, and stays with its user' do
    sign_in @seller
    5.times do
      post line_items_path, params: { product_id: @product.id }
      assert_redirected_to products_path
      assert_equal 'Added to your cart', flash[:notice]
    end
    get root_path
    assert_match 'Cart (5)', response.body
    get cart_path
    assert_match '$125.00', response.body
    item = @seller.cart.line_items.find_by!(product: @product)
    delete line_item_path(item)
    assert_equal 'Removed from your cart', flash[:notice]
    assert_equal 4, item.reload.quantity
    get cart_path
    assert_match '$100.00', response.body
    assert_match 'Cart (4)', response.body
    assert_match 'Are you sure?', response.body
    assert_match 'Removed from your cart', response.body

    sign_out @seller
    sign_in @buyer
    get cart_path
    assert_match 'Your cart is empty.', response.body
    assert_match 'Cart (0)', response.body
    sign_out @buyer
    sign_in @seller
    get cart_path
    assert_match 'Cart (4)', response.body
    delete cart_path
    assert_redirected_to root_path
    assert_equal 0, @seller.cart.reload.item_count
    follow_redirect!
    assert_match 'Cart (0)', response.body
  end

  test 'guest cart transfers to the account after sign in' do
    post line_items_path, params: { product_id: @product.id }
    assert_equal 'Added to your cart', flash[:notice]
    get cart_path
    assert_match 'Cart (1)', response.body

    post user_session_path, params: { user: { email: @buyer.email, password: 'password' } }
    assert_response :redirect
    get cart_path
    assert_match 'Cart (1)', response.body
    assert_equal 1, @buyer.reload.cart.item_count
  end

  test 'seller can upload a product image' do
    sign_in @seller
    image = Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/fossil.jpg'), 'image/jpeg')
    post products_path, params: { product: product_attributes('Watch').merge(image: image) }
    assert_response :redirect
    product = Product.find_by!(title: 'Watch')
    assert product.image?
    get product_path(product)
    assert_response :success
    assert_match product.image_url, response.body
  end

  private

  def product_for(user, title, price)
    user.products.create!(product_attributes(title).merge(price: price))
  end

  def product_attributes(title)
    { title: title, price: 25, brand: 'Fossil', model: 'A1',
      description: 'Working item', condition: 'Used', finish: 'Black' }
  end
end
