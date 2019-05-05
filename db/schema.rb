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

ActiveRecord::Schema.define(version: 20190505185943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abstracts", force: :cascade do |t|
    t.integer  "author_id"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.integer  "event_id"
    t.string   "submitted_at"
    t.string   "title",                 limit: 255
    t.string   "token"
    t.datetime "token_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendees", force: :cascade do |t|
    t.string   "email",                   null: false
    t.string   "name"
    t.boolean  "accepted"
    t.integer  "event_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "locale"
    t.string   "institution", limit: 255
  end

  create_table "authors", force: :cascade do |t|
    t.string   "name",           limit: 255, null: false
    t.integer  "user_id"
    t.integer  "publication_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "flagged"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",                           limit: 255,                 null: false
    t.date     "start_date",                                                 null: false
    t.date     "end_date"
    t.string   "location",                       limit: 255,                 null: false
    t.text     "description"
    t.string   "event_type",                     limit: 255,                 null: false
    t.string   "promoter",                       limit: 255
    t.string   "picture_file_name",              limit: 255
    t.string   "picture_content_type",           limit: 255
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",                           limit: 255
    t.integer  "max_attendee"
    t.boolean  "managed",                                    default: false
    t.boolean  "registration_enabled",                       default: false
    t.text     "localized_description"
    t.string   "tagline",                        limit: 128
    t.text     "abstract_section"
    t.text     "localized_abstract_section"
    t.string   "abstract_template_file_name"
    t.string   "abstract_template_content_type"
    t.integer  "abstract_template_file_size"
    t.datetime "abstract_template_updated_at"
    t.date     "abstract_deadline"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "abbr",             limit: 255
    t.string   "logo",             limit: 255
    t.string   "email",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "banner_image_url", limit: 255
    t.string   "tagline",          limit: 255
    t.text     "address"
    t.text     "overview"
  end

  create_table "journals", force: :cascade do |t|
    t.string   "name",          limit: 255, null: false
    t.string   "abbr",          limit: 255
    t.string   "website_url",   limit: 255
    t.float    "impact_factor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moments", force: :cascade do |t|
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "caption",            limit: 255
    t.date     "taken_on"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.string   "tagline",             limit: 255
    t.text     "body"
    t.integer  "owner_id"
    t.integer  "author_id"
    t.integer  "edited_by_id"
    t.boolean  "published",                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "trashed",                         default: false
    t.integer  "position"
    t.string   "slug",                limit: 255
    t.string   "banner_file_name",    limit: 255
    t.string   "banner_content_type", limit: 255
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
  end

  create_table "positions", force: :cascade do |t|
    t.string   "name",       limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
    t.string   "slug",       limit: 255
    t.boolean  "single",                 default: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.string   "slug",         limit: 255
    t.integer  "author_id"
    t.integer  "edited_by_id"
    t.text     "body"
    t.boolean  "published",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_count",               default: 0,     null: false
    t.integer  "event_id"
    t.string   "locale"
    t.integer  "parent_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.integer  "user_id"
    t.integer  "start_year"
    t.integer  "end_year"
    t.string   "source",      limit: 255
    t.string   "identifier",  limit: 255
    t.text     "description"
    t.string   "image_url",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position",    limit: 255
  end

  create_table "publications", force: :cascade do |t|
    t.string   "doi",        limit: 255
    t.string   "url",        limit: 255
    t.string   "volume",     limit: 255
    t.string   "issue",      limit: 10
    t.integer  "start_page"
    t.integer  "end_page"
    t.integer  "month"
    t.integer  "year"
    t.string   "title",      limit: 1000
    t.string   "identifier", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "journal_id"
  end

  create_table "settings", force: :cascade do |t|
    t.boolean "update_attributes_by_provider", default: true
    t.boolean "update_nickname_by_provider",   default: false
    t.boolean "update_image_by_provider",      default: true
    t.boolean "show_contact_page",             default: true
    t.boolean "deliver_notification_by_email", default: true
    t.integer "user_id"
    t.boolean "autolink_on_import",            default: true
    t.boolean "display_author_name",           default: true
    t.boolean "include_lastname",              default: true
  end

  create_table "speakers", force: :cascade do |t|
    t.string   "name",               null: false
    t.string   "description",        null: false
    t.string   "institution",        null: false
    t.string   "website_url"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "theses", force: :cascade do |t|
    t.string   "title",                 limit: 255, null: false
    t.integer  "issued",                            null: false
    t.string   "institution",           limit: 255, null: false
    t.text     "abstract"
    t.text     "notes"
    t.string   "keywords",              limit: 255
    t.integer  "user_id"
    t.string   "pdf_file_file_name",    limit: 255
    t.string   "pdf_file_content_type", limit: 255
    t.integer  "pdf_file_file_size"
    t.datetime "pdf_file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "keywords_digest",       limit: 255
    t.string   "slug",                  limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type",        limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "nickname",               limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "image_url",              limit: 255
    t.integer  "role",                   limit: 2,   default: 0
    t.string   "headline",               limit: 255
    t.text     "social_links"
    t.text     "bio"
    t.integer  "position_id"
    t.string   "banner_file_name",       limit: 255
    t.string   "banner_content_type",    limit: 255
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.datetime "last_import_at"
    t.integer  "view_count",                         default: 0,     null: false
    t.boolean  "member",                             default: false
    t.string   "research_gate"
  end

  add_foreign_key "abstracts", "authors", name: "abstracts_author_id_fkey"
  add_foreign_key "abstracts", "events", name: "abstracts_event_id_fkey"
  add_foreign_key "attendees", "events", name: "attendees_event_id_fkey"
  add_foreign_key "posts", "events", name: "posts_event_id_fkey"
  add_foreign_key "posts", "posts", column: "parent_id", name: "posts_parent_id_fkey"
end
