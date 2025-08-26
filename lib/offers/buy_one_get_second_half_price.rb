# frozen_string_literal: true

require_relative 'offer_strategy'
require_relative 'discount_helpers'

# Strategy for "Buy one, get the second half price"
class BuyOneGetSecondHalfPrice
  include OfferStrategy
  include DiscountHelpers

  def initialize(product_code:)
    @product_code = product_code
  end

  def apply(items)
    eligible_items = items_for(items, @product_code)
    return 0 if eligible_items.empty?

    half_price_count = eligible_items.size / 2
    half_price_count * (eligible_items.first.price / 2.0)
  end
end
