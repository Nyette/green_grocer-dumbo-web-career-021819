def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |item_hash|
    item_hash.each do |item_name, price_hash|
      if cart_hash[item_name].nil?
        cart_hash[item_name] = price_hash
        cart_hash[item_name][price_hash][:count] = 1
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
      item_with_coupon_hash = {"#{item_name} W/COUPON" => {:price => coupon_hash[:cost], :clearance => cart[item_name][:clearance], :count => 1}}
      if cart["#{item_name} W/COUPON"].nil?
        cart.merge!(item_with_coupon_hash)
      else
        cart["#{item_name} W/COUPON"][:count] += 1
      end
      cart[item_name][:count] -= coupon_hash[:num]
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


def checkout(items, coupons)
  cart = consolidate_cart(items)
  cart_one = apply_coupons(cart, coupons)
  cart_two = apply_clearance(cart_one)
  total = 0
  cart_two.each do |item_name, price_hash|
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
