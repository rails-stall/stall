# Stall

[![Build Status](https://api.travis-ci.org/rails-stall/stall.svg?branch=master)](http://travis-ci.org/rails-stall/stall)
[![Test Coverage](https://codeclimate.com/github/rails-stall/stall/badges/coverage.svg)](https://codeclimate.com/github/rails-stall/stall/coverage)

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

In the following sections, you'll find the following informations :

1. [Configuring shop defaults](#1-configuring-shop-defaults)
2. [Configuring shop users](#2-configuring-shop-users)
3. [Making a model sellable](#3-making-a-model-sellable)
4. [Configuring the checkout flow](#4-configuring-the-checkout-flow)
5. [Customizing views](#5-customizing-views)
6. [Cleaning up aborted carts](#6-cleaning-up-aborted-carts)


### 1. Configuring shop defaults

Before running the shop, please read through the generated Stall initializer
file at `config/initializers/stall.rb` and customize the default values to fit
your desired shop behavior.

Here are the mandatory ones :

- `store_name`
- `admin_email`
- `sender_email`
- `default_app_domain`

### 2. Configuring shop users

The default cart behavior admits that you have a user model, named `User` and
that you are using [Devise](https://github.com/plataformatec/devise/wiki)
compatible helpers in your controllers.

You can configure those settings by setting the following initializer config
parameters :

- `default_user_model_name`
- `default_user_helper_method`

Also, the user should include an inverse `:customer` relation targeting the
Stall's customer model like the following :

```ruby
has_one :customer, as: :user
```

#### Remove user management

If you don't want to associate a user account to your customers, you'll need
to set those variables to `nil` and remove the user creation form in the
informations checkout step.

This is untested for now, but should be doable quite easily.

### 3. Making a model sellable

Stall allows you to make any model sellable by including the `Stall::Sellable`
mixin into your model :

```ruby
class Book < ActiveRecord::Base
  include Stall::Sellable
end
```

You can now add the "Add to cart" button to your templates :

```ruby
= add_to_cart_form_for(@book)
```

To display the cart widget in your layout, just render the cart widget partial :

```ruby
= render partial: 'stall/carts/widget', locals: { cart: current_cart }
```

For more informations see the Wiki page :
[Allowing customers to add products to cart](https://github.com/rails-stall/stall/wiki/Allowing-customers-to-add-products-to-cart)


### 4. Configuring the checkout flow

The checkout process is completely flexible and can be overriden easily.

Please see the Wiki page :
[The checkout process](https://github.com/rails-stall/stall/wiki/The-checkout-process)


### 5. Customizing views

You can copy stall views to your app with the `stall:view` generator.
The less you customize the views, the more you get it to work with future
Stall versions.

Find the templates you need by browsing the source code (ex: `bundle open stall`)
and generate the needed views. You can pass any number of views at a time.

Example :

```bash
rails generate stall:view checkout/steps/_informations checkout/steps/_payment stall/carts/_cart
```

### 6. Cleaning up aborted carts

A cart is created for each new visit on the app. You may want to clean
aborted carts to avoid the table to grow too big.

You can setup the provided `rake` task in a cron :

```bash
rake stall:carts:clean
```

#### Configuring what is cleaned in the task

Two types of aborted carts are cleaned :

- Empty carts older than 24h
- Aborted carts, with products added, older than 2 weeks

You can configure both delays with the following config in the stall initializer :

```ruby
config.empty_carts_expires_after = 1.day
config.aborted_carts_expires_after = 14.days
```

#### Cleaning other types of ProductList

You can create your own cart classes by extending the `Cart` or `ProductList`
model in your app.

To clean those models, you just need to pass the cart class name to the rake
task when calling it. For a `TestCart` model, you'd do :

```bash
rake stall:carts:clean[TestCart]
```

> **Note** : that double-quotes may be needed around the task name to make that
syntax work with some shells (e.g. zsh) : `rake "stall:carts:clean[TestCart]"`

You can also override in your subclass the way that the task retrieves aborted
carts by defining a scope or class method `.aborted(options)` where `options`
may contain a `:before` option.

# Licence

This project rocks and uses MIT-LICENSE.
