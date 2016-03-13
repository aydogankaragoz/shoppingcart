require 'sinatra'

require './model.rb'

## Create a new cart
post '/carts' do
  c = Cart.create(:user => User.get(params[:username]) )
end

## Add product to the cart
post '/carts/:cart_id/products' do

  if params[:quantity]
    quantity = params[:quantity]
  else
    quantity = 1
  end

  cart_id = params[:cart_id]
  product = params[:product]

  Cartitem.create(:cart => Cart.get(params[:cart_id]),
                  :product => Product.get(params[:product]),
                  :quantity => quantity)
end

## Remove product from the cart
delete '/carts/:cart_id/products/:product' do

  if params[:quantity]
    remove_quantity = params[:quantity]
  else
    remove_quantity = 1
  end

  cartitem = Cartitem.first(:product => Product.get(params[:product]), :cart => Cart.get(params[:cart_id]))

  cartitem_quantity = cartitem.quantity

  if remove_quantity >= cartitem_quantity
    cartitem.destroy
  else
    cartitem.update(:quantity => (cartitem_quantity - remove_quantity))
  end

end

## Clean cart
put '/carts/:cart_id/clean' do
  cartitem = Cartitem.all(:cart => Cart.get(params[:cart_id])).destroy
end

## Set quantity for a product
put '/carts/:cart_id/products/:product_id' do

  cartitem = Cartitem.first(:product => Product.get(params[:product_id]), :cart => Cart.get(params[:cart_id]))
  cartitem.update(:quantity => params[:quantity])

end

## Returns detail of the cart
get '/carts/:cart_id' do
  total = 0
  cartitems = Cartitem.all(:cart => Cart.get(params[:cart_id]))
  cartitems.each do |cartitem|
    total += cartitem.quantity * Product.get(cartitem.product_name).price
  end
  total.to_s
end

