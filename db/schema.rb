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

ActiveRecord::Schema.define(version: 20170910041521) do

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

  add_index "abstracts", ["author_id"], name: "index_abstracts_on_author_id", using: :btree
  add_index "abstracts", ["event_id", "author_id"], name: "index_abstracts_on_event_id_and_author_id", unique: true, using: :btree
  add_index "abstracts", ["event_id"], name: "index_abstracts_on_event_id", using: :btree

  create_table "attendees", force: :cascade do |t|
    t.string   "email",      null: false
    t.string   "name"
    t.boolean  "accepted"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "locale"
  end

  add_index "attendees", ["event_id", "email"], name: "index_attendees_on_event_id_and_email", unique: true, using: :btree
  add_index "attendees", ["event_id"], name: "index_attendees_on_event_id", using: :btree

  create_table "authors", force: :cascade do |t|
    t.string   "name",           limit: 255, null: false
    t.integer  "user_id"
    t.integer  "publication_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "flagged"
  end

  add_index "authors", ["name", "publication_id"], name: "index_authors_on_name_and_publication_id", unique: true, using: :btree
  add_index "authors", ["publication_id"], name: "index_authors_on_publication_id", using: :btree
  add_index "authors", ["user_id"], name: "index_authors_on_user_id", using: :btree

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

  add_index "events", ["name", "start_date"], name: "index_events_on_name_and_start_date", unique: true, using: :btree
  add_index "events", ["slug"], name: "index_events_on_slug", unique: true, using: :btree
  add_index "events", ["tagline"], name: "index_events_on_tagline", unique: true, using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

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

  add_index "groups", ["abbr"], name: "index_groups_on_abbr", unique: true, using: :btree
  add_index "groups", ["email"], name: "index_groups_on_email", unique: true, using: :btree
  add_index "groups", ["name"], name: "index_groups_on_name", unique: true, using: :btree

  create_table "journals", force: :cascade do |t|
    t.string   "name",          limit: 255, null: false
    t.string   "abbr",          limit: 255
    t.string   "website_url",   limit: 255
    t.float    "impact_factor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "journals", ["abbr"], name: "index_journals_on_abbr", unique: true, using: :btree
  add_index "journals", ["name"], name: "index_journals_on_name", unique: true, using: :btree

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

  add_index "moments", ["user_id"], name: "index_moments_on_user_id", using: :btree

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

  add_index "pages", ["owner_id", "slug"], name: "index_pages_on_owner_id_and_slug", unique: true, using: :btree
  add_index "pages", ["owner_id", "tagline"], name: "index_pages_on_owner_id_and_tagline", unique: true, using: :btree

  create_table "positions", force: :cascade do |t|
    t.string   "name",       limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
    t.string   "slug",       limit: 255
    t.boolean  "single",                 default: false
  end

  add_index "positions", ["name"], name: "index_positions_on_name", unique: true, using: :btree
  add_index "positions", ["slug"], name: "index_positions_on_slug", unique: true, using: :btree

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

  add_index "posts", ["event_id"], name: "index_posts_on_event_id", using: :btree
  add_index "posts", ["parent_id"], name: "index_posts_on_parent_id", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree

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

  add_index "projects", ["title", "identifier"], name: "index_projects_on_title_and_identifier", unique: true, using: :btree
  add_index "projects", ["title"], name: "index_projects_on_title", unique: true, using: :btree

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

  add_index "publications", ["doi"], name: "index_publications_on_doi", unique: true, using: :btree
  add_index "publications", ["identifier"], name: "index_publications_on_identifier", unique: true, using: :btree
  add_index "publications", ["journal_id"], name: "index_publications_on_journal_id", using: :btree
  add_index "publications", ["title"], name: "index_publications_on_title", unique: true, using: :btree
  add_index "publications", ["volume", "start_page"], name: "index_publications_on_volume_and_start_page", unique: true, using: :btree

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

  add_index "settings", ["user_id"], name: "index_settings_on_user_id", unique: true, using: :btree

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

  add_index "speakers", ["event_id"], name: "index_speakers_on_event_id", using: :btree

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

  add_index "theses", ["title"], name: "index_theses_on_title", unique: true, using: :btree
  add_index "theses", ["user_id"], name: "index_theses_on_user_id", using: :btree

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree
  add_index "users", ["position_id"], name: "index_users_on_position_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "abstracts", "authors"
  add_foreign_key "abstracts", "events"
  add_foreign_key "attendees", "events"
  add_foreign_key "posts", "events"
  add_foreign_key "posts", "posts", column: "parent_id"
end
