def consolidate_cart(cart)
  output = {}
  cart.each { |itemObj|
    itemObj.each { |itemName, saleInfo|
      output[itemName] == nil ? output[itemName] = saleInfo.merge({:count => 1}) : output[itemName][:count] += 1
    }
  }
  output
end

def apply_coupons(cart, coupons)
  coupons.each { |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      wCoupon = "#{name} W/COUPON"
      if cart[wCoupon]
        cart[wCoupon][:count] += 1
      else
        cart[wCoupon] = {:count => 1, :price => coupon[:cost]}
        cart[wCoupon][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  }
  cart
end

def apply_clearance(cart)
  cart.each { |item, saleInfo|
    if saleInfo[:clearance]
      saleInfo[:price] = (saleInfo[:price] * 0.8).round(2)
    end
  }
  cart
end

def checkout(cart, coupons)
  couponed = apply_coupons(consolidate_cart(cart), coupons)
  discounted = apply_clearance(couponed)
  total = 0
  discounted.each { |name, info|
    total += info[:price] * info[:count]
  }
  total > 100 ? total = total * 0.9 : total
end
