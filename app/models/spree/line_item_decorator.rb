Spree::LineItem.class_eval do
  # pattern grabbed from: http://stackoverflow.com/questions/4470108/

  # the idea here is compatibility with spree_sale_products
  # trying to create a 'calculation stack' wherein the best valid price is
  # chosen for the product. This is mainly for compatibility with spree_sale_products
  # 
  # Assumption here is that the volume price currency is the same as the product currency
  old_copy_price = instance_method(:copy_price)
  define_method(:copy_price) do
    old_copy_price.bind(self).call

    if variant
      if changed? && changes.keys.include?('quantity')
        discount_price = self.variant.volume_price(self.quantity)

        # support for spree_sale_products
        if self.variant.respond_to?(:on_sale?) && self.variant.on_sale?
          if self.variant.sale_price < discount_price
            discount_price = self.variant.sale_price
          end
        end

        self.price = discount_price
      end
    end
  end
end
