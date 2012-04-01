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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120331235355) do

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.integer  "lock_version", :default => 0, :null => false
    t.integer  "grade_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "courses", ["grade_id"], :name => "index_courses_on_grade_id"

  create_table "districts", :force => true do |t|
    t.string   "name",                        :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.integer  "region_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "districts", ["name"], :name => "index_districts_on_name"
  add_index "districts", ["region_id"], :name => "index_districts_on_region_id"

  create_table "enrollments", :force => true do |t|
    t.integer  "teach_id",                    :null => false
    t.integer  "user_id",                     :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "enrollments", ["teach_id"], :name => "index_enrollments_on_teach_id"
  add_index "enrollments", ["user_id"], :name => "index_enrollments_on_user_id"

  create_table "grades", :force => true do |t|
    t.string   "name",                        :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.integer  "school_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "grades", ["school_id"], :name => "index_grades_on_school_id"

  create_table "jobs", :force => true do |t|
    t.string   "job",                         :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.integer  "user_id"
    t.integer  "school_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "jobs", ["school_id"], :name => "index_jobs_on_school_id"
  add_index "jobs", ["user_id"], :name => "index_jobs_on_user_id"

  create_table "regions", :force => true do |t|
    t.string   "name",                        :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "regions", ["name"], :name => "index_regions_on_name", :unique => true

  create_table "schools", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "identification"
    t.integer  "lock_version",   :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "district_id"
  end

  add_index "schools", ["district_id"], :name => "index_schools_on_district_id"
  add_index "schools", ["identification"], :name => "index_schools_on_identification", :unique => true
  add_index "schools", ["name"], :name => "index_schools_on_name"

  create_table "teaches", :force => true do |t|
    t.date     "start",                       :null => false
    t.date     "finish",                      :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.integer  "course_id",                   :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "teaches", ["course_id"], :name => "index_teaches_on_course_id"
  add_index "teaches", ["finish"], :name => "index_teaches_on_finish"
  add_index "teaches", ["start"], :name => "index_teaches_on_start"

  create_table "users", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "lastname"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "roles_mask",             :default => 0,  :null => false
    t.integer  "lock_version",           :default => 0,  :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["lastname"], :name => "index_users_on_lastname"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"
  add_index "versions", ["whodunnit"], :name => "index_versions_on_whodunnit"

end
