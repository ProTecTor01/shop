# Demo data; safe to run more than once.
user = User.find_or_initialize_by(email: 'user@example.com')
if user.new_record?
  user.assign_attributes(name: 'Demo Seller', password: 'password', password_confirmation: 'password')
  user.save!
end

[
  { title: 'Watch', brand: 'Fossil', model: 'FH256', description: 'Good watch for men!', condition: 'Mint', finish: 'Black', price: 100, image: 'fossil.jpg' },
  { title: 'Car', brand: 'Opel', model: 'Corsa', description: 'Cool red car', condition: 'Excellent', finish: 'Red', price: 15_000, image: 'opel.jpeg' },
  { title: 'Car', brand: 'Ferrari', model: 'F12', description: 'Cool sports car', condition: 'New', finish: 'Black', price: 160_000, image: 'ferrari.jpeg' },
  { title: 'Computer', brand: 'Lenovo', model: 'ThinkPad X1 Carbon Touch', description: 'A thin and light business ultrabook with a 14-inch touch display.', condition: 'Used', finish: 'Black', price: 500, image: 'computer.jpg' }
].each do |attributes|
  image_name = attributes.delete(:image)
  user.products.find_or_create_by!(title: attributes[:title], model: attributes[:model]) do |product|
    product.assign_attributes(attributes)
    File.open(Rails.root.join('app/assets/images', image_name)) { |file| product.image = file }
  end
end
