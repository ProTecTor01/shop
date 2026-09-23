# Demo data; safe to run more than once.
seller = User.find_or_initialize_by(email: 'user@example.com')
if seller.new_record?
  seller.assign_attributes(name: 'Demo Seller', password: 'password', password_confirmation: 'password')
  seller.save!
end

second_seller = User.find_or_initialize_by(email: 'seller2@example.com')
if second_seller.new_record?
  second_seller.assign_attributes(name: 'Second Demo Seller', password: 'password', password_confirmation: 'password')
  second_seller.save!
end

products = [
  { seller: seller, title: 'Watch', category: 'Watches', brand: 'Fossil', model: 'FH256', description: 'Good watch for men!', condition: 'Mint', finish: 'Black', price: 100, image: 'fossil.jpg' },
  { seller: seller, title: 'Car', category: 'Cars', brand: 'Opel', model: 'Corsa', description: 'Cool red car', condition: 'Excellent', finish: 'Red', price: 15_000, image: 'opel.jpeg' },
  { seller: seller, title: 'Car', category: 'Cars', brand: 'Ferrari', model: 'F12', description: 'Cool sports car', condition: 'New', finish: 'Black', price: 160_000, image: 'ferrari.jpeg' },
  { seller: seller, title: 'Computer', category: 'Electronics', brand: 'Lenovo', model: 'ThinkPad X1 Carbon Touch', description: 'A thin and light business ultrabook with a 14-inch touch display.', condition: 'Used', finish: 'Black', price: 500, image: 'computer.jpg' },
  { seller: seller, title: 'Electric guitar', category: 'Musical instruments', brand: 'Fender', model: 'Stratocaster', description: 'Electric guitar in good working condition.', condition: 'Excellent', finish: 'Seafoam', price: 950, image: 'fender.jpg' },
  { seller: second_seller, title: 'Electric guitar', category: 'Musical instruments', brand: 'Fender', model: 'Player Telecaster', description: 'Well-kept guitar, ready to play.', condition: 'Used', finish: 'Black', price: 780, image: 'fender.jpg' },
  { seller: second_seller, title: 'Smartwatch', category: 'Watches', brand: 'Fossil', model: 'Gen 6', description: 'Smartwatch with charger included.', condition: 'Used', finish: 'Black', price: 140, image: 'fossil.jpg' },
  { seller: second_seller, title: 'Laptop', category: 'Electronics', brand: 'Lenovo', model: 'ThinkPad T14', description: 'Business laptop in good condition.', condition: 'Excellent', finish: 'Black', price: 720, image: 'computer.jpg' },
  { seller: second_seller, title: 'Car', category: 'Cars', brand: 'Opel', model: 'Astra', description: 'Reliable everyday car.', condition: 'Used', finish: 'Red', price: 9_500, image: 'opel.jpeg' },
  { seller: second_seller, title: 'Car', category: 'Cars', brand: 'Ferrari', model: '488 GTB', description: 'Sports car in excellent condition.', condition: 'Excellent', finish: 'Red', price: 188_000, image: 'ferrari.jpeg' }
]

products.each do |attributes|
  product_seller = attributes.delete(:seller)
  image_name = attributes.delete(:image)
  product = product_seller.products.find_or_initialize_by(title: attributes[:title], model: attributes[:model])

  if product.new_record?
    product.assign_attributes(attributes)
    File.open(Rails.root.join('app/assets/images', image_name)) { |file| product.image = file }
  elsif product.category == 'Other'
    product.category = attributes[:category]
  end

  product.save! if product.changed?
end
