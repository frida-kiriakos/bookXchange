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

ActiveRecord::Schema.define(version: 20141127012900) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "education"
    t.boolean  "admin"
    t.string   "address"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.integer  "credit",          default: 0
    t.integer  "num_logins",      default: 0
  end

  add_index "accounts", ["remember_token"], name: "index_accounts_on_remember_token", using: :btree

  create_table "books", force: true do |t|
    t.string   "title"
    t.string   "author"
    t.integer  "edition"
    t.string   "ISBN"
    t.string   "course"
    t.integer  "book_type",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.integer  "sell"
    t.integer  "amount"
    t.string   "paypal_account"
  end

  add_index "books", ["ISBN"], name: "index_books_on_ISBN", using: :btree
  add_index "books", ["author"], name: "index_books_on_author", using: :btree
  add_index "books", ["course"], name: "index_books_on_course", using: :btree
  add_index "books", ["title"], name: "index_books_on_title", using: :btree

  create_table "transactions", force: true do |t|
    t.string   "to"
    t.string   "from"
    t.integer  "amount"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "book_id"
  end

end
