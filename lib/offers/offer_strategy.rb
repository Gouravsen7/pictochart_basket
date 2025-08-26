# frozen_string_literal: true

# Interface module for all offers.
# Ensures each offer implements `apply(items)`
module OfferStrategy
  def apply(items)
    raise NotImplementedError, "#{self.class} must implement apply(items)"
  end
end
