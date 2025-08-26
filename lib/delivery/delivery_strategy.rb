# frozen_string_literal: true

module DeliveryStrategy
  def calculate(amount)
    raise NotImplementedError, "#{self.class} must implement calculate(amount) method"
  end
end
