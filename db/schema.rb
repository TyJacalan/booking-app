# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_30_050435) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.text "description", null: false
    t.bigint "client_id", null: false
    t.bigint "freelancer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start"
    t.datetime "end"
    t.bigint "service_id"
    t.integer "duration"
    t.integer "fee", default: 0
    t.integer "status", default: 0
    t.boolean "review_notification_sent", default: false, null: false
    t.boolean "is_completed", default: false, null: false
    t.string "payment_intent_id"
    t.index ["client_id"], name: "index_appointments_on_client_id"
    t.index ["freelancer_id"], name: "index_appointments_on_freelancer_id"
    t.index ["service_id"], name: "index_appointments_on_service_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_services", id: false, force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "category_id", null: false
    t.index ["service_id", "category_id"], name: "index_categories_services_on_service_id_and_category_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "subject", null: false
    t.bigint "client_id"
    t.bigint "freelancer_id"
    t.bigint "review_id", null: false
    t.bigint "appointment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "likes_count", default: 0
    t.index ["appointment_id"], name: "index_comments_on_appointment_id"
    t.index ["client_id"], name: "index_comments_on_client_id"
    t.index ["freelancer_id"], name: "index_comments_on_freelancer_id"
    t.index ["review_id"], name: "index_comments_on_review_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "likeable_type", null: false
    t.bigint "likeable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["user_id", "likeable_type", "likeable_id"], name: "index_likes_on_user_id_and_likeable_type_and_likeable_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "overall_service_ratings", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.integer "professionalism", default: 0
    t.integer "quality", default: 0
    t.integer "punctuality", default: 0
    t.integer "communication", default: 0
    t.integer "value", default: 0
    t.integer "overall_rating", default: 0
    t.integer "count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_overall_service_ratings_on_service_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "subject"
    t.bigint "client_id", null: false
    t.bigint "freelancer_id", null: false
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "likes_count", default: 0
    t.integer "professionalism", null: false
    t.integer "punctuality", null: false
    t.integer "quality", null: false
    t.integer "communication", null: false
    t.integer "value", null: false
    t.integer "overall_rating", null: false
    t.bigint "appointment_id", null: false
    t.index ["appointment_id"], name: "index_reviews_on_appointment_id"
    t.index ["client_id"], name: "index_reviews_on_client_id"
    t.index ["freelancer_id"], name: "index_reviews_on_freelancer_id"
    t.index ["service_id"], name: "index_reviews_on_service_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.json "permissions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "price", null: false
    t.json "categories", default: []
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: ""
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.string "provider"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "biography"
    t.json "skills", default: []
    t.date "birthdate"
    t.string "address"
    t.string "city"
    t.string "country"
    t.string "mobile"
    t.float "latitude"
    t.float "longitude"
    t.bigint "role_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "appointments", "services"
  add_foreign_key "appointments", "users", column: "client_id"
  add_foreign_key "appointments", "users", column: "freelancer_id"
  add_foreign_key "comments", "appointments"
  add_foreign_key "comments", "reviews"
  add_foreign_key "comments", "users", column: "client_id"
  add_foreign_key "comments", "users", column: "freelancer_id"
  add_foreign_key "likes", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "overall_service_ratings", "services"
  add_foreign_key "reviews", "appointments"
  add_foreign_key "reviews", "services"
  add_foreign_key "reviews", "users", column: "client_id"
  add_foreign_key "reviews", "users", column: "freelancer_id"
  add_foreign_key "services", "users"
  add_foreign_key "users", "roles"
end
