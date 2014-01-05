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

ActiveRecord::Schema.define(version: 20140104212305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: true do |t|
    t.string   "name",           null: false
    t.integer  "user_id"
    t.integer  "publication_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authors", ["name", "publication_id"], name: "index_authors_on_name_and_publication_id", unique: true, using: :btree
  add_index "authors", ["publication_id"], name: "index_authors_on_publication_id", using: :btree
  add_index "authors", ["user_id"], name: "index_authors_on_user_id", using: :btree

  create_table "external_users", force: true do |t|
    t.string   "first_name",  null: false
    t.string   "last_name",   null: false
    t.string   "institution", null: false
    t.string   "city",        null: false
    t.string   "country",     null: false
    t.string   "website_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "external_users", ["first_name", "last_name"], name: "index_external_users_on_first_name_and_last_name", unique: true, using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.string   "logo"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "banner_image_url"
    t.string   "tagline"
    t.text     "address"
  end

  add_index "groups", ["abbr"], name: "index_groups_on_abbr", unique: true, using: :btree
  add_index "groups", ["email"], name: "index_groups_on_email", unique: true, using: :btree
  add_index "groups", ["name"], name: "index_groups_on_name", unique: true, using: :btree

  create_table "journals", force: true do |t|
    t.string   "name",          null: false
    t.string   "abbr"
    t.string   "website_url"
    t.float    "impact_factor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "journals", ["abbr"], name: "index_journals_on_abbr", unique: true, using: :btree
  add_index "journals", ["name"], name: "index_journals_on_name", unique: true, using: :btree

  create_table "pages", force: true do |t|
    t.string   "title"
    t.string   "tagline"
    t.text     "body"
    t.integer  "owner_id"
    t.integer  "author_id"
    t.integer  "edited_by_id"
    t.boolean  "published",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "trashed",      default: false
    t.integer  "position"
    t.string   "slug"
  end

  add_index "pages", ["owner_id", "slug"], name: "index_pages_on_owner_id_and_slug", unique: true, using: :btree
  add_index "pages", ["owner_id", "tagline"], name: "index_pages_on_owner_id_and_tagline", unique: true, using: :btree

  create_table "positions", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "positions", ["name"], name: "index_positions_on_name", unique: true, using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "author_id"
    t.integer  "edited_by_id"
    t.text     "body"
    t.boolean  "published",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "start_year"
    t.integer  "end_year"
    t.string   "source"
    t.string   "identifier"
    t.text     "description"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position"
  end

  add_index "projects", ["title", "identifier"], name: "index_projects_on_title_and_identifier", unique: true, using: :btree
  add_index "projects", ["title"], name: "index_projects_on_title", unique: true, using: :btree

  create_table "publications", force: true do |t|
    t.string   "doi"
    t.string   "url"
    t.string   "journal"
    t.string   "volume"
    t.integer  "issue"
    t.integer  "start_page"
    t.integer  "end_page"
    t.integer  "month"
    t.integer  "year"
    t.string   "title",      limit: 1000
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "claimed",                 default: false
    t.integer  "journal_id"
  end

  add_index "publications", ["doi"], name: "index_publications_on_doi", unique: true, using: :btree
  add_index "publications", ["identifier"], name: "index_publications_on_identifier", unique: true, using: :btree
  add_index "publications", ["journal_id"], name: "index_publications_on_journal_id", using: :btree
  add_index "publications", ["title"], name: "index_publications_on_title", unique: true, using: :btree
  add_index "publications", ["volume", "start_page"], name: "index_publications_on_volume_and_start_page", unique: true, using: :btree

  create_table "settings", force: true do |t|
    t.boolean "update_attributes_by_provider", default: true
    t.boolean "update_nickname_by_provider",   default: false
    t.boolean "update_image_by_provider",      default: true
    t.boolean "show_contact_page",             default: true
    t.boolean "deliver_notification_by_email", default: true
    t.integer "user_id"
    t.boolean "autolink_on_import",            default: true
    t.boolean "display_author_name",           default: false
    t.boolean "include_lastname",              default: false
  end

  add_index "settings", ["user_id"], name: "index_settings_on_user_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                            default: "", null: false
    t.string   "encrypted_password",               default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image_url"
    t.integer  "role",                   limit: 2, default: 0
    t.string   "headline"
    t.text     "signature"
    t.text     "bio"
    t.integer  "position_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree
  add_index "users", ["position_id"], name: "index_users_on_position_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
