def consolidate_cart(cart)

  cart.reduce({}) do |memo, hash|
    if memo[hash.keys.first]
      memo[hash.keys.first][:count] += 1
    else
      memo[hash.keys.first] = hash.values.first
      memo[hash.keys.first][:count] = 1
    end
    memo
  end
end

def apply_coupons(cart, coupons)
  
  coupons.reduce(cart) do |memo, hash|
    if cart.keys.include?(hash.values.first)
      memo[hash.values.first][:count] -= hash[:num]
      memo[hash.values.first + " W/ COUPON"] = {
        :price => (hash[:cost] / hash[:num]),
        :clearance => cart[hash.values.first][:clearance],
        :count => hash[:num]
      }
    end
    memo
  end
end

def apply_clearance(cart)
  
  cart.reduce(cart) do |memo, (key, value)|
    if cart[key][:clearance]
      memo[key][:price] = cart[key][:price] - (cart[key][:price] * 0.2).round(2)
    end
    memo
  end
end

def checkout(cart, coupons)
  updated_cart = consolidate_cart(cart)
  coupons_applied = apply_coupons(updated_cart, coupons)
  clearance_applied = apply_clearance(updated_cart)
  
  total = clearance_applied.reduce(0) do |memo, (key, value)|
    memo += value[:price]
    memo
  end
  
  if total > 100.0
    total - (total * 0.1).round(2)
  else
    total
  end
  
end
