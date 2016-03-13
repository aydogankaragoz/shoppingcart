require 'rubygems'
require 'sinatra'
require 'json'

require './model.rb'

post '/form' do
  "You said '#{params[:message]}'"
end

## Create a new cart
post '/carts' do
  c = Cart.create(:user => User.get(params[:username]) )
  puts "11111111Creating a Cart with id, '#{c.identifier}' for: '#{params[:username]}'"
  "Creating a Cart with id, '#{c.identifier}' for: '#{params[:username]}'"
end

## Add product to the cart
post '/carts/:cart_id/products' do
  # check if there is quantity?
  puts '8888888888888888888888'

  if params[:quantity]
    quantity = params[:quantity]
  else
    quantity = 1
  end

  cart_id = params[:cart_id]
  product = params[:product]

  puts "cart_id: #{cart_id}"
  puts "product: #{product}"
  puts "quantity: #{quantity}"

#  Cartitem.create(:cart => Cart.get(params[:]), :product => Product.get(params[:]

end

## Remove product from the cart
delete '/carts/:cart_id/products/:product_id' do
  puts '33333333DELETE'
  puts "cart_id: #{params[:cart_id]}"
  puts "product: #{params[:product_id]}"
end

## Clean cart
put '/carts/:cart_id/clean' do
  puts '444444444PUT'
end

## Set quantity for a product
put '/carts/:cart_id/products/:product_id' do
  puts '555555555PUT'
  puts "cart_id: #{params[:cart_id]}"
  puts "product_id: #{params[:product_id]}"
  puts "quantity: #{params[:quantity]}"
end
## Returns detail of the cart
get '/carts/:cart_id' do
  puts "cart_id: #{params[:cart_id]}"
  puts 'toplam'
end


get '/hello/:name' do |n|
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params['name'] is 'foo' or 'bar'
  # n stores params['name']
  "Hello #{n}!"
end

get '/?' do
  @items = Item.all(:order => :created.desc)
  redirect '/new' if @items.empty?
  erb :index
end

get '/new/?' do
  @title = "Add todo item"
  erb :new
end

post '/new/?' do
  Item.create(:content => params[:content], :created => Time.now)
  redirect '/'
end

post '/done/?' do
  item = Item.first(:id => params[:id])
  item.done = !item.done
  item.save
  content_type 'application/json'
  value = item.done ? 'done' : 'not done'
  { :id => params[:id], :status => value }.to_json
end

get '/delete/:id/?' do
  @item = Item.first(:id => params[:id])
  erb :delete
end

post '/delete/:id/?' do
  if params.has_key?("ok")
    item = Item.first(:id => params[:id])
    item.destroy
    redirect '/'
  else
    redirect '/'
  end
end
