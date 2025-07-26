class Basket
  # Products and offers are defined as constants for simplicity.
  # In a real-world application, these would likely be fetched from a database.
  
  # Each product has a name, price, and code.
  # Offers are defined with a code, priority, and the products involved in the offer.
  # The 'from' key indicates the condition an offer can be applied to buy, and 'to' indicates the resulting products.
  attr_reader :offers

  PRODUCTS = [
    {
      name: 'Red Widget',
      price: 32.95,
      code: 'R01',
    },
    {
      name: 'Green Widget',
      price: 24.95,
      code: 'G01',
    },
    {
      name: 'Blue Widget',
      price: 7.95,
      code: 'B01',
    },
    {
      name: 'Red Widget discounted',
      price: 32.95 * 0.75,
      code: 'R01_DC',
    }
  ]
  OFFERS = [
    # Could mark an offer as available with a separate flag
    {
      code: 'Christmas Special',
      priority: 2,
      from: {'R01' => 2},
      to: {'R01_DC' => 2},
    } # Buy 2 Red Widgets get the second half price
  ]

  SUBTOTAL_TO_DELIVERY_COST = {
    (0...50) => 4.95,
    (50...90) => 2.95,
    (90..) => 0
  }

  def initialize
    @basket = Hash.new(0)
    @offers = Hash.new(0)
    @dirty = true
    @cached_total = nil
  end


  def add_to_basket(code, quantity = 1)
    return unless PRODUCTS.any? { |product| product[:code] == code }
    @basket[code] += quantity
    @dirty = true
  end

  def total
    return @cached_total if @dirty == false && @cached_total
    subtotal = 0.0
    apply_offers.each do |code, quantity|
      product = PRODUCTS.find { |p| p[:code] == code }
      next unless product
      
      subtotal += product[:price] * quantity
    end

    @dirty = false
    @cached_total = (subtotal + delivery_cost(subtotal)).truncate(2)
  end

  private

  def delivery_cost(subtotal)
    SUBTOTAL_TO_DELIVERY_COST.find do |subtotal_range, _|
      subtotal_range.include?(subtotal)
    end.last
  end

  def apply_offers
    basket_tmp = @basket.dup
    
    OFFERS.sort_by { |offer| offer[:priority] }.each do |offer|
      while offer[:from].all? { |code, qty| basket_tmp[code] >= qty }
        offer[:from].each { |code, qty| basket_tmp[code] -= qty }
        # This way we reflect the discounted price while marking the items
        offer[:to].each { |code, qty| basket_tmp[code] += qty }
        @offers[offer[:code]] += 1
      end
    end

    basket_tmp
  end
end
