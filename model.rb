require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/cart.db")

class User
  include DataMapper::Resource
  property :username, Text, :key => true
  property :Name, Text
  property :email, Text
  property :password, Text

  has n, :carts
  has n, :products, :through => :carts
end

class Cart
  include DataMapper::Resource
  property :identifier, Serial

  belongs_to :user
  has n, :cartitems
  has n, :products, :through => :cartitems
end

class Cartitem
  include DataMapper::Resource
  property :identifier, Serial
  property :quantity, Integer

  belongs_to :cart
  belongs_to :product
end

class Product
  include DataMapper::Resource
  property :name, Text, :key => true
  property :price, Integer

  has n, :cartitems
end

DataMapper.finalize.auto_upgrade!

