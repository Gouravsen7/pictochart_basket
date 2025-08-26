# frozen_string_literal: true

require 'terminal-table'
require_relative 'summary'

class BasketPrinter
  def print_summary(basket, basket_number)
    summary = BasketSummary.new(basket)

    table = Terminal::Table.new(
      title: "🛒 Basket ##{basket_number} Summary",
      headings: ['Product Code', 'Product Name', 'Price', 'Qty', 'Total'],
      rows: build_table_rows(summary)
    )

    puts "\n"
    puts table
  end

  private

  def build_table_rows(summary)
    rows = summary.item_rows
    rows << :separator
    rows << ['Subtotal', nil, nil, nil, format_currency(summary.subtotal)]
    rows << ['Discounts', nil, nil, nil, format_currency(-summary.discounts)]
    rows << ['Delivery', nil, nil, nil, format_currency(summary.delivery)]
    rows << ['Total', nil, nil, nil, format_currency(summary.total)]
    rows
  end

  def format_currency(amount)
    format('$%.2f', amount)
  end
end
