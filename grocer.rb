def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |item_hash|
    item_hash.each do |item_name, price_hash|
      if consolidated_cart[item_name].nil?
        consolidated_cart[item_name] = price_hash
        consolidated_cart[item_name][:count] = 1
      else
        consolidated_cart[item_name][:count] += 1
      end
    end
  end
  consolidated_cart
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    item_name = coupon_hash[:item]
    if !cart[item_name].nil? && cart[item_name][:count] >= coupon_hash[:num]
      cart[item_name][:count] -= coupon_hash[:num]
      if cart["#{item_name} W/COUPON"].nil?
        cart["#{item_name} W/COUPON"] = {:price => coupon_hash[:cost], :clearance => cart[item_name][:clearance], :count => 1}
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
  cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  cart_with_clearance = apply_clearance(cart_with_coupons)
  total = 0
  cart_with_clearance.each do |item_name, price_hash|
    total += price_hash[:price] * price_hash[:count]
  end
  if total > 100
    total * 0.9
  else
    total
  end
end

