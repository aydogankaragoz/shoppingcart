ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require './web.rb'

class WebTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_cart_is_created
    post '/carts', :username => 'firstuser'

    assert last_response.ok?
    assert_equal '1', last_response.body["data"]["cart_id"]
  end

  def test_current_card_is_returned
    post '/carts/', :username => 'firstuser'
    assert_equal '400', last_response.status
    assert_equal 'This user already has a cart!', last_response.body.message
  end

  def test_product_is_added_to_cart
    post '/carts/1/products', :product => 'iphone1'

    assert last_response.ok?
    assert_equal "[{cartitem_id: 1, cartitem_product: 'iphone1', cartitem_quantity: 1}]", last_response.body["data"]
  end

  def test_another_product_is_added_to_cart
    post '/carts/1/products', :product => 'iphone2'

    assert last_response.ok?
    assert_equal "[{cartitem_id: 1, cartitem_product: 'iphone1', cartitem_quantity: 1},{cartitem_id: 2, cartitem_product: 'iphone2', cartitem_quantity: 1}]", last_response.body["data"]
  end

  def test_set_quantity_works
    put '/carts/1/products/iphone1', :quantity => '3'

    assert last_response.ok?
    assert_equal '3', last_response.body["data"]["cartitem_quantity"]
  end

  def test_cart_detail_works
    get '/carts/1'

    assert last_response.ok?
    assert_equal "[{cartitem_id: 1, cartitem_product: 'iphone1', cartitem_quantity: 1},{cartitem_id: 2, cartitem_product: 'iphone2', cartitem_quantity: 3}]", last_response.body.data.items
    assert_equal "700", last_response.body["data"]["total_price"]
  end
end
