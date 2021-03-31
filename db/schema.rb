# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_23_170420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "deliveries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "rider_id"
    t.bigint "delivery_category_id", null: false
    t.integer "sequence"
    t.index ["delivery_category_id"], name: "index_deliveries_on_delivery_category_id"
    t.index ["rider_id"], name: "index_deliveries_on_rider_id"
  end

  create_table "delivery_categories", force: :cascade do |t|
    t.string "name"
    t.bigint "rider_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rider_id"], name: "index_delivery_categories_on_rider_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "customer_name"
    t.string "customer_email"
    t.string "meal_size"
    t.string "meal_protein"
    t.string "meal_custom"
    t.text "notes"
    t.string "telephone"
    t.text "delivery_address"
    t.string "order_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id"
    t.string "meal_date"
    t.string "category"
    t.bigint "delivery_id"
    t.boolean "delivered", default: false
    t.bigint "sticker_id"
    t.boolean "printed", default: false
    t.integer "sequence"
    t.string "meal_name"
    t.bigint "delivery_category_id"
    t.index ["delivery_category_id"], name: "index_orders_on_delivery_category_id"
    t.index ["delivery_id"], name: "index_orders_on_delivery_id"
    t.index ["product_id"], name: "index_orders_on_product_id"
    t.index ["sticker_id"], name: "index_orders_on_sticker_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "meal_name"
    t.string "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "category_id"
    t.string "qr", default: "thc-QRCode.png"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "riders", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["user_id"], name: "index_riders_on_user_id"
  end

  create_table "stickers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.string "email", default: "thc@mail.com"
    t.integer "role"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "deliveries", "delivery_categories"
  add_foreign_key "delivery_categories", "riders"
  add_foreign_key "orders", "delivery_categories"
  add_foreign_key "orders", "products"
  add_foreign_key "orders", "stickers"
  add_foreign_key "products", "categories"
  add_foreign_key "riders", "users"
end
