# 🛒 Basket Pricing System

A Ruby class that calculates the total price of a shopping basket with support for:

- Promotional offers with priorities
- Tiered delivery costs
- Multiple applications of the same offer

---

## 🔧 How It Works

- Products are added by code using `add_to_basket(code, quantity)`.
- Offers are applied automatically if the basket meets the required conditions.
- The same offer can be applied **multiple times** (e.g., "Buy 2, get both at a discount" applies twice if 4 items are added).
- Delivery cost is added based on the **subtotal after discounts**.

---

## 💡 Example

```ruby
basket = Basket.new
basket.add_to_basket('R01', 4) # Applies offer twice
basket.add_to_basket('B01')
puts basket.total
# => 106.8
```

## ✅ Assumptions

- All product and offer data is kept in-memory for simplicity.
- Offer application is repeatable and respects priority.
- Discounted items are represented as separate product codes (e.g., `'R01_DC'`).
- No two offers conflict with each other on `from`/`to` product codes.
- Product codes are assumed to be valid if they exist in the `PRODUCTS` list.
