def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |item_hash|
    item_hash.each do |item_name, price_hash|
      if cart_hash[item_name].nil?
        cart_hash[item_name] = price_hash
        cart_hash[item_name][:count] = 1
      else
        cart_hash[item_name][:count] += 1
      end
    end
  end
  cart_hash
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    item_name = coupon_hash[:item]
    if !cart[item_name].nil? && cart[item_name][:count] >= coupon_hash[:num]
      cart[item_name][:count] -= coupon_hash[:num]
      if cart["#{item_name} W/COUPON"].nil?
        cart["#{item_name} W/COUPON"] = {:price => coupon_hash[:cost], :clearance => cart[item_name][:clearance], :count => 1}}
      else
        cart["#{item_name} W/COUPON"][:count] += 1
      end
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |item_name, price_hash|
    if price_hash[:clearance] == true
      price_hash[:price] = (price_hash[:price] * 0.8).round(2)
    end
  end
  cart
end


def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  total = 0
  clearance_cart.each do |item_name, price_hash|
    price = price_hash[:price]
    count = price_hash[:count]
    total += price * count
  end
  if total > 100
    total * 0.9
  else
    total
  end
end

