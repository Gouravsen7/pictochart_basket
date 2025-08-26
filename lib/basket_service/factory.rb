# frozen_string_literal: true

class BasketFactory
  def initialize(catalogue:, delivery_rule:, offers:)
    @catalogue = catalogue
    @delivery_rule = delivery_rule
    @offers = offers
  end

  def create
    Basket.new(
      catalogue: @catalogue,
      delivery_rule: @delivery_rule,
      offers: @offers
    )
  end
end
