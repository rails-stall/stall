# Stall

[![Build Status](https://api.travis-ci.org/rails-stall/stall.svg?branch=master)](http://travis-ci.org/rails-stall/stall)
[![Code Climate](https://codeclimate.com/github/rails-stall/stall.svg)](https://codeclimate.com/github/rails-stall/stall)

Stall is a flexible e-commerce framework for Rails with some specific concerns
in mind :

- Product models and categorization handling is flexible and done in the app
- The checkout process is easily configurable, overridable but has a standard working default
- The whole system is modular and extensible
- The core should stay small and vendor-specific code (payment gateways, shipping carriers) is done in separate gems
- Authentication and admin is better handled by existing gems

**Note :** This gem is under active development, and is a complete rewrite of
the [glysellin](https://github.com/glysellin/glysellin) gem, but with a more
flexible structure, and with a complete test coverage

## Installation

Add to your Gemfile and `bundle install` :

```ruby
gem 'stall'
```

Then run the install generator :

```bash
rails generate stall:install
```

This will generate :

- The stall models migrations
- A default initializer file to configure the system
- A default checkout wizard class making it easy to configure your checkout process

## Usage

### Making a model sellable

Stall allows you to make any model sellable by including the `Stall::Sellable`
mixin into your model :

```ruby
class Book < ActiveRecord::Base
  include Stall::Sellable
end
```

This will allow to add the model to the cart.

The default behavior is to use any  `name` or `title` method of the model to set
the line items name, and a `price` method to set the line item price.

If you want to configure that behavior, you can override the `#to_line_item`
method of the containing model, and return a valid `Stall::LineItem` instance.

You can now add the "Add to cart" button to your templates :

```ruby
= add_to_cart_form_for(@book)
```

### Configuring the checkout flow

TBW

# Licence

This project rocks and uses MIT-LICENSE.
