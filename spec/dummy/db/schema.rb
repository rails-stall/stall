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

ActiveRecord::Schema.define(version: 20170226183354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.decimal  "price",       precision: 11, scale: 2
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "category_id"
  end

  add_index "books", ["category_id"], name: "index_books_on_category_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "state"
    t.string   "type"
    t.integer  "addressable_id"
    t.string   "addressable_type"
  end

  create_table "stall_adjustments", force: :cascade do |t|
    t.string   "name",                                                   null: false
    t.decimal  "eot_price_cents", precision: 13, scale: 3, default: 0.0, null: false
    t.decimal  "price_cents",     precision: 13, scale: 3, default: 0.0, null: false
    t.decimal  "vat_rate",                                               null: false
    t.string   "type"
    t.integer  "cart_id"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.jsonb    "data"
  end

  add_index "stall_adjustments", ["cart_id"], name: "index_stall_adjustments_on_cart_id", using: :btree

  create_table "stall_credit_note_usages", force: :cascade do |t|
    t.integer  "credit_note_id"
    t.integer  "adjustment_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "stall_credit_note_usages", ["adjustment_id"], name: "index_stall_credit_note_usages_on_adjustment_id", using: :btree
  add_index "stall_credit_note_usages", ["credit_note_id"], name: "index_stall_credit_note_usages_on_credit_note_id", using: :btree

  create_table "stall_credit_notes", force: :cascade do |t|
    t.string   "reference"
    t.integer  "customer_id"
    t.string   "currency"
    t.decimal  "eot_amount_cents", precision: 13, scale: 3, default: 0.0, null: false
    t.decimal  "amount_cents",     precision: 13, scale: 3, default: 0.0, null: false
    t.decimal  "vat_rate",         precision: 11, scale: 2
    t.integer  "source_id"
    t.string   "source_type"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  add_index "stall_credit_notes", ["customer_id"], name: "index_stall_credit_notes_on_customer_id", using: :btree
  add_index "stall_credit_notes", ["source_type", "source_id"], name: "index_stall_credit_notes_on_source_type_and_source_id", using: :btree

  create_table "stall_customers", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "locale",     default: "fr"
  end

  add_index "stall_customers", ["user_type", "user_id"], name: "index_stall_customers_on_user_type_and_user_id", using: :btree

  create_table "stall_line_items", force: :cascade do |t|
    t.integer  "sellable_id"
    t.string   "sellable_type"
    t.integer  "product_list_id"
    t.string   "name",                                                        null: false
    t.integer  "quantity",                                                    null: false
    t.decimal  "unit_eot_price_cents", precision: 13, scale: 3, default: 0.0, null: false
    t.decimal  "unit_price_cents",     precision: 13, scale: 3, default: 0.0, null: false
    t.decimal  "eot_price_cents",      precision: 13, scale: 3, default: 0.0, null: false
    t.decimal  "price_cents",          precision: 13, scale: 3, default: 0.0, null: false
    t.decimal  "vat_rate",                                                    null: false
    t.jsonb    "data"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "stall_line_items", ["product_list_id"], name: "index_stall_line_items_on_product_list_id", using: :btree
  add_index "stall_line_items", ["sellable_type", "sellable_id"], name: "index_stall_line_items_on_sellable_type_and_sellable_id", using: :btree

  create_table "stall_manufacturers", force: :cascade do |t|
    t.string   "name"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "slug"
  end

  create_table "stall_payment_methods", force: :cascade do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "active",     default: true
  end

  create_table "stall_payments", force: :cascade do |t|
    t.integer  "payment_method_id"
    t.integer  "cart_id"
    t.datetime "paid_at"
    t.jsonb    "data"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "stall_payments", ["cart_id"], name: "index_stall_payments_on_cart_id", using: :btree
  add_index "stall_payments", ["payment_method_id"], name: "index_stall_payments_on_payment_method_id", using: :btree

  create_table "stall_product_categories", force: :cascade do |t|
    t.string   "name"
    t.text     "slug"
    t.integer  "position",   default: 0
    t.integer  "parent_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "stall_product_category_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "stall_product_category_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "stall_product_category_anc_desc_idx", unique: true, using: :btree
  add_index "stall_product_category_hierarchies", ["descendant_id"], name: "stall_product_category_desc_idx", using: :btree

  create_table "stall_product_details", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "name"
    t.text     "content"
    t.integer  "position",   default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "stall_product_details", ["product_id"], name: "index_stall_product_details_on_product_id", using: :btree

  create_table "stall_product_lists", force: :cascade do |t|
    t.string   "state",                           null: false
    t.string   "type",                            null: false
    t.string   "currency",                        null: false
    t.integer  "customer_id"
    t.string   "token",                           null: false
    t.jsonb    "data"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "identifier",  default: "default", null: false
    t.string   "reference"
  end

  add_index "stall_product_lists", ["customer_id"], name: "index_stall_product_lists_on_customer_id", using: :btree
  add_index "stall_product_lists", ["reference"], name: "index_stall_product_lists_on_reference", unique: true, using: :btree

  create_table "stall_products", force: :cascade do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "description"
    t.text     "slug"
    t.integer  "position"
    t.boolean  "visible"
    t.integer  "product_category_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "manufacturer_id"
  end

  add_index "stall_products", ["manufacturer_id"], name: "index_stall_products_on_manufacturer_id", using: :btree
  add_index "stall_products", ["product_category_id"], name: "index_stall_products_on_product_category_id", using: :btree

  create_table "stall_properties", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stall_property_values", force: :cascade do |t|
    t.integer  "property_id"
    t.string   "value"
    t.integer  "position",    default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "stall_property_values", ["property_id"], name: "index_stall_property_values_on_property_id", using: :btree

  create_table "stall_shipments", force: :cascade do |t|
    t.integer  "cart_id"
    t.integer  "shipping_method_id"
    t.decimal  "price_cents",                precision: 13, scale: 3, default: 0.0, null: false
    t.decimal  "eot_price_cents",            precision: 13, scale: 3, default: 0.0, null: false
    t.decimal  "vat_rate"
    t.datetime "sent_at"
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.jsonb    "data"
    t.integer  "state",                                               default: 0
    t.datetime "notification_email_sent_at"
  end

  add_index "stall_shipments", ["cart_id"], name: "index_stall_shipments_on_cart_id", using: :btree
  add_index "stall_shipments", ["shipping_method_id"], name: "index_stall_shipments_on_shipping_method_id", using: :btree

  create_table "stall_shipping_methods", force: :cascade do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "active",     default: true
  end

  create_table "stall_variant_property_values", force: :cascade do |t|
    t.integer  "property_value_id"
    t.integer  "variant_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "stall_variant_property_values", ["property_value_id"], name: "index_stall_variant_property_values_on_property_value_id", using: :btree
  add_index "stall_variant_property_values", ["variant_id"], name: "index_stall_variant_property_values_on_variant_id", using: :btree

  create_table "stall_variants", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "USD", null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "name"
    t.boolean  "published",      default: true
  end

  add_index "stall_variants", ["product_id"], name: "index_stall_variants_on_product_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "books", "categories"
  add_foreign_key "stall_adjustments", "stall_product_lists", column: "cart_id"
  add_foreign_key "stall_credit_note_usages", "stall_adjustments", column: "adjustment_id"
  add_foreign_key "stall_credit_note_usages", "stall_credit_notes", column: "credit_note_id"
  add_foreign_key "stall_credit_notes", "stall_customers", column: "customer_id"
  add_foreign_key "stall_line_items", "stall_product_lists", column: "product_list_id"
  add_foreign_key "stall_payments", "stall_payment_methods", column: "payment_method_id"
  add_foreign_key "stall_payments", "stall_product_lists", column: "cart_id"
  add_foreign_key "stall_product_details", "stall_products", column: "product_id"
  add_foreign_key "stall_product_lists", "stall_customers", column: "customer_id"
  add_foreign_key "stall_products", "stall_manufacturers", column: "manufacturer_id"
  add_foreign_key "stall_products", "stall_product_categories", column: "product_category_id"
  add_foreign_key "stall_property_values", "stall_properties", column: "property_id"
  add_foreign_key "stall_shipments", "stall_product_lists", column: "cart_id"
  add_foreign_key "stall_shipments", "stall_shipping_methods", column: "shipping_method_id"
  add_foreign_key "stall_variant_property_values", "stall_property_values", column: "property_value_id"
  add_foreign_key "stall_variant_property_values", "stall_variants", column: "variant_id"
  add_foreign_key "stall_variants", "stall_products", column: "product_id"
end
