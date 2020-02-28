class Checkout
  def initialize(promotional_rules)
    @promotional_rules = promotional_rules
    @items = []
  end

  def scan(item)
    items.push(item)
  end

  def total
    total_after_promotions.round(2)
  end

  attr_reader :items, :promotional_rules

  private

  def total_after_promotions
    initial_total = items.sum(&:price)

    promotional_rules.reduce(initial_total) do |total, rule|
      rule.new(items: items, total: total).total_after_promotion
    end
  end
end


class PromotionalRule
  def initialize(items:, total:)
    @items = items
    @total = total
  end

  private

  attr_reader :items, :total
end

# When purchasing 2 or more of the Red Scarf, its price is reduced to £8.50
class PromotionalRule1 < PromotionalRule
  DISCOUNTED_CODE = '001'.freeze
  PRICE_AFTER_DISCOUNT = 8.5

  def total_after_promotion
    return total if discounted_items.count < 2

    total_of_items_without_discount + discounted_items.count * PRICE_AFTER_DISCOUNT
  end

  private

  def discounted_items
    @disconted_items ||= items.select { |i| i.code == DISCOUNTED_CODE }
  end

  def total_of_items_without_discount
    (items - discounted_items).sum(&:price)
  end
end

# When spending over £60, the customer gets 10% off their purchase
class PromotionalRule2 < PromotionalRule
  DISCOUNT_PERCENT = 0.9
  THRESHOLD = 60

  def total_after_promotion
    return total if total <= THRESHOLD

    total * DISCOUNT_PERCENT
  end
end


class Item
  def initialize(code:, name:, price:)
    @code = code
    @name = name
    @price = price
  end

  attr_reader :code, :name, :price
end

