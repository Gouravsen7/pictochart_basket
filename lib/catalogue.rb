# frozen_string_literal: true

class Catalogue
  def initialize(products = [])
    @products = products.to_h { |p| [p.code, p] }
  end

  def find(code)
    @products[code]
  end
end
