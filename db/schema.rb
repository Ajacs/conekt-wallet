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

ActiveRecord::Schema.define(version: 20180102180816) do

  create_table "account_balance_histories", force: :cascade do |t|
    t.integer "account_id"
    t.integer "transaction_id"
    t.float "last_balance"
    t.float "new_balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_balance_histories_on_account_id"
    t.index ["transaction_id"], name: "index_account_balance_histories_on_transaction_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "user_id"
    t.string "account_type"
    t.float "balance"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_number"
    t.string "obfuscated_account"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "transaction_histories", force: :cascade do |t|
    t.integer "transaction_id"
    t.integer "transaction_status"
    t.string "status_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_id"], name: "index_transaction_histories_on_transaction_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "account_id"
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

end
