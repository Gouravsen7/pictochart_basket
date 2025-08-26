# frozen_string_literal: true

# Shared helper methods for offer calculations
module DiscountHelpers
  # Select all items matching a given product code
  def items_for(items, code)
    items.select { |item| item.code == code }
  end
end
