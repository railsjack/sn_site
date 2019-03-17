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

ActiveRecord::Schema.define(version: 20160514100126) do

  create_table "access_settings", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "tab_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activities", force: :cascade do |t|
    t.integer  "employee_id",     limit: 4
    t.boolean  "shift_started",             default: false
    t.boolean  "shift_completed",           default: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id",      limit: 4
  end

  create_table "appointment_transfers", force: :cascade do |t|
    t.text     "ids",            limit: 65535
    t.integer  "transfer_count", limit: 4
    t.datetime "transfer_date"
    t.integer  "company_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "person",         limit: 255
    t.integer  "transfer_type",  limit: 4
    t.integer  "person_id",      limit: 4
    t.text     "document",       limit: 65535
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id",    limit: 4
    t.string   "auditable_type",  limit: 255
    t.integer  "associated_id",   limit: 4
    t.string   "associated_type", limit: 255
    t.integer  "user_id",         limit: 4
    t.string   "user_type",       limit: 255
    t.string   "username",        limit: 255
    t.string   "action",          limit: 255
    t.text     "audited_changes", limit: 65535
    t.integer  "version",         limit: 4,     default: 0
    t.string   "comment",         limit: 255
    t.string   "remote_address",  limit: 255
    t.string   "request_uuid",    limit: 255
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "company_name",         limit: 255
    t.string   "business_name",        limit: 255
    t.string   "provider_type",        limit: 255
    t.string   "telephone",            limit: 255
    t.string   "mobile_phone_number",  limit: 255
    t.boolean  "get_notification",                 default: false
    t.string   "address",              limit: 255
    t.string   "city",                 limit: 255
    t.string   "country",              limit: 255
    t.string   "state",                limit: 255
    t.string   "zip",                  limit: 255
    t.string   "contact_last_name",    limit: 255
    t.string   "contact_first_name",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",               limit: 255, default: "pending"
    t.string   "email",                limit: 255
    t.string   "county",               limit: 255
    t.string   "contact_method",       limit: 255
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
    t.integer  "picture_file_size",    limit: 8
    t.datetime "picture_updated_at"
    t.boolean  "featured",                         default: false
    t.float    "latitude",             limit: 53,  default: 0.0
    t.float    "longitude",            limit: 53,  default: 0.0
    t.boolean  "notification_masking",             default: false
    t.boolean  "lovedone_masking",                 default: false
    t.string   "time_zone",            limit: 255
    t.float    "abbreviated_time",     limit: 24,  default: 15.0
    t.integer  "employee_spoke",       limit: 4
    t.integer  "lovedone_spoke",       limit: 4
  end

  create_table "company_members", force: :cascade do |t|
    t.integer  "company_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.boolean  "admin",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_message_employees", force: :cascade do |t|
    t.integer  "company_message_id", limit: 4
    t.integer  "employee_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_messages", force: :cascade do |t|
    t.integer  "company_id", limit: 4
    t.text     "message",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address",    limit: 255
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "designations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "color",      limit: 255
    t.string   "company_id", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "designations", ["deleted_at"], name: "index_designations_on_deleted_at", using: :btree

  create_table "emails", force: :cascade do |t|
    t.string   "email",          limit: 255
    t.integer  "emailable_id",   limit: 4
    t.string   "emailable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_company_categories", force: :cascade do |t|
    t.integer  "employee_id",         limit: 4
    t.integer  "company_category_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_imports", force: :cascade do |t|
    t.integer  "company_id",     limit: 4
    t.string   "first_name",     limit: 255
    t.string   "last_name",      limit: 255
    t.string   "phone_number",   limit: 255
    t.string   "address",        limit: 255
    t.string   "state",          limit: 255
    t.string   "county",         limit: 255
    t.string   "city",           limit: 255
    t.string   "zip",            limit: 255
    t.string   "email",          limit: 255
    t.string   "username",       limit: 255
    t.string   "password",       limit: 255
    t.string   "designation_id", limit: 255
    t.integer  "status",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_lovedones", force: :cascade do |t|
    t.integer  "employee_id", limit: 4
    t.integer  "lovedone_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: :cascade do |t|
    t.float    "latitude",       limit: 53,                            default: 0.0
    t.float    "longitude",      limit: 53,                            default: 0.0
    t.integer  "company_id",     limit: 4
    t.integer  "lovedone_id",    limit: 4
    t.string   "name_no_use",    limit: 255
    t.string   "username",       limit: 255
    t.string   "password",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service_status", limit: 255
    t.string   "first_name",     limit: 255
    t.string   "last_name",      limit: 255
    t.integer  "designation_id", limit: 4
    t.decimal  "distance",                     precision: 8, scale: 2, default: 0.0
    t.string   "phone_number",   limit: 255
    t.string   "address",        limit: 255
    t.string   "state",          limit: 255
    t.string   "county",         limit: 255
    t.string   "city",           limit: 255
    t.string   "zip",            limit: 255
    t.float    "base_latitude",  limit: 24
    t.float    "base_longitude", limit: 24
    t.string   "device_type",    limit: 255
    t.text     "device_id",      limit: 65535
    t.string   "email",          limit: 255
    t.datetime "deleted_at"
    t.integer  "setting",        limit: 4,                             default: 0
    t.integer  "user_id",        limit: 4
  end

  add_index "employees", ["company_id"], name: "index_employees_on_company_id", using: :btree
  add_index "employees", ["deleted_at"], name: "index_employees_on_deleted_at", using: :btree
  add_index "employees", ["lovedone_id"], name: "index_employees_on_lovedone_id", using: :btree

  create_table "family_members", force: :cascade do |t|
    t.string   "lastname",    limit: 255
    t.string   "firstname",   limit: 255
    t.string   "email",       limit: 255
    t.string   "mobilephone", limit: 255
    t.string   "contact",     limit: 255
    t.integer  "city",        limit: 4
    t.integer  "county",      limit: 4
    t.integer  "state",       limit: 4
    t.string   "username",    limit: 255
    t.string   "password",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fees", force: :cascade do |t|
    t.integer  "company_id",       limit: 4
    t.float    "base_fee",         limit: 24
    t.float    "employee_fee",     limit: 24
    t.float    "reach_out_fee",    limit: 24
    t.boolean  "base_status",                 default: false
    t.boolean  "employee_status",             default: false
    t.boolean  "reach_out_status",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "transfer_fee",     limit: 24, default: 1.95
    t.boolean  "transfer_status",             default: true
  end

  create_table "followers", force: :cascade do |t|
    t.integer  "user_id",                limit: 4
    t.integer  "lovedone_id",            limit: 4
    t.string   "request_status",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "email",                  limit: 255
    t.string   "phone_number",           limit: 255
    t.text     "contact_method",         limit: 65535
    t.datetime "deleted_at"
    t.string   "apt_unit",               limit: 255
    t.string   "street",                 limit: 255
    t.string   "city",                   limit: 255
    t.string   "county",                 limit: 255
    t.string   "state",                  limit: 255
    t.string   "zip_code",               limit: 255
    t.integer  "setting",                limit: 4,     default: 0
    t.integer  "contact_method_setting", limit: 4,     default: 0
  end

  add_index "followers", ["deleted_at"], name: "index_followers_on_deleted_at", using: :btree
  add_index "followers", ["lovedone_id"], name: "index_followers_on_lovedone_id", using: :btree
  add_index "followers", ["user_id"], name: "index_followers_on_user_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.integer  "lovedone_id", limit: 4
    t.string   "email",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.decimal  "amount",                      precision: 10
    t.text     "ids",           limit: 65535
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "message_count", limit: 4
    t.integer  "sponsor_id",    limit: 4
  end

  create_table "late_notice_notifications", force: :cascade do |t|
    t.integer  "company_id",     limit: 4
    t.string   "contact_method", limit: 255
    t.string   "email",          limit: 255
    t.string   "phone_number",   limit: 255
    t.boolean  "system_status",              default: false
    t.float    "time_threshold", limit: 24,  default: 15.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leads", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "email",        limit: 255
    t.integer  "profile_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number", limit: 255
  end

  add_index "leads", ["profile_id"], name: "index_leads_on_profile_id", using: :btree

  create_table "lovedone_imports", force: :cascade do |t|
    t.integer  "company_id",    limit: 4
    t.string   "first_name",    limit: 255
    t.string   "last_name",     limit: 255
    t.string   "gender",        limit: 255
    t.date     "date_of_birth"
    t.string   "phone_number",  limit: 255
    t.string   "apt_unit",      limit: 255
    t.string   "street",        limit: 255
    t.string   "state",         limit: 255
    t.string   "county",        limit: 255
    t.string   "city",          limit: 255
    t.string   "zip_code",      limit: 255
    t.string   "email",         limit: 255
    t.integer  "status",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lovedones", force: :cascade do |t|
    t.string   "last_name",          limit: 255
    t.string   "first_name",         limit: 255
    t.string   "middle_initial",     limit: 255
    t.string   "nick_name",          limit: 255
    t.date     "date_of_birth"
    t.string   "gender",             limit: 255
    t.string   "city",               limit: 255
    t.string   "country",            limit: 255
    t.string   "state",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "primary_contact_id", limit: 4
    t.string   "zip_code",           limit: 255
    t.string   "county",             limit: 255
    t.integer  "employee_id",        limit: 4
    t.boolean  "csv_imported",                   default: false
    t.float    "latitude",           limit: 24
    t.float    "longitude",          limit: 24
    t.string   "apt_unit",           limit: 255
    t.string   "street",             limit: 255
    t.integer  "company_id",         limit: 4
    t.string   "phone_number",       limit: 255
    t.datetime "deleted_at"
    t.datetime "imported_at"
    t.string   "email",              limit: 255
    t.integer  "setting",            limit: 4,   default: 0
  end

  add_index "lovedones", ["company_id"], name: "index_lovedones_on_company_id", using: :btree
  add_index "lovedones", ["deleted_at"], name: "index_lovedones_on_deleted_at", using: :btree

  create_table "monthly_billings", force: :cascade do |t|
    t.integer  "company_id",      limit: 4
    t.integer  "month",           limit: 4
    t.integer  "year",            limit: 4
    t.text     "employee_ids",    limit: 65535
    t.integer  "employees_count", limit: 4
    t.float    "base_fee",        limit: 24
    t.float    "employee_fee",    limit: 24
    t.float    "reach_out_fee",   limit: 24
    t.float    "transfer_fee",    limit: 24
    t.float    "amount_due",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reach_out_count", limit: 4
    t.integer  "transfer_count",  limit: 4
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "employee_id",        limit: 4
    t.integer  "lovedone_id",        limit: 4
    t.string   "status",             limit: 255
    t.string   "notification_type",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "follower_id",        limit: 4
    t.integer  "primary_contact_id", limit: 4
    t.integer  "sponsor_id",         limit: 4
    t.boolean  "invoiced",                       default: false
  end

  add_index "notifications", ["employee_id"], name: "index_notifications_on_employee_id", using: :btree
  add_index "notifications", ["follower_id"], name: "index_notifications_on_follower_id", using: :btree
  add_index "notifications", ["lovedone_id"], name: "index_notifications_on_lovedone_id", using: :btree
  add_index "notifications", ["primary_contact_id"], name: "index_notifications_on_primary_contact_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "last_name",      limit: 255
    t.string   "first_name",     limit: 255
    t.string   "middle_initial", limit: 255
    t.string   "nick_name",      limit: 255
    t.date     "date_of_birth"
    t.string   "gender",         limit: 255
    t.string   "address",        limit: 255
    t.string   "city",           limit: 255
    t.string   "country",        limit: 255
    t.string   "state",          limit: 255
    t.string   "zip",            limit: 255
    t.text     "contact_method", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",        limit: 4
    t.string   "phone_number",   limit: 255
    t.string   "county",         limit: 255
    t.integer  "user_type",      limit: 4,     default: 0
  end

  create_table "schedulers", force: :cascade do |t|
    t.integer  "lovedone_id", limit: 4
    t.integer  "employee_id", limit: 4
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "frequency",   limit: 4
    t.text     "key",         limit: 65535
    t.text     "job_id",      limit: 65535
    t.datetime "late_notice"
    t.datetime "deleted_at"
  end

  add_index "schedulers", ["deleted_at"], name: "index_schedulers_on_deleted_at", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsor_messages", force: :cascade do |t|
    t.integer  "sponsor_id",  limit: 4
    t.integer  "employee_id", limit: 4
    t.integer  "lovedone_id", limit: 4
    t.integer  "company_id",  limit: 4
    t.integer  "follower_id", limit: 4
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsor_types", force: :cascade do |t|
    t.integer  "sponsor_id", limit: 4
    t.string   "type",       limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsors", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.text     "address",                limit: 65535
    t.string   "message",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name",           limit: 255
    t.string   "city",                   limit: 255
    t.string   "state",                  limit: 255
    t.string   "zip",                    limit: 255
    t.string   "phone",                  limit: 255
    t.string   "email",                  limit: 255
    t.string   "mobile_phone_number",    limit: 255
    t.string   "contact_last_name",      limit: 255
    t.string   "contact_first_name",     limit: 255
    t.string   "sponsor_ship_type",      limit: 255
    t.string   "picture_file_name",      limit: 255
    t.string   "picture_content_type",   limit: 255
    t.integer  "picture_file_size",      limit: 8
    t.datetime "picture_updated_at"
    t.boolean  "advertise",                                                    default: false
    t.string   "sponsortype",            limit: 255
    t.string   "county",                 limit: 255
    t.string   "nation",                 limit: 255,                           default: "US"
    t.decimal  "messagefee",                           precision: 8, scale: 2
    t.string   "website",                limit: 255
    t.float    "employee_notice_fee",    limit: 24
    t.float    "transfer_fee",           limit: 24
    t.boolean  "employee_notice_status",                                       default: false
    t.boolean  "transfer_status",                                              default: false
    t.integer  "company_id",             limit: 4
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "tabs", force: :cascade do |t|
    t.text     "name",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timesheets", force: :cascade do |t|
    t.datetime "starttime"
    t.datetime "endtime"
    t.integer  "lovedone_id",     limit: 4
    t.integer  "employee_id",     limit: 4
    t.integer  "company_id",      limit: 4
    t.integer  "provider_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trip_id",         limit: 4
    t.integer  "status",          limit: 4, default: 0
    t.boolean  "encounter_based",           default: false
  end

  add_index "timesheets", ["company_id"], name: "index_timesheets_on_company_id", using: :btree
  add_index "timesheets", ["employee_id"], name: "index_timesheets_on_employee_id", using: :btree
  add_index "timesheets", ["lovedone_id"], name: "index_timesheets_on_lovedone_id", using: :btree
  add_index "timesheets", ["provider_id"], name: "index_timesheets_on_provider_id", using: :btree

  create_table "travel_logs", force: :cascade do |t|
    t.float    "latitude",    limit: 24
    t.float    "longitude",   limit: 24
    t.integer  "employee_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trips", force: :cascade do |t|
    t.integer  "employee_id",                limit: 4
    t.integer  "lovedone_id",                limit: 4
    t.string   "status",                     limit: 255
    t.string   "state",                      limit: 255
    t.float    "end_latitude",               limit: 24
    t.float    "end_longitude",              limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "address",                    limit: 65535
    t.integer  "count",                      limit: 4,     default: 0
    t.string   "operation_mode",             limit: 255
    t.float    "start_latitude",             limit: 24
    t.float    "start_longitude",            limit: 24
    t.datetime "distance_notification"
    t.datetime "time_notification"
    t.datetime "recurring_notification"
    t.datetime "early_arrival_notification"
    t.boolean  "notification_response",                    default: false
    t.boolean  "inside_zone",                              default: false
    t.text     "remote_id",                  limit: 65535
    t.float    "travel_time",                limit: 24
    t.float    "travel_distance",            limit: 24
    t.float    "lb_travel_distance",         limit: 24
    t.float    "lb_travel_time",             limit: 24
    t.boolean  "base_to_first",                            default: false
  end

  add_index "trips", ["employee_id"], name: "index_trips_on_employee_id", using: :btree
  add_index "trips", ["lovedone_id"], name: "index_trips_on_lovedone_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "",    null: false
    t.string   "encrypted_password",     limit: 255,   default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "role",                   limit: 4
    t.integer  "selected_page",          limit: 4
    t.datetime "last_sign_out_at"
    t.text     "existing_password",      limit: 65535
    t.integer  "company_id",             limit: 4
    t.boolean  "admin",                                default: false
    t.string   "username",               limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "zone_notifications", force: :cascade do |t|
    t.integer  "company_id",           limit: 4
    t.string   "contact_method",       limit: 255
    t.string   "email",                limit: 255
    t.string   "phone_number",         limit: 255
    t.float    "distance_threshold",   limit: 24,  default: 0.5
    t.float    "time_threshold",       limit: 24,  default: 3.0
    t.float    "recurring_threshold",  limit: 24,  default: 30.0
    t.boolean  "system_status",                    default: true
    t.boolean  "early_arrival_status",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
