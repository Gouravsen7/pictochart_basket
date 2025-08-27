# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Basket do
  let(:red_widget) { Product.new(code: 'R01', name: 'Red Widget', price: 32.95) }
  let(:green_widget) { Product.new(code: 'G01', name: 'Green Widget', price: 24.95) }
  let(:blue_widget) { Product.new(code: 'B01', name: 'Blue Widget', price: 7.95) }
  let(:catalogue) { Catalogue.new([red_widget, green_widget, blue_widget]) }
  let(:delivery_rule) { TieredDelivery.new }
  let(:red_widget_offer) { BuyOneGetSecondHalfPrice.new(product_code: 'R01') }

  describe 'initialization' do
    it 'initializes with catalogue, delivery rule and offers' do
      basket = Basket.new(
        catalogue: catalogue,
        delivery_rule: delivery_rule,
        offers: [red_widget_offer]
      )
      expect(basket).to be_an_instance_of(Basket)
    end

    it 'initializes with empty offers by default' do
      basket = Basket.new(catalogue: catalogue, delivery_rule: delivery_rule)
      expect(basket).to be_an_instance_of(Basket)
    end
  end

  describe 'adding products' do
    let(:basket) do
      Basket.new(catalogue: catalogue, delivery_rule: delivery_rule)
    end

    it 'adds valid products to the basket' do
      expect { basket.add('R01') }.not_to raise_error
      expect { basket.add('G01') }.not_to raise_error
      expect { basket.add('B01') }.not_to raise_error
    end

    it 'raises error for invalid product codes' do
      expect { basket.add('INVALID') }.to raise_error(
        ArgumentError, 'Invalid product code: INVALID'
      )
    end

    it 'allows adding the same product multiple times' do
      expect { basket.add('R01') }.not_to raise_error
      expect { basket.add('R01') }.not_to raise_error
    end
  end

  describe 'total calculation without offers' do
    let(:basket) do
      Basket.new(catalogue: catalogue, delivery_rule: delivery_rule)
    end

    it 'calculates correct total for single item' do
      basket.add('B01')
      expect(basket.total).to eq(12.90)
    end

    it 'calculates correct total for multiple different items' do
      basket.add('B01')
      basket.add('G01')

      expect(basket.total).to eq(37.85)
    end
  end

  describe 'total calculation with red widget offer' do
    let(:basket) do
      Basket.new(
        catalogue: catalogue,
        delivery_rule: delivery_rule,
        offers: [red_widget_offer]
      )
    end

    it 'applies discount for two red widgets' do
      basket.add('R01')
      basket.add('R01')

      expect(basket.total).to eq(54.37)
    end

    it 'calculates total with mixed items and offer' do
      basket.add('R01')
      basket.add('G01')

      expect(basket.total).to eq(60.85)
    end

    it 'applies discount for multiple red widgets' do
      basket.add('B01')
      basket.add('B01')
      basket.add('R01')
      basket.add('R01')
      basket.add('R01')

      expect(basket.total).to eq(98.27)
    end
  end

  describe 'delivery tier calculations' do
    let(:basket) do
      Basket.new(catalogue: catalogue, delivery_rule: delivery_rule)
    end

    it 'applies correct delivery for amounts under $50' do
      basket.add('B01')
      expect(basket.total).to eq(12.90)
    end

    it 'applies correct delivery for amounts $50-$89.99' do
      basket.add('G01')
      basket.add('R01')

      expect(basket.total).to eq(60.85)
    end

    it 'applies free delivery for amounts $90+' do
      basket.add('R01')
      basket.add('R01')
      basket.add('R01')

      expect(basket.total).to eq(98.85)
    end
  end

  describe '#truncate_float' do
    let(:basket) do
      Basket.new(catalogue: catalogue, delivery_rule: delivery_rule)
    end

    it 'truncates to 2 decimal places by default' do
      expect(basket.truncate_float(54.379)).to eq(54.37)
      expect(basket.truncate_float(54.371)).to eq(54.37)
    end

    it 'handles whole numbers' do
      expect(basket.truncate_float(54.00)).to eq(54.00)
    end

    it 'allows custom decimal places' do
      expect(basket.truncate_float(54.3789, 3)).to eq(54.378)
    end
  end

  describe 'documented example baskets' do
    let(:basket) do
      Basket.new(
        catalogue: catalogue,
        delivery_rule: delivery_rule,
        offers: [red_widget_offer]
      )
    end

    def add_items_and_calculate(product_codes)
      basket.instance_variable_set(:@items, [])
      product_codes.each { |code| basket.add(code) }
      basket.total
    end

    it 'B01, G01 should total $37.85' do
      total = add_items_and_calculate(%w[B01 G01])
      expect(total).to eq(37.85)
    end

    it 'R01, R01 should total $54.37' do
      total = add_items_and_calculate(%w[R01 R01])
      expect(total).to eq(54.37)
    end

    it 'R01, G01 should total $60.85' do
      total = add_items_and_calculate(%w[R01 G01])
      expect(total).to eq(60.85)
    end

    it 'B01, B01, R01, R01, R01 should total $98.27' do
      total = add_items_and_calculate(%w[B01 B01 R01 R01 R01])
      expect(total).to eq(98.27)
    end
  end
end
