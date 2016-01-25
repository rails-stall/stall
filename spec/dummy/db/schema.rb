# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160125100754) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.decimal  "price",       precision: 11, scale: 2
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "stall_address_ownerships", force: :cascade do |t|
    t.integer  "address_id"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.boolean  "billing",          default: false
    t.boolean  "shipping",         default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "stall_address_ownerships", ["address_id"], name: "index_stall_address_ownerships_on_address_id", using: :btree
  add_index "stall_address_ownerships", ["addressable_id", "addressable_type"], name: "index_address_ownerships_on_addressable_type_and_id", using: :btree

  create_table "stall_addresses", force: :cascade do |t|
    t.integer  "civility"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "address"
    t.text     "address_details"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.string   "phone"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "stall_customers", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stall_line_items", force: :cascade do |t|
    t.integer  "sellable_id"
    t.string   "sellable_type"
    t.integer  "product_list_id"
    t.string   "name",                             null: false
    t.integer  "quantity",                         null: false
    t.integer  "unit_eot_price_cents", default: 0, null: false
    t.integer  "unit_price_cents",     default: 0, null: false
    t.integer  "eot_price_cents",      default: 0, null: false
    t.integer  "price_cents",          default: 0, null: false
    t.decimal  "vat_rate",                         null: false
    t.json     "data"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "stall_line_items", ["product_list_id"], name: "index_stall_line_items_on_product_list_id", using: :btree
  add_index "stall_line_items", ["sellable_type", "sellable_id"], name: "index_stall_line_items_on_sellable_type_and_sellable_id", using: :btree

  create_table "stall_payment_methods", force: :cascade do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stall_payments", force: :cascade do |t|
    t.integer  "payment_method_id"
    t.integer  "cart_id"
    t.datetime "paid_at"
    t.json     "data"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "stall_payments", ["cart_id"], name: "index_stall_payments_on_cart_id", using: :btree
  add_index "stall_payments", ["payment_method_id"], name: "index_stall_payments_on_payment_method_id", using: :btree

  create_table "stall_product_lists", force: :cascade do |t|
    t.string   "state",       null: false
    t.string   "type",        null: false
    t.string   "currency",    null: false
    t.integer  "customer_id"
    t.string   "token",       null: false
    t.json     "data"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "stall_product_lists", ["customer_id"], name: "index_stall_product_lists_on_customer_id", using: :btree

  create_table "stall_shipments", force: :cascade do |t|
    t.integer  "cart_id"
    t.integer  "shipping_method_id"
    t.integer  "price_cents",        default: 0, null: false
    t.integer  "eot_price_cents",    default: 0, null: false
    t.decimal  "vat_rate"
    t.datetime "sent_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "stall_shipments", ["cart_id"], name: "index_stall_shipments_on_cart_id", using: :btree
  add_index "stall_shipments", ["shipping_method_id"], name: "index_stall_shipments_on_shipping_method_id", using: :btree

  create_table "stall_shipping_methods", force: :cascade do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "stall_address_ownerships", "stall_addresses", column: "address_id"
  add_foreign_key "stall_line_items", "stall_product_lists", column: "product_list_id"
  add_foreign_key "stall_payments", "stall_payment_methods", column: "payment_method_id"
  add_foreign_key "stall_payments", "stall_product_lists", column: "cart_id"
  add_foreign_key "stall_product_lists", "stall_customers", column: "customer_id"
  add_foreign_key "stall_shipments", "stall_product_lists", column: "cart_id"
  add_foreign_key "stall_shipments", "stall_shipping_methods", column: "shipping_method_id"
end
