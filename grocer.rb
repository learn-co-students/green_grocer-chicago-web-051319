require 'pry'


def consolidate_cart(cart)
  hash = {}
  cart.each do |food|
    food.each do |name, price|
      if hash[name] == nil
        hash[name] = price.merge({:count => 1})
      else
        hash[name][:count] += 1
      end
    end
  end
  hash
end

def apply_coupons(cart, coupons)
  hash = cart
  coupons.each do |coupon|
    item = coupon[:item]

    if !hash[item].nil? && hash[item][:count] >= coupon[:num]
      temp = {"#{item} W/COUPON" => {
          :price => coupon[:cost],
          :clearance => hash[item][:clearance],
          :count => 1
        }
      }

      if hash["#{item} W/COUPON"].nil?
        hash.merge!(temp)
      else
        hash["#{item} W/COUPON"][:count] += 1
      end

      hash[item][:count] -= coupon[:num]
    end
  end
  hash
end

def apply_clearance(cart)
  cart.each do |name, status|
    if status[:clearance] == true
      status[:price] = (status[:price]*0.8).round(2)
    end
  end
  cart
end

def checkout(item, coupons)
  cart = consolidate_cart(item)
  cart1 = apply_coupons(cart, coupons)
  cart2 = apply_clearance(cart1)
  total = 0
  cart2.each do |name, price|
    total += price[:price]*price[:count]
  end
  total > 100 ? total*0.9 : total
end
