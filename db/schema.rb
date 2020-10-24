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

ActiveRecord::Schema.define(version: 2020_10_24_201133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "line_1"
    t.string "line_2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_addresses_on_organization_id"
  end

  create_table "organization_admins", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_organization_admins_on_organization_id"
    t.index ["user_id"], name: "index_organization_admins_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "requires_approval"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
    t.index ["organization_id"], name: "index_roles_on_organization_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "shift_type_id"
    t.integer "spots"
    t.date "start_date"
    t.date "end_date"
    t.time "start_time"
    t.time "end_time"
    t.bigint "organization_id"
    t.integer "frequency"
    t.string "frequency_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "days_out"
    t.index ["organization_id"], name: "index_schedules_on_organization_id"
    t.index ["shift_type_id"], name: "index_schedules_on_shift_type_id"
  end

  create_table "shift_types", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "role_id"
    t.bigint "address_id"
    t.datetime "deleted_at"
    t.index ["address_id"], name: "index_shift_types_on_address_id"
    t.index ["deleted_at"], name: "index_shift_types_on_deleted_at"
    t.index ["organization_id"], name: "index_shift_types_on_organization_id"
    t.index ["role_id"], name: "index_shift_types_on_role_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.bigint "shift_type_id", null: false
    t.integer "spots"
    t.bigint "address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "remaining_spots"
    t.bigint "organization_id"
    t.bigint "schedule_id"
    t.time "start_time"
    t.time "end_time"
    t.date "date"
    t.index ["address_id"], name: "index_shifts_on_address_id"
    t.index ["organization_id"], name: "index_shifts_on_organization_id"
    t.index ["schedule_id"], name: "index_shifts_on_schedule_id"
    t.index ["shift_type_id"], name: "index_shifts_on_shift_type_id"
  end

  create_table "user_organizations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_approved"
    t.integer "status"
    t.index ["organization_id"], name: "index_user_organizations_on_organization_id"
    t.index ["user_id"], name: "index_user_organizations_on_user_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "user_shifts", force: :cascade do |t|
    t.bigint "shift_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shift_id"], name: "index_user_shifts_on_shift_id"
    t.index ["user_id"], name: "index_user_shifts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "avatar_url"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "organizations"
  add_foreign_key "organization_admins", "organizations"
  add_foreign_key "organization_admins", "users"
  add_foreign_key "roles", "organizations"
  add_foreign_key "schedules", "organizations"
  add_foreign_key "schedules", "shift_types"
  add_foreign_key "shift_types", "organizations"
  add_foreign_key "shifts", "addresses"
  add_foreign_key "shifts", "shift_types"
  add_foreign_key "user_organizations", "organizations"
  add_foreign_key "user_organizations", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_shifts", "shifts"
  add_foreign_key "user_shifts", "users"
end
