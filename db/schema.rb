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

ActiveRecord::Schema.define(version: 20130415154716) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.string   "content",                  null: false
    t.integer  "question_id",              null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "comments", force: true do |t|
    t.text     "comment",                      null: false
    t.integer  "user_id",                      null: false
    t.integer  "commentable_id",               null: false
    t.integer  "lock_version",     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "commentable_type",             null: false
    t.integer  "votes_count",      default: 0, null: false
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "contents", force: true do |t|
    t.string   "title",                    null: false
    t.text     "content"
    t.integer  "teach_id",                 null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["teach_id"], name: "index_contents_on_teach_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "name"
    t.integer  "lock_version", default: 0, null: false
    t.integer  "grade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["grade_id"], name: "index_courses_on_grade_id", using: :btree

  create_table "districts", force: true do |t|
    t.string   "name",                     null: false
    t.integer  "lock_version", default: 0, null: false
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "districts", ["name"], name: "index_districts_on_name", using: :btree
  add_index "districts", ["region_id"], name: "index_districts_on_region_id", using: :btree

  create_table "documents", force: true do |t|
    t.string   "name",                     null: false
    t.string   "file",                     null: false
    t.string   "content_type",             null: false
    t.string   "file_size",                null: false
    t.integer  "owner_id",                 null: false
    t.string   "owner_type",               null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["created_at"], name: "index_documents_on_created_at", using: :btree
  add_index "documents", ["owner_id", "owner_type"], name: "index_documents_on_owner_id_and_owner_type", using: :btree

  create_table "enrollments", force: true do |t|
    t.integer  "teach_id",                         null: false
    t.integer  "enrollable_id",                    null: false
    t.string   "job",                              null: false
    t.integer  "lock_version",    default: 0,      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "enrollable_type", default: "User"
  end

  add_index "enrollments", ["enrollable_id", "enrollable_type"], name: "index_enrollments_on_enrollable_id_and_enrollable_type", using: :btree
  add_index "enrollments", ["teach_id"], name: "index_enrollments_on_teach_id", using: :btree

  create_table "forums", force: true do |t|
    t.string   "name",                       null: false
    t.text     "topic",                      null: false
    t.integer  "user_id",                    null: false
    t.integer  "owner_id",                   null: false
    t.string   "owner_type",                 null: false
    t.integer  "lock_version",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "info"
    t.integer  "comments_count", default: 0, null: false
  end

  add_index "forums", ["name"], name: "index_forums_on_name", using: :btree
  add_index "forums", ["owner_id", "owner_type"], name: "index_forums_on_owner_id_and_owner_type", using: :btree
  add_index "forums", ["user_id"], name: "index_forums_on_user_id", using: :btree

  create_table "grades", force: true do |t|
    t.string   "name",                       null: false
    t.integer  "lock_version",   default: 0, null: false
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grades", ["institution_id"], name: "index_grades_on_institution_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name",                       null: false
    t.integer  "institution_id",             null: false
    t.integer  "lock_version",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["institution_id"], name: "index_groups_on_institution_id", using: :btree
  add_index "groups", ["name"], name: "index_groups_on_name", using: :btree

  create_table "homeworks", force: true do |t|
    t.string   "name",                     null: false
    t.text     "description"
    t.date     "closing_at"
    t.integer  "content_id",               null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "homeworks", ["closing_at"], name: "index_homeworks_on_closing_at", using: :btree
  add_index "homeworks", ["content_id"], name: "index_homeworks_on_content_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "name",                       null: false
    t.string   "file",                       null: false
    t.string   "content_type",               null: false
    t.integer  "file_size",                  null: false
    t.integer  "institution_id",             null: false
    t.integer  "lock_version",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "images", ["institution_id"], name: "index_images_on_institution_id", using: :btree
  add_index "images", ["owner_id", "owner_type"], name: "index_images_on_owner_id_and_owner_type", using: :btree

  create_table "institutions", force: true do |t|
    t.string   "name",                       null: false
    t.string   "identification"
    t.integer  "lock_version",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "district_id"
  end

  add_index "institutions", ["district_id"], name: "index_institutions_on_district_id", using: :btree
  add_index "institutions", ["identification"], name: "index_institutions_on_identification", unique: true, using: :btree
  add_index "institutions", ["name"], name: "index_institutions_on_name", using: :btree

  create_table "jobs", force: true do |t|
    t.string   "job",                           null: false
    t.integer  "lock_version",   default: 0,    null: false
    t.integer  "user_id"
    t.integer  "institution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.boolean  "active",         default: true, null: false
  end

  add_index "jobs", ["institution_id"], name: "index_jobs_on_institution_id", using: :btree
  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id", using: :btree

  create_table "kinships", force: true do |t|
    t.string   "kin"
    t.integer  "lock_version", default: 0, null: false
    t.integer  "user_id"
    t.integer  "relative_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kinships", ["kin"], name: "index_kinships_on_kin", using: :btree
  add_index "kinships", ["relative_id"], name: "index_kinships_on_relative_id", using: :btree
  add_index "kinships", ["user_id"], name: "index_kinships_on_user_id", using: :btree

  create_table "logins", force: true do |t|
    t.string   "ip",         null: false
    t.text     "user_agent"
    t.datetime "created_at", null: false
    t.integer  "user_id",    null: false
  end

  add_index "logins", ["user_id"], name: "index_logins_on_user_id", using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "group_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "news", force: true do |t|
    t.string   "title",                      null: false
    t.text     "description"
    t.text     "body"
    t.integer  "comments_count", default: 0, null: false
    t.integer  "lock_version",   default: 0, null: false
    t.integer  "institution_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at",               null: false
    t.integer  "votes_count",    default: 0, null: false
  end

  add_index "news", ["institution_id"], name: "index_news_on_institution_id", using: :btree
  add_index "news", ["published_at"], name: "index_news_on_published_at", using: :btree
  add_index "news", ["title"], name: "index_news_on_title", using: :btree

  create_table "presentations", force: true do |t|
    t.string   "file",                       null: false
    t.string   "content_type",               null: false
    t.integer  "file_size",                  null: false
    t.integer  "user_id",                    null: false
    t.integer  "homework_id",                null: false
    t.integer  "lock_version",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count", default: 0, null: false
  end

  add_index "presentations", ["homework_id"], name: "index_presentations_on_homework_id", using: :btree
  add_index "presentations", ["user_id"], name: "index_presentations_on_user_id", using: :btree

  create_table "questions", force: true do |t|
    t.string   "content",                                   null: false
    t.integer  "survey_id",                                 null: false
    t.integer  "lock_version",  default: 0,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "question_type", default: "multiple_choice", null: false
    t.boolean  "required",      default: false,             null: false
    t.text     "hint"
  end

  add_index "questions", ["survey_id"], name: "index_questions_on_survey_id", using: :btree

  create_table "regions", force: true do |t|
    t.string   "name",                     null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regions", ["name"], name: "index_regions_on_name", unique: true, using: :btree

  create_table "replies", force: true do |t|
    t.integer  "question_id",                null: false
    t.integer  "answer_id"
    t.integer  "user_id",                    null: false
    t.datetime "created_at",                 null: false
    t.text     "response"
    t.integer  "comments_count", default: 0, null: false
  end

  add_index "replies", ["answer_id"], name: "index_replies_on_answer_id", using: :btree
  add_index "replies", ["question_id"], name: "index_replies_on_question_id", using: :btree
  add_index "replies", ["user_id"], name: "index_replies_on_user_id", using: :btree

  create_table "scores", force: true do |t|
    t.decimal  "score",        precision: 5, scale: 2
    t.decimal  "multiplier",   precision: 5, scale: 2
    t.string   "description"
    t.integer  "lock_version",                         default: 0, null: false
    t.integer  "teach_id",                                         null: false
    t.integer  "user_id",                                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["teach_id"], name: "index_scores_on_teach_id", using: :btree
  add_index "scores", ["user_id"], name: "index_scores_on_user_id", using: :btree

  create_table "settings", force: true do |t|
    t.string   "name",              null: false
    t.string   "kind",              null: false
    t.text     "value",             null: false
    t.integer  "configurable_id",   null: false
    t.string   "configurable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["configurable_id", "configurable_type"], name: "index_settings_on_configurable_id_and_configurable_type", using: :btree

  create_table "surveys", force: true do |t|
    t.string   "name",                     null: false
    t.integer  "content_id",               null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "surveys", ["content_id"], name: "index_surveys_on_content_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id",        null: false
    t.integer  "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name",                       null: false
    t.string   "category",                   null: false
    t.string   "tagger_type",                null: false
    t.integer  "institution_id",             null: false
    t.integer  "lock_version",   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["institution_id"], name: "index_tags_on_institution_id", using: :btree
  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree
  add_index "tags", ["tagger_type"], name: "index_tags_on_tagger_type", using: :btree

  create_table "teaches", force: true do |t|
    t.date     "start",                    null: false
    t.date     "finish",                   null: false
    t.integer  "lock_version", default: 0, null: false
    t.integer  "course_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "teaches", ["course_id"], name: "index_teaches_on_course_id", using: :btree
  add_index "teaches", ["finish"], name: "index_teaches_on_finish", using: :btree
  add_index "teaches", ["start"], name: "index_teaches_on_start", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                                         null: false
    t.string   "lastname"
    t.string   "email",                           default: "", null: false
    t.string   "encrypted_password",              default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "roles_mask",                      default: 0,  null: false
    t.integer  "lock_version",                    default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
    t.integer  "kinships_in_chart_count",         default: 0,  null: false
    t.integer  "inverse_kinships_in_chart_count", default: 0,  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["lastname"], name: "index_users_on_lastname", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["whodunnit"], name: "index_versions_on_whodunnit", using: :btree

  create_table "visits", force: true do |t|
    t.integer  "user_id",      null: false
    t.integer  "visited_id",   null: false
    t.string   "visited_type", null: false
    t.datetime "created_at",   null: false
  end

  add_index "visits", ["user_id", "visited_id", "visited_type"], name: "index_visits_on_user_id_and_visited_id_and_visited_type", unique: true, using: :btree
  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree
  add_index "visits", ["visited_id", "visited_type"], name: "index_visits_on_visited_id_and_visited_type", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "user_id",                  null: false
    t.integer  "votable_id",               null: false
    t.string   "votable_type",             null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree
  add_index "votes", ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type", using: :btree

end
