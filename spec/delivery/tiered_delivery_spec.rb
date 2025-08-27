# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TieredDelivery do
  let(:delivery_rule) { TieredDelivery.new }

  describe '#calculate under $50 tier' do
    it 'charges $4.95 for amounts under $50' do
      expect(delivery_rule.calculate(49.99)).to eq(4.95)
      expect(delivery_rule.calculate(25.00)).to eq(4.95)
      expect(delivery_rule.calculate(0.01)).to eq(4.95)
    end

    it 'handles zero amount' do
      expect(delivery_rule.calculate(0)).to eq(4.95)
    end
  end

  describe '#calculate $50-$89.99 tier' do
    it 'charges $2.95 for amounts between $50 and $89.99' do
      expect(delivery_rule.calculate(50.00)).to eq(2.95)
      expect(delivery_rule.calculate(89.99)).to eq(2.95)
      expect(delivery_rule.calculate(75.50)).to eq(2.95)
    end
  end

  describe '#calculate $90+ tier' do
    it 'provides free delivery for amounts $90 or more' do
      expect(delivery_rule.calculate(90.00)).to eq(0.0)
      expect(delivery_rule.calculate(100.00)).to eq(0.0)
      expect(delivery_rule.calculate(1000.00)).to eq(0.0)
    end

    it 'handles very large amounts' do
      expect(delivery_rule.calculate(Float::INFINITY)).to eq(0.0)
    end
  end

  describe 'interface compliance' do
    it 'includes DeliveryStrategy' do
      expect(TieredDelivery.included_modules).to include(DeliveryStrategy)
    end
  end
end
