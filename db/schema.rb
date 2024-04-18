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

ActiveRecord::Schema.define(version: 2024_04_17_203015) do

  create_table "reports", force: :cascade do |t|
    t.string "name", null: false
    t.string "location", null: false
    t.string "currency", null: false
    t.string "symbol", null: false
    t.string "external_report_id", null: false
    t.string "format", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transactions", id: :string, force: :cascade do |t|
    t.string "intent_id", null: false
    t.string "external_id"
    t.integer "value_in_cents", null: false
    t.string "currency", null: false
    t.datetime "paid_at"
    t.string "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "report_id"
    t.index ["external_id"], name: "index_transactions_on_external_id", unique: true
    t.index ["report_id"], name: "index_transactions_on_report_id"
  end

  add_foreign_key "transactions", "reports"
end
