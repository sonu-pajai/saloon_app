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

ActiveRecord::Schema.define(version: 2022_02_18_075536) do

  create_table "appointments", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "service_id"
    t.bigint "user_id"
    t.bigint "start_time_id"
    t.bigint "end_time_id"
    t.date "date"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id", "date"], name: "index_appointments_on_company_id_and_date"
    t.index ["company_id", "status"], name: "index_appointments_on_company_id_and_status"
    t.index ["company_id"], name: "index_appointments_on_company_id"
    t.index ["end_time_id"], name: "index_appointments_on_end_time_id"
    t.index ["service_id"], name: "index_appointments_on_service_id"
    t.index ["start_time_id"], name: "index_appointments_on_start_time_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "companies", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "start_time_id"
    t.bigint "end_time_id"
    t.string "gstin"
    t.string "pan"
    t.string "name"
    t.text "address"
    t.integer "chairs"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["end_time_id"], name: "index_companies_on_end_time_id"
    t.index ["start_time_id"], name: "index_companies_on_start_time_id"
  end

  create_table "jwt_denylist", charset: "utf8mb4", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", precision: 6, null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "services", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10
    t.integer "time"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_services_on_company_id"
    t.index ["name"], name: "index_services_on_name", unique: true
  end

  create_table "time_slots", charset: "utf8mb4", force: :cascade do |t|
    t.string "from_time"
    t.string "to_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_time", "to_time"], name: "index_time_slots_on_from_time_and_to_time", unique: true
    t.index ["from_time"], name: "index_time_slots_on_from_time"
    t.index ["to_time"], name: "index_time_slots_on_to_time"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.boolean "is_active", default: true, null: false
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
