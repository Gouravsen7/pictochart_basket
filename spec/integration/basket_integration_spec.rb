# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Basket Integration' do
  let(:red_widget) { Product.new(code: 'R01', name: 'Red Widget', price: 32.95) }
  let(:green_widget) { Product.new(code: 'G01', name: 'Green Widget', price: 24.95) }
  let(:blue_widget) { Product.new(code: 'B01', name: 'Blue Widget', price: 7.95) }
  let(:catalogue) { Catalogue.new([red_widget, green_widget, blue_widget]) }
  let(:delivery_rule) { TieredDelivery.new }
  let(:offers) { [BuyOneGetSecondHalfPrice.new(product_code: 'R01')] }

  describe 'basic workflow scenarios' do
    it 'handles full shopping experience with offers' do
      basket = Basket.new(
        catalogue: catalogue,
        delivery_rule: delivery_rule,
        offers: offers
      )

      basket.add('R01')
      basket.add('R01')
      basket.add('G01')

      expect(basket.total).to eq(77.32)
    end

    it 'works with no offers' do
      basket = Basket.new(
        catalogue: catalogue,
        delivery_rule: delivery_rule,
        offers: []
      )

      basket.add('B01')
      basket.add('G01')

      expect(basket.total).to eq(37.85)
    end

    it 'handles empty basket' do
      basket = Basket.new(
        catalogue: catalogue,
        delivery_rule: delivery_rule,
        offers: offers
      )

      expect(basket.total).to eq(4.95)
    end
  end

  describe 'advanced scenarios' do
    let(:basket) do
      Basket.new(
        catalogue: catalogue,
        delivery_rule: delivery_rule,
        offers: offers
      )
    end

    it 'handles large quantities with multiple discounts' do
      6.times { basket.add('R01') }

      expect(basket.total).to eq(148.27)
    end

    it 'handles mixed products with partial offer eligibility' do
      basket.add('B01')
      basket.add('R01')
      basket.add('G01')
      basket.add('R01')
      basket.add('B01')

      expect(basket.total).to eq(90.27)
    end
  end
end
