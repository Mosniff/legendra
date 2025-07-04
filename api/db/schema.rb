# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_07_04_155557) do
  create_table "castles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "slot"
    t.string "game_state", default: "story_choice", null: false
    t.boolean "active", default: false, null: false
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "generals", force: :cascade do |t|
    t.string "name"
    t.integer "world_id", null: false
    t.integer "kingdom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kingdom_id"], name: "index_generals_on_kingdom_id"
    t.index ["world_id"], name: "index_generals_on_world_id"
  end

  create_table "kingdoms", force: :cascade do |t|
    t.integer "world_id", null: false
    t.string "name"
    t.boolean "is_player_kingdom", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["world_id"], name: "index_kingdoms_on_world_id"
  end

  create_table "locations", force: :cascade do |t|
    t.integer "tile_id", null: false
    t.string "locatable_type", null: false
    t.integer "locatable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["locatable_type", "locatable_id"], name: "index_locations_on_locatable"
    t.index ["tile_id"], name: "index_locations_on_tile_id"
  end

  create_table "maps", force: :cascade do |t|
    t.integer "world_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "height"
    t.integer "width"
    t.index ["world_id"], name: "index_maps_on_world_id"
  end

  create_table "routes", force: :cascade do |t|
    t.integer "location_a_id", null: false
    t.integer "location_b_id", null: false
    t.json "path", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_a_id", "location_b_id"], name: "index_routes_on_location_a_id_and_location_b_id", unique: true
    t.index ["location_a_id"], name: "index_routes_on_location_a_id"
    t.index ["location_b_id"], name: "index_routes_on_location_b_id"
  end

  create_table "scenarios", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.integer "world_id", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "scenario_id", null: false
    t.index ["scenario_id"], name: "index_stories_on_scenario_id"
    t.index ["world_id"], name: "index_stories_on_world_id"
  end

  create_table "tiles", force: :cascade do |t|
    t.integer "map_id", null: false
    t.integer "x_coord"
    t.integer "y_coord"
    t.string "terrain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id"], name: "index_tiles_on_map_id"
  end

  create_table "towns", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "worlds", force: :cascade do |t|
    t.integer "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_worlds_on_game_id", unique: true
  end

  add_foreign_key "games", "users"
  add_foreign_key "generals", "kingdoms"
  add_foreign_key "generals", "worlds"
  add_foreign_key "kingdoms", "worlds"
  add_foreign_key "locations", "tiles"
  add_foreign_key "maps", "worlds"
  add_foreign_key "routes", "locations", column: "location_a_id"
  add_foreign_key "routes", "locations", column: "location_b_id"
  add_foreign_key "stories", "scenarios"
  add_foreign_key "stories", "worlds"
  add_foreign_key "tiles", "maps"
  add_foreign_key "worlds", "games"
end
