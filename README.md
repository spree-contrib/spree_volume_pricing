> [!WARNING]  
> [Volume Pricing, quantity breaks](https://spreecommerce.org/docs/developer/core-concepts/pricing), and [Catalogs](https://spreecommerce.org/docs/developer/core-concepts/catalogs) are now part of Spree core. This extension is not needed anymore.

# Volume Pricing

[![Build Status](https://travis-ci.com/spree-contrib/spree_volume_pricing.svg?branch=master)](https://travis-ci.com/spree-contrib/spree_volume_pricing)
[![Code Climate](https://codeclimate.com/github/spree-contrib/spree_volume_pricing/badges/gpa.svg)](https://codeclimate.com/github/spree-contrib/spree_volume_pricing)

Volume Pricing is an extension to Spree (a complete open source commerce solution for Ruby on Rails) that uses predefined ranges of quantities to determine the price for a particular product variant.  For instance, this allows you to set a price for quantities between 1-10, another price for quantities between (10-100) and another for quantities of 100 or more.  If no volume price is defined for a variant, then the standard price is used.

Each VolumePrice contains the following values:

1. **Variant:** Each VolumePrice is associated with a _Variant_, which is used to link products to particular prices.
1. **Name:** The human readable representation of the quantity range (Ex. 10-100).  (Optional)
1. **Discount Type** The type of discount to apply.  **Price:** sets price to the amount specified. **Dollar:** subtracts specified amount from the Variant price.  **Percent:** subtracts the specified amounts percentage from the Variant price.
1. **Range:** The quantity range for which the price is valid (See Below for Examples of Valid Ranges.)
1. **Amount:** The price of the product if the line item quantity falls within the specified range.
1. **Position:** Integer value for `acts_as_list` (Helps keep the volume prices in a defined order.)

---

## Install

Add in your `Gemfile`:

```ruby
gem 'spree_volume_pricing', github: 'spree-contrib/spree_volume_pricing'
```
(run `bundle install`)


The extension contains a rails generator that will add the necessary migrations and give you the option to run the migrations, or run them later, perhaps after installing other extensions. Once you have bundled the extension, run the install generator and its ready to use.

      rails generate spree_volume_pricing:install

Easily add volume pricing display to your product page:

      <%= render partial: 'spree/products/volume_pricing', locals: { product: @product } %>

---

## Ranges

Ranges are expressed as Strings and are similar to the format of a Range object in Ruby.  The lower number of the range is always inclusive.  If the range is defined with '..' then it also includes the upper end of the range.  If the range is defined with '...' then the upper end of the range is not inclusive.

Ranges can also be defined as "open ended."  Open ended ranges are defined with an integer followed by a '+' character.  These ranges are inclusive of the integer and any value higher then the integer.

All ranges need to be expressed as Strings and can include or exclude parentheses.  "(1..10)" and "1..10" are considered to be a valid range.

---

## Examples

Consider the following examples of volume prices:

       Variant                Name               Range        Amount         Position
       -------------------------------------------------------------------------------
       Rails T-Shirt          1-5                (1..5)       19.99          1
       Rails T-Shirt          6-9                (6...10)     18.99          2
       Rails T-Shirt          10 or more         (10+)        17.99          3

### Example 1

Cart Contents:

       Product                Quantity       Price       Total
       ----------------------------------------------------------------
       Rails T-Shirt          1              19.99       19.99

### Example 2

Cart Contents:

       Product                Quantity       Price       Total
       ----------------------------------------------------------------
       Rails T-Shirt          5              19.99       99.95

### Example 3

Cart Contents:

      Product                Quantity       Price       Total
      ----------------------------------------------------------------
      Rails T-Shirt          6              18.99       113.94

### Example 4

Cart Contents:

      Product                Quantity       Price       Total
      ----------------------------------------------------------------
      Rails T-Shirt          10             17.99       179.90

### Example 5

Cart Contents:

      Product                Quantity       Price       Total
      ----------------------------------------------------------------
      Rails T-Shirt          20             17.99       359.80

---

## Additional Notes

* The volume price is applied based on the total quantity ordered for a particular variant.  It does not apply different prices for the portion of the quantity that falls within a particular range. Only the one price is used (although this would be an interesting configurable option if someone wanted to write a patch.)

---

## Contributing

See corresponding [contributing guidelines][1].

---

## License

Copyright (c) 2009-2021 [Spree Commerce][2] and [contributors][3], released under the [New BSD License][4]

[1]: https://github.com/spree-contrib/spree_volume_pricing/blob/master/CONTRIBUTING.md
[2]: https://github.com/spree
[3]: https://github.com/spree-contrib/spree_volume_pricing/graphs/contributors
[4]: https://github.com/spree-contrib/spree_volume_pricing/blob/master/LICENSE.md
