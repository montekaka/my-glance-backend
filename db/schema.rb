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

ActiveRecord::Schema.define(version: 2021_11_10_231529) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.text "short_description"
    t.string "avatar_url"
    t.string "banner_art_url"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.string "primary_color"
    t.string "secondary_color"
    t.string "success_color"
    t.string "danger_color"
    t.string "warning_color"
    t.string "info_color"
    t.string "light_color"
    t.string "dark_color"
    t.string "font_family"
    t.index ["slug"], name: "index_profiles_on_slug", unique: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "social_networks", force: :cascade do |t|
    t.string "name"
    t.string "icon_name"
    t.string "url"
    t.bigint "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sort_order"
    t.index ["profile_id"], name: "index_social_networks_on_profile_id"
  end

  create_table "tech_skills", force: :cascade do |t|
    t.string "name"
    t.string "icon_name"
    t.string "url"
    t.integer "sort_order"
    t.bigint "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profile_id"], name: "index_tech_skills_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "widgets", force: :cascade do |t|
    t.string "name"
    t.string "widget_type"
    t.string "icon_name"
    t.string "post_title"
    t.text "post_description"
    t.string "url"
    t.integer "sort_order"
    t.boolean "is_dynamic_content"
    t.string "image_url"
    t.string "section_name"
    t.string "link_type"
    t.string "user_name"
    t.bigint "profile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "avatar_url"
    t.boolean "show_thumbnail"
    t.index ["profile_id"], name: "index_widgets_on_profile_id"
  end

  add_foreign_key "profiles", "users"
  add_foreign_key "social_networks", "profiles"
  add_foreign_key "tech_skills", "profiles"
  add_foreign_key "widgets", "profiles"
end
