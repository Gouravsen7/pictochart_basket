# frozen_string_literal: true

class BasketSummary
  attr_reader :basket, :items

  def initialize(basket)
    @basket = basket
    @items = basket.items
  end

  def item_rows
    grouped_items.map do |code, group|
      product = group.first
      unit_price = product.price
      quantity = group.size
      total_price = unit_price * quantity

      [
        code,
        product.name,
        format('$%.2f', unit_price),
        quantity.to_s,
        format('$%.2f', total_price)
      ]
    end
  end

  def subtotal
    items.map(&:price).sum
  end

  def discounts
    basket.calculate_discounts
  end

  def delivery
    basket.calculate_delivery
  end

  def total
    basket.total
  end

  private

  def grouped_items
    items.group_by(&:code)
  end
end
