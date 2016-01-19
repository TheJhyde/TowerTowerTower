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

ActiveRecord::Schema.define(version: 20160119211146) do

  create_table "clay_shipments", force: :cascade do |t|
    t.string   "message"
    t.datetime "used"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "clay"
  end

  add_index "clay_shipments", ["user_id"], name: "index_clay_shipments_on_user_id"

  create_table "clays", force: :cascade do |t|
    t.integer  "color"
    t.integer  "clay_shipment_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "clays", ["clay_shipment_id"], name: "index_clays_on_clay_shipment_id"

  create_table "glyphs", force: :cascade do |t|
    t.string   "url"
    t.string   "meaning"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mines", force: :cascade do |t|
    t.integer  "red_clay"
    t.integer  "brown_clay"
    t.integer  "black_clay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "user_name"
    t.string   "gender"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["user_name"], name: "index_users_on_user_name", unique: true

end
