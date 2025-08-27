# 🛒 Acme Widget Co - Basket Pricing System (Proof of Concept)

This is a Ruby-based proof-of-concept shopping basket system for **Acme Widget Co**, showcasing tiered delivery pricing and promotional offer logic with a beautiful terminal table interface.

## 📦 Overview

Acme Widget Co sells three products and is experimenting with delivery rules and promotional offers to incentivize purchases. This implementation demonstrates:

- A flexible **basket system** with clean architecture
- **Tiered delivery pricing** based on order total
- A **"Buy One, Get Second Half Price"** offer on specific items
- Clean and extensible code using **strategy patterns** and **helper modules**
- **Beautiful terminal output** using the `terminal-table` gem

### Sample Output
```
+----------------------------------------------------------+
|                   🛒 Basket #1 Summary                   |
+--------------+--------------+--------+---------+---------+
| Product Code | Product Name | Price  |   Qty   | Total   |
+--------------+--------------+--------+---------+---------+
| B01, B01     | Blue Widget  | $7.95  |    2    | $15.90  |
| R01, R01     | Red Widget   | $32.95 |    2    | $65.90  |
| G01          | Green Widget | $24.95 |    1    | $24.95  |
+--------------+--------------+--------+---------+---------+
| Subtotal     |              |        |         | $106.75 |
| Discounts    |              |        |         | -$16.48 |
| Delivery     |              |        |         | $0.00   |
| Total        |              |        |         | $90.27  |
+--------------+--------------+--------+---------+---------+
```

---

## 🧾 Product Catalogue

| Code | Name         | Price  |
|------|--------------|--------|
| R01  | Red Widget   | $32.95 |
| G01  | Green Widget | $24.95 |
| B01  | Blue Widget  | $7.95  |

---

## 🚚 Delivery Pricing Rules

| Basket Total     | Delivery Fee |
|------------------|--------------|
| Less than $50    | $4.95        |
| $50 to $89.99    | $2.95        |
| $90 or more      | Free         |

---

## 🎁 Promotional Offers

### 🟥 Buy One Red Widget, Get the Second Half Price
- Product Code: `R01`
- Applies to every second item in a pair
- Example: Buy 4 red widgets → Get 2 at half price
- Offer logic is customizable via the `OfferStrategy` module

---

## 🧠 Architecture

### Design Patterns Used:
- **Strategy Pattern** for Offers (`OfferStrategy`) and Delivery Rules (`DeliveryStrategy`)
- **Module Pattern** with `DiscountHelpers` for reusable item filtering logic
- **Composition** via the `Basket` class supporting multiple strategies

### Key Components:

#### Core Classes
- **`Product`** - Represents individual products with code, name, and price
- **`Catalogue`** - Manages product lookup by product codes
- **`Basket`** - Main class orchestrating pricing, offers, and delivery calculations

#### Strategy Modules
- **`DeliveryStrategy`** - Interface for delivery pricing rules
- **`TieredDelivery`** - Implements the 3-tier delivery pricing system
- **`OfferStrategy`** - Interface for promotional offers
- **`BuyOneGetSecondHalfPrice`** - Implements the red widget discount

#### Helper Modules
- **`DiscountHelpers`** - Shared utilities for offer calculations

---

## 🚀 Getting Started

### Prerequisites
- Ruby 3.3.3
- Bundler gem

### Installation
```bash
# Clone or download the project
# Navigate to project directory

# Install dependencies
bundle install
```

### Running the Application
```bash
# Run the main demonstration
ruby main.rb
```

This will display formatted tables showing the calculation breakdown for all documented example baskets.

---

## 📋 Example Baskets & Expected Totals

The system has been validated against the following test cases:

| Basket Items           | Expected Total |
|------------------------|----------------|
| B01, G01               | $37.85         |
| R01, R01               | $54.37         |
| R01, G01               | $60.85         |
| B01, B01, R01, R01, R01| $98.27         |

---

## 🧪 Testing

This project includes comprehensive test coverage using RSpec.

### Setup Testing Environment
```bash
# Install test dependencies
bundle install

### Running Tests
```bash
# Run all tests
bundle exec rspec

# Run with detailed output
bundle exec rspec --format documentation

# Run specific test files
bundle exec rspec spec/basket_spec.rb
```

### Test Coverage
- ✅ Unit tests for all classes and modules
- ✅ Integration tests for complete workflows
- ✅ Edge cases and error handling
- ✅ All documented example baskets
- ✅ Boundary condition testing
- ✅ Strategy pattern compliance

---

## 📁 Project Structure

```
acme-widget-basket/
├── Gemfile                              # Dependencies
├── README.md                            # This file
├── main.rb                              # Demo application
├── lib/                                 # Source code
│   ├── loader.rb                        # Loads all dependencies
│   ├── product.rb                       # Product model
│   ├── catalogue.rb                     # Product catalogue
│   ├── basket.rb                        # Main basket logic
│   ├── delivery/
│   │   ├── delivery_strategy.rb         # Delivery strategy interface
│   │   └── tiered_delivery.rb          # Tiered delivery implementation
│   ├── offers/
│   │   ├── offer_strategy.rb            # Offer strategy interface
│   │   ├── discount_helpers.rb          # Shared helper methods
│   │   └── buy_one_get_second_half_price.rb  # Red widget offer
│   └── basket_service/
│       ├── application.rb               # Application entry point
│       ├── factory.rb                   # Basket factory for creating instances
│       ├── printer.rb                   # Basket summary printer
│       └── summary.rb                   # Basket summary calculations
└── spec/                                # Test suite
   ├── spec_helper.rb                   # RSpec configuration
   ├── product_spec.rb                  # Product tests
   ├── catalogue_spec.rb                # Catalogue tests
   ├── basket_spec.rb                   # Basket tests
   ├── delivery/
   │   └── tiered_delivery_spec.rb      # Delivery tests
   ├── offers/
   │   └── buy_one_get_second_half_price_spec.rb  # Offer tests
   └── integration/
       └── basket_integration_spec.rb    # End-to-end tests
```

---

## 🔧 Key Implementation Details

### Float Precision Handling
The system uses custom truncation (not rounding) for monetary calculations to ensure predictable pricing:

```ruby
def truncate_float(num, decimals = 2)
  factor = 10**decimals
  (num * factor).floor / factor.to_f
end
```

### Terminal Table Output
Beautiful formatted output using the `terminal-table` gem provides:
- 🛒 Basket summaries with emojis
- Detailed breakdowns of subtotals, discounts, and delivery
- Professional table formatting for easy reading

### Extensible Design
- Add new products by updating the catalogue
- Create new delivery rules by implementing `DeliveryStrategy`
- Add new offers by implementing `OfferStrategy`
- Easily modify existing pricing tiers and offer conditions

---

## 🎯 Assumptions Made

1. **Prices are in USD** and displayed with 2 decimal places
2. **Delivery charges are calculated** after discount application
3. **Multiple offers can be applied** simultaneously
4. **Float truncation** (not rounding) is used for final totals
5. **Basket items are processed** in the order they were added

---
