def consolidate_cart(cart)
  new_cart = {}
  cart.each do |hash|
    hash.each do |item, details|
      if new_cart[item]
        new_cart[item][:count] += 1 
      else 
        new_cart[item] = details
        new_cart[item][:count] = 1 
      end
    end
  end
  new_cart
end


def apply_coupons(cart, coupons)
 return cart if coupons == []
 new_cart = cart 
 coupons.each do |coupon|
   name = coupon[:item]
   number = coupon[:num]
          #does cart have same item in coupon, but larger amount that coupon? i.e. is cart[avocado][:count] >= number
   if cart.include?(name) && cart[name][:count] >= number 
     new_cart[name][:count] -= number 
          #remove the new_cart count
   if new_cart["#{name} W/COUPON"]
     new_cart["#{name} W/COUPON"][:count] += 1 
          #INCREASE COUNT WHEN MORE ITEMS THAN coupons 
   else 
     new_cart["#{name} W/COUPON"] = {
       :price => coupon[:cost],
       :clearance => new_cart[name][:clearance],
       :count => 1 
     }
   end
 end
 end
 new_cart
end


def apply_clearance(cart)
  new_cart = cart 
  cart.each do |items, info|
    if info[:clearance] 
      new_cart[items][:price] = (cart[items][:price] * 0.8).round(2) 
    end
  end
  new_cart
end


#apply coupon discounts if proper number of items are present
#apply 20% if on clearance
# if cart is over $100 apply 10% discount 

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
    #get count first 
  apply_coupons(new_cart, coupons)
  apply_clearance(new_cart)
  total = 0 
  new_cart.each do |item, info|
    total += (info[:price] * info[:count])
  end
  if total > 100 
    total *= 0.9 
  end 
  total
end 




