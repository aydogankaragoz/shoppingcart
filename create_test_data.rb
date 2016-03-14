require './model.rb'

# Example Data: 3 users
puts 'creating ex data: users'
User.create(:username => 'firstuser', :Name => 'First', :email => 'first@cart.com', :password => 'xx')
User.create(:username => 'seconduser', :Name => 'Second', :email => 'second@cart.com', :password => 'xx')
User.create(:username => 'thirduser', :Name => 'Third', :email => 'third@cart.com', :password => 'xx')

# Example Data: 10 products
puts 'creating ex data: products '
Product.create(:name => 'iphone1', :price => 100)
Product.create(:name => 'iphone2', :price => 200)
Product.create(:name => 'iphone3', :price => 300)
Product.create(:name => 'iphone4', :price => 400)
Product.create(:name => 'iphone5', :price => 500)
Product.create(:name => 'iphone6', :price => 600)
Product.create(:name => 'iphone7', :price => 700)
Product.create(:name => 'iphone8', :price => 800)
Product.create(:name => 'iphone9', :price => 900)
Product.create(:name => 'iphone10', :price => 1000)

