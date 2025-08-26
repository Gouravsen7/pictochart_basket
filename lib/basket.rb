# frozen_string_literal: true

class Basket
  attr_reader :items

  def initialize(catalogue:, delivery_rule:, offers: [])
    @catalogue     = catalogue
    @delivery_rule = delivery_rule
    @offers        = offers
    @items         = []
  end

  def add(product_code)
    product = @catalogue.find(product_code)
    raise ArgumentError, "Invalid product code: #{product_code}" unless product

    @items << product
  end

  def total
    subtotal = calculate_subtotal
    discounts = calculate_discounts
    delivery = calculate_delivery

    truncate_float(subtotal - discounts + delivery, 2)
  end

  def calculate_subtotal
    @items.map(&:price).reduce(0, :+)
  end

  def calculate_discounts
    @offers.map { |offer| offer.apply(@items) }.reduce(0, :+)
  end

  def calculate_delivery
    subtotal = calculate_subtotal
    discounts = calculate_discounts
    @delivery_rule.calculate(subtotal - discounts)
  end

  def truncate_float(num, decimals = 2)
    factor = 10**decimals
    (num * factor).floor / factor.to_f
  end
end
