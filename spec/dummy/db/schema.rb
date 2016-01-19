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

ActiveRecord::Schema.define(version: 20151103155731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.decimal  "price",       precision: 11, scale: 2
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "stall_line_items", force: :cascade do |t|
    t.integer  "sellable_id"
    t.string   "sellable_type"
    t.string   "name",          null: false
    t.integer  "quantity",      null: false
    t.decimal  "eot_price",     null: false
    t.decimal  "price",         null: false
    t.decimal  "vat_rate",      null: false
    t.json     "data"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "stall_line_items", ["sellable_type", "sellable_id"], name: "index_stall_line_items_on_sellable_type_and_sellable_id", using: :btree

end
