# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Catalogue do
  let(:red_widget) { Product.new(code: 'R01', name: 'Red Widget', price: 32.95) }
  let(:green_widget) { Product.new(code: 'G01', name: 'Green Widget', price: 24.95) }
  let(:blue_widget) { Product.new(code: 'B01', name: 'Blue Widget', price: 7.95) }
  let(:products) { [red_widget, green_widget, blue_widget] }

  describe 'initialization' do
    it 'can be initialized with an empty array' do
      catalogue = Catalogue.new
      expect(catalogue.find('R01')).to be_nil
    end

    it 'can be initialized with products' do
      catalogue = Catalogue.new(products)
      expect(catalogue.find('R01')).to eq(red_widget)
    end
  end

  describe 'finding products' do
    let(:catalogue) { Catalogue.new(products) }

    it 'returns the correct product for valid codes' do
      expect(catalogue.find('R01')).to eq(red_widget)
      expect(catalogue.find('G01')).to eq(green_widget)
      expect(catalogue.find('B01')).to eq(blue_widget)
    end

    it 'returns nil for invalid product codes' do
      expect(catalogue.find('INVALID')).to be_nil
      expect(catalogue.find('')).to be_nil
      expect(catalogue.find(nil)).to be_nil
    end
  end
end
