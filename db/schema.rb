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

ActiveRecord::Schema.define(:version => 20130310182337) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
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
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "api_keys", :force => true do |t|
    t.string   "description"
    t.string   "key"
    t.integer  "calls_count", :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "authentications", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "auth_token"
    t.string   "auth_secret"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "supercategory_id"
    t.string   "group"
    t.string   "slug"
    t.boolean  "is_route"
    t.text     "description"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "foursquare_id"
    t.string   "foursquare_icon"
    t.string   "name_eu"
    t.string   "name_en"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_update_at"
  end

  add_index "categories", ["supercategory_id"], :name => "index_categories_on_supercategory_id"

  create_table "category_foursquares", :force => true do |t|
    t.string   "name"
    t.string   "name_en"
    t.string   "pluralName"
    t.string   "shortName"
    t.string   "foursquare_id"
    t.string   "foursquare_icon"
    t.integer  "supercategory_foursquare_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "category_minubes", :force => true do |t|
    t.integer  "supercategory_minube_id"
    t.string   "name"
    t.string   "group"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "category_minubes", ["supercategory_minube_id"], :name => "index_category_minubes_on_supercategory_minube_id"

  create_table "category_relations", :force => true do |t|
    t.integer  "minube_id"
    t.string   "foursquare_id"
    t.integer  "my_category_id"
    t.string   "type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "minube_id"
    t.string   "slug"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_upload_at"
    t.string   "name_eu"
  end

  add_index "cities", ["country_id"], :name => "index_cities_on_country_id"

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.integer  "poi_id"
    t.integer  "user_id"
    t.integer  "package_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["package_id"], :name => "index_comments_on_package_id"
  add_index "comments", ["poi_id"], :name => "index_comments_on_poi_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "countries", :force => true do |t|
    t.integer  "minube_id"
    t.string   "name"
    t.integer  "pois_count"
    t.integer  "full_count"
    t.integer  "see_count"
    t.integer  "restaurant_count"
    t.integer  "blog_count"
    t.integer  "hotel_count"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "picture"
    t.string   "url"
    t.integer  "category_id"
    t.string   "supercategory"
    t.string   "references"
    t.integer  "poi_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.time     "start_time"
    t.decimal  "price"
    t.integer  "provider_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "city_id"
    t.decimal  "latitude",       :precision => 16, :scale => 8
    t.decimal  "longitude",      :precision => 16, :scale => 8
    t.string   "name_eu"
    t.text     "description_eu"
  end

  add_index "events", ["category_id"], :name => "index_events_on_category_id"
  add_index "events", ["poi_id"], :name => "index_events_on_poi_id"
  add_index "events", ["provider_id"], :name => "index_events_on_provider_id"

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "likes", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "facebook_id"
    t.datetime "created_time"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "packages", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price"
    t.integer  "category_id"
    t.integer  "supercategory_id"
    t.integer  "user_id"
    t.integer  "provider_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_update_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "type_leisure_id"
    t.integer  "type_time_id"
    t.integer  "type_vehicle_id"
  end

  add_index "packages", ["category_id"], :name => "index_packages_on_category_id"
  add_index "packages", ["provider_id"], :name => "index_packages_on_provider_id"
  add_index "packages", ["supercategory_id"], :name => "index_packages_on_supercategory_id"
  add_index "packages", ["user_id"], :name => "index_packages_on_user_id"

  create_table "photos", :force => true do |t|
    t.integer  "poi_id"
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "is_visible_on_index"
    t.string   "title"
    t.string   "subtitle"
    t.string   "title_eu"
    t.string   "subtitle_eu"
    t.string   "minube_url"
    t.integer  "sequence",            :default => 0
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "foursquare_url"
  end

  add_index "photos", ["poi_id"], :name => "index_photos_on_poi_id"
  add_index "photos", ["user_id"], :name => "index_photos_on_user_id"

  create_table "pois", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "latitude",          :precision => 16, :scale => 8
    t.decimal  "longitude",         :precision => 16, :scale => 8
    t.integer  "user_id"
    t.integer  "ratings_count",                                    :default => 0
    t.decimal  "rating",            :precision => 3,  :scale => 1, :default => 0.0
    t.string   "slug"
    t.string   "address"
    t.string   "telephone"
    t.string   "website"
    t.string   "minube_url"
    t.string   "minube_id"
    t.integer  "city_id"
    t.integer  "category_id"
    t.integer  "supercategory_id"
    t.string   "name_eu"
    t.text     "description_eu"
    t.text     "timetable"
    t.string   "picture_nomral"
    t.string   "picture_thumbnail"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.string   "foursquare_id"
    t.string   "foursquare_url"
    t.integer  "checkins_count"
    t.integer  "users_count"
    t.string   "tip_count"
    t.integer  "likes_count"
  end

  add_index "pois", ["category_id"], :name => "index_pois_on_category_id"
  add_index "pois", ["city_id"], :name => "index_pois_on_city_id"
  add_index "pois", ["supercategory_id"], :name => "index_pois_on_supercategory_id"
  add_index "pois", ["user_id"], :name => "index_pois_on_user_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.text     "about_me"
    t.text     "i_like"
    t.text     "i_dont_like"
    t.boolean  "is_married"
    t.boolean  "has_sons"
    t.string   "restrictions"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.time     "image_update_at"
    t.integer  "foloclore"
    t.string   "integer"
    t.date     "born_date"
    t.integer  "leisure"
    t.integer  "gastronomy"
    t.integer  "ferias"
    t.integer  "folclore"
    t.integer  "sport"
    t.integer  "nature"
    t.integer  "culture"
    t.integer  "other"
    t.integer  "buildings"
    t.integer  "friends"
    t.integer  "events"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "providers", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "city_id"
    t.integer  "category_id"
    t.integer  "supercategory_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.time     "image_update_at"
  end

  add_index "providers", ["category_id"], :name => "index_providers_on_category_id"
  add_index "providers", ["city_id"], :name => "index_providers_on_city_id"
  add_index "providers", ["supercategory_id"], :name => "index_providers_on_supercategory_id"

  create_table "ratings", :force => true do |t|
    t.integer  "poi_id"
    t.integer  "user_id"
    t.integer  "package_id"
    t.string   "ip"
    t.decimal  "rating",     :precision => 3, :scale => 1
    t.text     "comment"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "ratings", ["poi_id"], :name => "index_ratings_on_poi_id"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "route_infos", :force => true do |t|
    t.integer  "poi_id"
    t.decimal  "n_bound",                :precision => 16, :scale => 8
    t.decimal  "s_bound",                :precision => 16, :scale => 8
    t.decimal  "e_bound",                :precision => 16, :scale => 8
    t.decimal  "w_bound",                :precision => 16, :scale => 8
    t.decimal  "length",                 :precision => 8,  :scale => 2
    t.string   "difficulty"
    t.decimal  "max_elevation",          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "min_elevation",          :precision => 6,  :scale => 2, :default => 0.0
    t.decimal  "max_up_slope",           :precision => 8,  :scale => 6, :default => 0.0
    t.decimal  "max_down_slope",         :precision => 8,  :scale => 6, :default => 0.0
    t.decimal  "accomulated_up_slope",   :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "accomulated_down_slope", :precision => 10, :scale => 4, :default => 0.0
    t.boolean  "is_circular",                                           :default => false
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
  end

  create_table "route_points", :force => true do |t|
    t.integer  "poi_id"
    t.decimal  "latitude",   :precision => 16, :scale => 8
    t.decimal  "longitude",  :precision => 16, :scale => 8
    t.decimal  "elevation",  :precision => 6,  :scale => 2, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "route_points", ["poi_id"], :name => "index_route_points_on_poi_id"

  create_table "subcategory_foursquares", :force => true do |t|
    t.string   "name"
    t.string   "name_en"
    t.string   "pluralName"
    t.string   "shortName"
    t.string   "foursquare_id"
    t.string   "foursquare_icon"
    t.integer  "category_foursquare_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "supercategories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_update_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "foursquare_id"
    t.string   "foursquare_icon"
    t.string   "name_eu"
    t.string   "name_en"
  end

  create_table "supercategory_foursquares", :force => true do |t|
    t.string   "name"
    t.string   "name_en"
    t.string   "pluralName"
    t.string   "shortName"
    t.string   "foursquare_id"
    t.string   "foursquare_icon"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "supercategory_minubes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "type_leisures", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "type_times", :force => true do |t|
    t.string   "name"
    t.time     "time_from"
    t.time     "to_time"
    t.datetime "date"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "type_vehicles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
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
  end

  add_index "users", ["city_id"], :name => "index_users_on_city_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
