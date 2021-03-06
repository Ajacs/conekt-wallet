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

ActiveRecord::Schema.define(version: 20180107003713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_balance_histories", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "transaction_id"
    t.float "last_balance"
    t.float "new_balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_balance_histories_on_account_id"
    t.index ["transaction_id"], name: "index_account_balance_histories_on_transaction_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "account_type"
    t.float "balance"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_number"
    t.string "obfuscated_account"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "transaction_histories", force: :cascade do |t|
    t.bigint "transaction_id"
    t.integer "transaction_status"
    t.string "status_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_id"], name: "index_transaction_histories_on_transaction_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "account_id"
    t.integer "transaction_type"
    t.float "amount"
    t.integer "transaction_status"
    t.string "status_message"
    t.string "destination_account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "commission"
    t.integer "transaction_target_type"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "lastname"
    t.string "email"
    t.string "password_digest"
    t.string "password_confirmation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "account_balance_histories", "accounts"
  add_foreign_key "account_balance_histories", "transactions"
  add_foreign_key "accounts", "users"
  add_foreign_key "transaction_histories", "transactions"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "users"
end
