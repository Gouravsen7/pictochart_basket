# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Product do
  describe '#initialize' do
    it 'creates a product with code, name, and price' do
      product = Product.new(code: 'R01', name: 'Red Widget', price: 32.95)

      expect(product.code).to eq('R01')
      expect(product.name).to eq('Red Widget')
      expect(product.price).to eq(32.95)
    end
  end

  describe 'attributes' do
    let(:product) { Product.new(code: 'G01', name: 'Green Widget', price: 24.95) }

    it 'provides read-only access to code' do
      expect(product).to respond_to(:code)
      expect(product).not_to respond_to(:code=)
    end

    it 'provides read-only access to name' do
      expect(product).to respond_to(:name)
      expect(product).not_to respond_to(:name=)
    end

    it 'provides read-only access to price' do
      expect(product).to respond_to(:price)
      expect(product).not_to respond_to(:price=)
    end
  end
end
