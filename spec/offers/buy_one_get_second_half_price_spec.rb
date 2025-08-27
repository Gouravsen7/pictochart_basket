# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BuyOneGetSecondHalfPrice do
  let(:red_widget) { Product.new(code: 'R01', name: 'Red Widget', price: 32.95) }
  let(:green_widget) { Product.new(code: 'G01', name: 'Green Widget', price: 24.95) }
  let(:offer) { BuyOneGetSecondHalfPrice.new(product_code: 'R01') }

  describe 'no discount scenarios' do
    it 'returns zero discount for empty items' do
      expect(offer.apply([])).to eq(0)
    end

    it 'returns zero when no matching products' do
      items = [green_widget, green_widget]
      expect(offer.apply(items)).to eq(0)
    end

    it 'returns zero discount for single eligible item' do
      items = [red_widget]
      expect(offer.apply(items)).to eq(0)
    end
  end

  describe 'discount calculation scenarios' do
    it 'returns half price discount for two eligible items' do
      items = [red_widget, red_widget]
      expected_discount = red_widget.price / 2.0
      expect(offer.apply(items)).to eq(expected_discount)
    end

    it 'returns half price discount for three eligible items' do
      items = [red_widget, red_widget, red_widget]
      expected_discount = red_widget.price / 2.0
      expect(offer.apply(items)).to eq(expected_discount)
    end

    it 'returns double discount for four eligible items' do
      items = [red_widget, red_widget, red_widget, red_widget]
      expected_discount = (red_widget.price / 2.0) * 2
      expect(offer.apply(items)).to eq(expected_discount)
    end
  end

  describe 'mixed items scenarios' do
    it 'only applies discount to matching products' do
      items = [red_widget, green_widget, red_widget, green_widget]
      expected_discount = red_widget.price / 2.0
      expect(offer.apply(items)).to eq(expected_discount)
    end
  end

  describe 'interface compliance' do
    it 'includes OfferStrategy' do
      expect(BuyOneGetSecondHalfPrice.included_modules).to include(OfferStrategy)
    end

    it 'includes DiscountHelpers' do
      expect(BuyOneGetSecondHalfPrice.included_modules).to include(DiscountHelpers)
    end
  end
end
