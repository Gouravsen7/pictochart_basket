# frozen_string_literal: true

require_relative '../loader'

class BasketApplication
  def initialize
    @catalogue = create_catalogue
    @basket_factory = create_basket_factory
    @printer = BasketPrinter.new
  end

  def run
    basket_examples = [
      %w[B01 G01],
      %w[R01 R01],
      %w[R01 G01],
      %w[B01 B01 R01 R01 R01]
    ]

    basket_examples.each_with_index do |product_codes, index|
      basket = @basket_factory.create
      populate_basket(basket, product_codes)
      @printer.print_summary(basket, index + 1)
    end
  end

  private

  def create_catalogue
    products = [
      Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
      Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
      Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
    ]
    Catalogue.new(products)
  end

  def create_basket_factory
    BasketFactory.new(
      catalogue: @catalogue,
      delivery_rule: TieredDelivery.new,
      offers: [BuyOneGetSecondHalfPrice.new(product_code: 'R01')]
    )
  end

  def populate_basket(basket, product_codes)
    product_codes.each { |code| basket.add(code) }
  end
end
