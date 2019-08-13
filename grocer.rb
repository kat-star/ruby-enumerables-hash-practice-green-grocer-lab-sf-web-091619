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
    item_name = hash[:item]
    if cart[item_name] && (cart[item_name][:count] >= hash[:num])
      memo[item_name][:count] -= hash[:num]
      coupon_name = item_name + " W/COUPON"
      if memo[coupon_name]
        memo[coupon_name][:count] += hash[:num]
      else
        memo[coupon_name] = {
        :price => (hash[:cost] / hash[:num]),
        :clearance => cart[item_name][:clearance],
        :count => hash[:num]
        }
      end
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
  clearance_applied = apply_clearance(coupons_applied)
  
  total = clearance_applied.reduce(0) do |memo, (key, value)|
    memo += (value[:price] * value[:count])
    memo
  end
  
  if total > 100.0
    total - (total * 0.1).round(2)
  else
    total
  end
  
end
