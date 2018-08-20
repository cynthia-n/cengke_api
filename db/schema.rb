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

ActiveRecord::Schema.define(version: 20180820140959) do

  create_table "cards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "chapter_id"
    t.string "title"
    t.text "content"
    t.boolean "is_free"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "like_base_count"
    t.integer "share_base_count"
    t.index ["chapter_id"], name: "index_cards_on_chapter_id"
  end

  create_table "cengkes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.integer "source_user_id"
    t.bigint "card_id"
    t.boolean "is_new_friend"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fail"
    t.string "error"
    t.index ["card_id"], name: "index_cengkes_on_card_id"
    t.index ["source_user_id"], name: "index_cengkes_on_source_user_id"
    t.index ["user_id"], name: "index_cengkes_on_user_id"
  end

  create_table "chapters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "subject_id"
    t.string "title"
    t.decimal "fee", precision: 20, scale: 2
    t.decimal "origin_fee", precision: 20, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_chapters_on_subject_id"
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.string "source_type"
    t.bigint "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_type", "source_id"], name: "index_likes_on_source_type_and_source_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "media", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "card_id"
    t.string "category"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration"
    t.string "ratio54_url"
    t.index ["card_id"], name: "index_media_on_card_id"
  end

  create_table "options", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "question_id"
    t.string "title"
    t.boolean "is_correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "questions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "card_id"
    t.string "title"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_questions_on_card_id"
  end

  create_table "shares", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.string "source_type"
    t.bigint "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_type", "source_id"], name: "index_shares_on_source_type_and_source_id"
    t.index ["user_id"], name: "index_shares_on_user_id"
  end

  create_table "subjects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name", comment: "名称"
    t.string "introduction", comment: "简介"
    t.string "image_url", comment: "图片地址"
    t.string "remark", comment: "备注"
    t.integer "status", comment: "状态"
    t.string "display_size", comment: "展示大小"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "detail"
    t.string "crowd"
    t.decimal "fee", precision: 20, scale: 2
    t.decimal "origin_fee", precision: 20, scale: 2
    t.integer "learning_base_count"
  end

  create_table "user_cards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.bigint "card_id"
    t.integer "status"
    t.datetime "unlock_at"
    t.datetime "start_at"
    t.datetime "finish_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_user_cards_on_card_id"
    t.index ["user_id"], name: "index_user_cards_on_user_id"
  end

  create_table "user_connections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id", comment: "用户ID"
    t.string "platform", comment: "授权平台"
    t.string "unionid", comment: "unionid"
    t.string "openid", comment: "openid"
    t.string "access_token", comment: "授权token"
    t.datetime "last_auth_at", comment: "最后一次授权时间"
    t.text "info", comment: "详细信息"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "scene", comment: "scene"
    t.string "share_ticket", comment: "share_ticket"
    t.index ["user_id"], name: "index_user_connections_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "nickname", comment: "名称"
    t.string "avatar", comment: "头像"
    t.string "wechat_unionid", comment: "微信unionid"
    t.string "token", comment: "token"
    t.datetime "last_sign_in_at", comment: "最后一次登录时间"
    t.string "last_sign_in_ip", comment: "最后一次登录ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "cards", "chapters"
  add_foreign_key "cengkes", "cards"
  add_foreign_key "cengkes", "users"
  add_foreign_key "chapters", "subjects"
  add_foreign_key "likes", "users"
  add_foreign_key "media", "cards"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "cards"
  add_foreign_key "shares", "users"
  add_foreign_key "user_cards", "cards"
  add_foreign_key "user_cards", "users"
  add_foreign_key "user_connections", "users"
end
