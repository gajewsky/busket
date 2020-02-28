require 'minitest/autorun'
require 'minitest/unit'
require './shopping_cart'

class ShopingCartTest < MiniTest::Unit::TestCase
  attr_reader :item_001, :item_002, :item_003, :promotional_rules

  def setup
    @item_001 = Item.new(code: '001', name: 'Red Scarf', price: 9.25)
    @item_002 = Item.new(code: '002', name: 'Silver cufflinks', price: 45)
    @item_003 = Item.new(code: '003', name: 'Silk Dress', price: 19.95)
    @promotional_rules = [PromotionalRule1, PromotionalRule2]
  end

  def test_scenario_1
    co = Checkout.new(promotional_rules)
    co.scan(item_001)
    co.scan(item_002)
    co.scan(item_003)

    assert_equal(66.78, co.total)
  end

  def test_scenario_2
    co = Checkout.new(promotional_rules)
    co.scan(item_001)
    co.scan(item_003)
    co.scan(item_001)

    assert_equal(36.95, co.total)
  end

  def test_scenario_3
    co = Checkout.new(promotional_rules)
    co.scan(item_001)
    co.scan(item_002)
    co.scan(item_001)
    co.scan(item_003)

    assert_equal(73.76, co.total)
  end
end
