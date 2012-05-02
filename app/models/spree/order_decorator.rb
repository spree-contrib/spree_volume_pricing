Spree::Order.class_eval do
  # override the add_variant functionality so that we can adjust the price based on possible volume adjustment
  def add_variant(variant, quantity=1)
    current_item = contains?(variant)
    price = variant.volume_price(quantity) # Added
    if current_item
      current_item.quantity += quantity
      current_item.price = price # Added
      current_item.save
    else
      current_item = Spree::LineItem.new(:quantity => quantity)
      current_item.variant = variant
      current_item.price = price
      self.line_items << current_item
    end

    # populate line_items attributes for additional_fields entries
    # that have populate => [:line_item]
    Spree::Variant.additional_fields.select { |f| !f[:populate].nil? && f[:populate].include?(:line_item) }.each do |field|
      value = ''

      if field[:only].nil? || field[:only].include?(:variant)
        value = variant.send(field[:name].gsub(' ', '_').downcase)
      elsif field[:only].include?(:product)
        value = variant.product.send(field[:name].gsub(' ', '_').downcase)
      end
      current_item.update_attribute(field[:name].gsub(' ', '_').downcase, value)
    end

    current_item
  end
end
