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

  create_table "access_settings", force: true do |t|
    t.integer  "user_id"
    t.integer  "tab_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activities", force: true do |t|
    t.integer  "employee_id"
    t.boolean  "shift_started",   default: false
    t.boolean  "shift_completed", default: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "appointment_transfers", force: true do |t|
    t.text     "ids"
    t.integer  "transfer_count"
    t.datetime "transfer_date"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "person"
    t.integer  "transfer_type"
    t.integer  "person_id"
    t.text     "document"
  end

  create_table "audits", force: true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "companies", force: true do |t|
    t.string   "company_name"
    t.string   "business_name"
    t.string   "provider_type"
    t.string   "telephone"
    t.string   "mobile_phone_number"
    t.boolean  "get_notification",                default: false
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "state"
    t.string   "zip"
    t.string   "contact_last_name"
    t.string   "contact_first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",                          default: "pending"
    t.string   "email"
    t.string   "county"
    t.string   "contact_method"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "featured",                        default: false
    t.float    "latitude",             limit: 53, default: 0.0
    t.float    "longitude",            limit: 53, default: 0.0
    t.boolean  "notification_masking",            default: false
    t.boolean  "lovedone_masking",                default: false
    t.string   "time_zone"
    t.float    "abbreviated_time",     limit: 24, default: 15.0
    t.integer  "employee_spoke"
    t.integer  "lovedone_spoke"
  end

  create_table "company_members", force: true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.boolean  "admin",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_message_employees", force: true do |t|
    t.integer  "company_message_id"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_messages", force: true do |t|
    t.integer  "company_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "designations", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.string   "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "designations", ["deleted_at"], name: "index_designations_on_deleted_at", using: :btree

  create_table "emails", force: true do |t|
    t.string   "email"
    t.integer  "emailable_id"
    t.string   "emailable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_company_categories", force: true do |t|
    t.integer  "employee_id"
    t.integer  "company_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_imports", force: true do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "address"
    t.string   "state"
    t.string   "county"
    t.string   "city"
    t.string   "zip"
    t.string   "email"
    t.string   "username"
    t.string   "password"
    t.string   "designation_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_lovedones", force: true do |t|
    t.integer  "employee_id"
    t.integer  "lovedone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.float    "latitude",       limit: 53,                         default: 0.0
    t.float    "longitude",      limit: 53,                         default: 0.0
    t.integer  "company_id"
    t.integer  "lovedone_id"
    t.string   "name_no_use"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service_status"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "designation_id"
    t.decimal  "distance",                  precision: 8, scale: 2, default: 0.0
    t.string   "phone_number"
    t.string   "address"
    t.string   "state"
    t.string   "county"
    t.string   "city"
    t.string   "zip"
    t.float    "base_latitude",  limit: 24
    t.float    "base_longitude", limit: 24
    t.string   "device_type"
    t.text     "device_id"
    t.string   "email"
    t.datetime "deleted_at"
    t.integer  "setting",                                           default: 0
    t.integer  "user_id"
  end

  add_index "employees", ["company_id"], name: "index_employees_on_company_id", using: :btree
  add_index "employees", ["deleted_at"], name: "index_employees_on_deleted_at", using: :btree
  add_index "employees", ["lovedone_id"], name: "index_employees_on_lovedone_id", using: :btree

  create_table "family_members", force: true do |t|
    t.string   "lastname"
    t.string   "firstname"
    t.string   "email"
    t.string   "mobilephone"
    t.string   "contact"
    t.integer  "city"
    t.integer  "county"
    t.integer  "state"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fees", force: true do |t|
    t.integer  "company_id"
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

  create_table "followers", force: true do |t|
    t.integer  "user_id"
    t.integer  "lovedone_id"
    t.string   "request_status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.text     "contact_method"
    t.datetime "deleted_at"
    t.string   "apt_unit"
    t.string   "street"
    t.string   "city"
    t.string   "county"
    t.string   "state"
    t.string   "zip_code"
    t.integer  "setting",                default: 0
    t.integer  "contact_method_setting", default: 0
  end

  add_index "followers", ["deleted_at"], name: "index_followers_on_deleted_at", using: :btree
  add_index "followers", ["lovedone_id"], name: "index_followers_on_lovedone_id", using: :btree
  add_index "followers", ["user_id"], name: "index_followers_on_user_id", using: :btree

  create_table "invitations", force: true do |t|
    t.integer  "lovedone_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.string   "title"
    t.decimal  "amount",        precision: 10, scale: 0
    t.text     "ids"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "message_count"
    t.integer  "sponsor_id"
  end

  create_table "late_notice_notifications", force: true do |t|
    t.integer  "company_id"
    t.string   "contact_method"
    t.string   "email"
    t.string   "phone_number"
    t.boolean  "system_status",             default: false
    t.float    "time_threshold", limit: 24, default: 15.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leads", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
  end

  add_index "leads", ["profile_id"], name: "index_leads_on_profile_id", using: :btree

  create_table "lovedone_imports", force: true do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "date_of_birth"
    t.string   "phone_number"
    t.string   "apt_unit"
    t.string   "street"
    t.string   "state"
    t.string   "county"
    t.string   "city"
    t.string   "zip_code"
    t.string   "email"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lovedones", force: true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "middle_initial"
    t.string   "nick_name"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "city"
    t.string   "country"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "primary_contact_id"
    t.string   "zip_code"
    t.string   "county"
    t.integer  "employee_id"
    t.boolean  "csv_imported",                  default: false
    t.float    "latitude",           limit: 24
    t.float    "longitude",          limit: 24
    t.string   "apt_unit"
    t.string   "street"
    t.integer  "company_id"
    t.string   "phone_number"
    t.datetime "deleted_at"
    t.datetime "imported_at"
    t.string   "email"
    t.integer  "setting",                       default: 0
  end

  add_index "lovedones", ["company_id"], name: "index_lovedones_on_company_id", using: :btree
  add_index "lovedones", ["deleted_at"], name: "index_lovedones_on_deleted_at", using: :btree

  create_table "monthly_billings", force: true do |t|
    t.integer  "company_id"
    t.integer  "month"
    t.integer  "year"
    t.text     "employee_ids"
    t.integer  "employees_count"
    t.float    "base_fee",        limit: 24
    t.float    "employee_fee",    limit: 24
    t.float    "reach_out_fee",   limit: 24
    t.float    "transfer_fee",    limit: 24
    t.float    "amount_due",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reach_out_count"
    t.integer  "transfer_count"
  end

  create_table "notifications", force: true do |t|
    t.integer  "employee_id"
    t.integer  "lovedone_id"
    t.string   "status"
    t.string   "notification_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "follower_id"
    t.integer  "primary_contact_id"
    t.integer  "sponsor_id"
    t.boolean  "invoiced",           default: false
  end

  add_index "notifications", ["employee_id"], name: "index_notifications_on_employee_id", using: :btree
  add_index "notifications", ["follower_id"], name: "index_notifications_on_follower_id", using: :btree
  add_index "notifications", ["lovedone_id"], name: "index_notifications_on_lovedone_id", using: :btree
  add_index "notifications", ["primary_contact_id"], name: "index_notifications_on_primary_contact_id", using: :btree

  create_table "profiles", force: true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "middle_initial"
    t.string   "nick_name"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "state"
    t.string   "zip"
    t.text     "contact_method"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "phone_number"
    t.string   "county"
    t.integer  "user_type",      default: 0
  end

  create_table "schedulers", force: true do |t|
    t.integer  "lovedone_id"
    t.integer  "employee_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "frequency"
    t.text     "key"
    t.text     "job_id"
    t.datetime "late_notice"
    t.datetime "deleted_at"
  end

  add_index "schedulers", ["deleted_at"], name: "index_schedulers_on_deleted_at", using: :btree

  create_table "settings", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsor_messages", force: true do |t|
    t.integer  "sponsor_id"
    t.integer  "employee_id"
    t.integer  "lovedone_id"
    t.integer  "company_id"
    t.integer  "follower_id"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsor_types", force: true do |t|
    t.integer  "sponsor_id"
    t.string   "type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsors", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "email"
    t.string   "mobile_phone_number"
    t.string   "contact_last_name"
    t.string   "contact_first_name"
    t.string   "sponsor_ship_type"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "advertise",                                                 default: false
    t.string   "sponsortype"
    t.string   "county"
    t.string   "nation",                                                    default: "US"
    t.decimal  "messagefee",                        precision: 8, scale: 2
    t.string   "website"
    t.float    "employee_notice_fee",    limit: 24
    t.float    "transfer_fee",           limit: 24
    t.boolean  "employee_notice_status",                                    default: false
    t.boolean  "transfer_status",                                           default: false
    t.integer  "company_id"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "tabs", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timesheets", force: true do |t|
    t.datetime "starttime"
    t.datetime "endtime"
    t.integer  "lovedone_id"
    t.integer  "employee_id"
    t.integer  "company_id"
    t.integer  "provider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trip_id"
    t.integer  "status",          default: 0
    t.boolean  "encounter_based", default: false
  end

  add_index "timesheets", ["company_id"], name: "index_timesheets_on_company_id", using: :btree
  add_index "timesheets", ["employee_id"], name: "index_timesheets_on_employee_id", using: :btree
  add_index "timesheets", ["lovedone_id"], name: "index_timesheets_on_lovedone_id", using: :btree
  add_index "timesheets", ["provider_id"], name: "index_timesheets_on_provider_id", using: :btree

  create_table "travel_logs", force: true do |t|
    t.float    "latitude",    limit: 24
    t.float    "longitude",   limit: 24
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trips", force: true do |t|
    t.integer  "employee_id"
    t.integer  "lovedone_id"
    t.string   "status"
    t.string   "state"
    t.float    "end_latitude",               limit: 24
    t.float    "end_longitude",              limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "address"
    t.integer  "count",                                 default: 0
    t.string   "operation_mode"
    t.float    "start_latitude",             limit: 24
    t.float    "start_longitude",            limit: 24
    t.datetime "distance_notification"
    t.datetime "time_notification"
    t.datetime "recurring_notification"
    t.datetime "early_arrival_notification"
    t.boolean  "notification_response",                 default: false
    t.boolean  "inside_zone",                           default: false
    t.text     "remote_id"
    t.float    "travel_time",                limit: 24
    t.float    "travel_distance",            limit: 24
    t.float    "lb_travel_distance",         limit: 24
    t.float    "lb_travel_time",             limit: 24
    t.boolean  "base_to_first",                         default: false
  end

  add_index "trips", ["employee_id"], name: "index_trips_on_employee_id", using: :btree
  add_index "trips", ["lovedone_id"], name: "index_trips_on_lovedone_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
    t.integer  "selected_page"
    t.datetime "last_sign_out_at"
    t.text     "existing_password"
    t.integer  "company_id"
    t.boolean  "admin",                  default: false
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "zone_notifications", force: true do |t|
    t.integer  "company_id"
    t.string   "contact_method"
    t.string   "email"
    t.string   "phone_number"
    t.float    "distance_threshold",   limit: 24, default: 0.5
    t.float    "time_threshold",       limit: 24, default: 3.0
    t.float    "recurring_threshold",  limit: 24, default: 30.0
    t.boolean  "system_status",                   default: true
    t.boolean  "early_arrival_status",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
