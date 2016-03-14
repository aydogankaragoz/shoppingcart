require 'unirest'

# Create a new cart
Unirest.post('http://localhost:4567/carts',
             parameters:{ :username => 'firstuser'})

# Add product to the cart
Unirest.post('http://localhost:4567/carts/1/products',
             parameters:{ :product => 'iphone2', :quantity => 2})
Unirest.post('http://localhost:4567/carts/2/products',
             parameters:{ :product => 'iphone3', :quantity => 4})
Unirest.post('http://localhost:4567/carts/2/products',
             parameters:{ :product => 'iphone4', :quantity => 5})
Unirest.post('http://localhost:4567/carts/2/products',
             parameters:{ :product => 'iphone5', :quantity => 6})

Unirest.post('http://localhost:4567/carts/1/products',
             parameters:{ :product => 'iphone2'})

Unirest.post('http://localhost:4567/carts/1/products',
             parameters:{ :product => 'iphone4'})

# Remove product from the cart
Unirest.delete('http://localhost:4567/carts/1/products/iphone2')


# Clean cart
Unirest.put('http://localhost:4567/carts/2/clean')

# Set quantity for a product
Unirest.put('http://localhost:4567/carts/1/products/iphone2',
             parameters:{ :quantity => '33'})

# Returns detail of the cart
Unirest.get('http://localhost:4567/carts/1')

