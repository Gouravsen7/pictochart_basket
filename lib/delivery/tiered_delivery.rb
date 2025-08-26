# frozen_string_literal: true

require_relative 'delivery_strategy'

class TieredDelivery
  include DeliveryStrategy

  DELIVERY_TIERS = [
    { max: 49.99, fee: 4.95 },
    { max: 89.99, fee: 2.95 },
    { max: Float::INFINITY, fee: 0.0 }
  ].freeze

  def calculate(amount)
    tier = DELIVERY_TIERS.find { |t| amount <= t[:max] }
    tier[:fee]
  end
end
