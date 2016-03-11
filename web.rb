require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'json'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/cart.db")

class User
  include DataMapper::Resource
  property :id,         Serial
  property :username, Text
  property :Name, Text
  property :email, Text
  property :password, Text
  has n, :carts
end

class Product
  include DataMapper::Resource
  property :name, Text, :key => true
  property :price, Integer
end

class Cart
  include DataMapper::Resource
  property :id, Serial
  belongs_to :user  # defaults to :required => true
  has n, :cartitems
end

class Cartitem
  include DataMapper::Resource
  property :quantity, Integer
  property :name, Text
  property :price, Integer
  belongs_to :cart, :key => true
  has n, :products
end

DataMapper.finalize.auto_upgrade!

puts 'creating ex data: users'
User.create(:username => 'firstuser', :Name => 'First', :email => 'first@cart.com', :password => 'xx')
User.create(:username => 'seconduser', :Name => 'Second', :email => 'second@cart.com', :password => 'xx')
User.create(:username => 'thirduser', :Name => 'Third', :email => 'third@cart.com', :password => 'xx')

puts 'creating ex data: products '
Product.create(:name => 'iphone1', :price => 100)
Product.create(:name => 'iphone2', :price => 200)
Product.create(:name => 'iphone3', :price => 300)
Product.create(:name => 'iphone4', :price => 400)
Product.create(:name => 'iphone5', :price => 500)

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
