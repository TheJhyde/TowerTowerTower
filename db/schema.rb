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

ActiveRecord::Schema.define(version: 20160408171538) do

  create_table "bricks", force: :cascade do |t|
    t.integer  "x"
    t.integer  "y"
    t.integer  "color"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id"
    t.integer  "strength",    default: 0
    t.integer  "stranger_id"
    t.integer  "level_id"
  end

  add_index "bricks", ["level_id"], name: "index_bricks_on_level_id"

  create_table "build_orders", force: :cascade do |t|
    t.string   "message"
    t.integer  "colors"
    t.integer  "user_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "x"
    t.string   "y"
    t.datetime "used"
    t.datetime "resolve_at",  default: '2016-03-10 19:50:47'
    t.integer  "stranger_id"
    t.integer  "level_id"
  end

  add_index "build_orders", ["level_id"], name: "index_build_orders_on_level_id"

  create_table "events", force: :cascade do |t|
    t.integer  "category",           default: 0, null: false
    t.integer  "brick_id"
    t.integer  "build_order_id"
    t.integer  "original_player_id"
    t.integer  "placing_player_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "glyphs", force: :cascade do |t|
    t.string   "url"
    t.string   "meaning"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "levels", force: :cascade do |t|
    t.string   "background"
    t.string   "text"
    t.integer  "level"
    t.integer  "strength_requirement"
    t.integer  "update_rate"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "news_items", force: :cascade do |t|
    t.string   "message"
    t.string   "msg_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news_items_users", id: false, force: :cascade do |t|
    t.integer "user_id",      null: false
    t.integer "news_item_id", null: false
  end

  add_index "news_items_users", ["news_item_id", "user_id"], name: "index_news_items_users_on_news_item_id_and_user_id"
  add_index "news_items_users", ["user_id", "news_item_id"], name: "index_news_items_users_on_user_id_and_news_item_id"

  create_table "strangers", force: :cascade do |t|
    t.integer  "number"
    t.integer  "actions",    default: 2
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tower_pics", force: :cascade do |t|
    t.string   "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "gender"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "curse"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.integer  "actions",           default: 2
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean  "signed_up",         default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
