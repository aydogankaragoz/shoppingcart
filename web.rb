require 'sinatra'
require 'json'

require './model.rb'

## Create a new cart
post '/carts/?' do
  user = User.get(params[:username]) 
  if user == nil
    return { :status => 400, :message => 'Username not found in database!' }.to_json
  end

  if Cart.count(:user => user) != 0
    return { :status => 400, :message => 'This user already has an Cart!' }.to_json
  end

  c = Cart.create(:user => user )
  if c
    return { :status => 200, :data => { :cart_id => c.identifier.to_s} }.to_json
  else
    return { :status => 400, :message => 'Cart could not created!' }.to_json
  end
end

## Add product to the cart
post '/carts/:cart_id/products' do

  quantity = 1
  if params[:quantity]
    quantity = params[:quantity]
  end

  cart = Cart.get(params[:cart_id])
  if cart == nil
    return { :status => 400, :message => 'Invalid cart_id!' }.to_json
  end

  product = Product.get(params[:product])
  if product == nil
    return { :status => 400, :message => 'Invalid product!' }.to_json
  end

  c = Cartitem.create(:cart => cart,
                      :product => product,
                      :quantity => quantity)

  if c
    return { :status => 200, :data => { :cartitem_id => c.identifier,
                                        :cartitem_product => c.product_name,
                                        :cartitem_quantity => c.quantity }}.to_json
  else
    return { :status => 400, :message => 'Cart could add product to the cart!' }.to_json
  end

end

## Remove product from the cart
delete '/carts/:cart_id/products/:product' do

  remove_quantity = 1
  if params[:quantity]
    remove_quantity = params[:quantity]
  end


  cart = Cart.get(params[:cart_id])
  if cart == nil
    return { :status => 400, :message => 'Invalid cart_id!' }.to_json
  end
  
  product = Product.get(params[:product])
  if product == nil
    return { :status => 400, :message => 'Invalid product!' }.to_json
  end

  cartitem = Cartitem.first(:product => product, :cart => cart)
  if product == nil
    return { :status => 400, :message => 'There is no such product in this cart!' }.to_json
  end

  cartitem_quantity = cartitem.quantity

  if remove_quantity >= cartitem_quantity
    cartitem.destroy
    return { :status => 200, :quantity => 0, :message => 'All products removed' }.to_json
  else
    cartitem.update(:quantity => (cartitem_quantity - remove_quantity))
    return { :status => 200, :quantity => cartitem_quantity - remove_quantity,  :message => 'Product removed!' }.to_json
  end


end

## Clean cart
put '/carts/:cart_id/clean' do

  cart = Cart.get(params[:cart_id])
  if cart == nil
    return { :status => 400, :message => 'Invalid cart_id!' }.to_json
  end

  if Cartitem.count(:cart => Cart.get(params[:cart_id])) == 0
    return { :status => 400, :message => 'Cart is already empty!' }.to_json
  else 
    cartitem = Cartitem.all(:cart => Cart.get(params[:cart_id])).destroy
    return { :status => 200, :message => 'All items removed!' }.to_json
  end
end

## Set quantity for a product
put '/carts/:cart_id/products/:product_id' do

  cart = Cart.get(params[:cart_id])
  if cart == nil
    return { :status => 400, :message => 'Invalid cart_id!' }.to_json
  end

  product = Product.get(params[:product])
  if product == nil
    return { :status => 400, :message => 'Invalid product!' }.to_json
  end

  cartitem = Cartitem.first(:product => product, :cart => cart)
  if product == nil
    return { :status => 400, :message => 'There is no such product in this cart!' }.to_json
  end

  cartitem.update(:quantity => params[:quantity])

  return { :status => 200, :data => { :cartitem_id => c.identifier,
                                      :cartitem_product => c.product_name,
                                      :cartitem_quantity => c.quantity }}.to_json
end

## Returns detail of the cart
get '/carts/:cart_id' do

  cart = Cart.get(params[:cart_id])
  if cart == nil
    return { :status => 400, :message => 'Invalid cart_id!' }.to_json
  end

  total = 0
  cartitems = Cartitem.all(:cart => cart)
  cartitems.each do |cartitem|
    total += cartitem.quantity * Product.get(cartitem.product_name).price
  end

  return { :status => 200, :data => { :total => total} }.to_json
end
