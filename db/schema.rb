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

ActiveRecord::Schema.define(:version => 20110107221623) do

  create_table "players", :force => true do |t|
    t.string   "reddit_name"
    t.string   "game_name"
    t.string   "platform"
    t.string   "clan_tag"
    t.integer  "rank"
    t.string   "rank_name"
    t.integer  "veteren_level"
    t.integer  "score"
    t.integer  "kills"
    t.integer  "deaths"
    t.integer  "time_played"
    t.integer  "skill_level"
    t.datetime "last_update"
    t.datetime "lastcheck"
    t.float    "accuracy"
    t.integer  "dog_tags_taken"
    t.integer  "games_played"
    t.integer  "losses"
    t.integer  "wins"
    t.integer  "assault_score"
    t.integer  "engineer_score"
    t.integer  "support_score"
    t.integer  "recon_score"
    t.integer  "vehicle_score"
    t.integer  "award_score"
    t.integer  "bonus_score"
    t.integer  "general_score"
    t.integer  "objective_score"
    t.integer  "squad_score"
    t.integer  "team_score"
    t.integer  "team_kills"
    t.integer  "score_rank"
    t.datetime "last_online"
    t.string   "last_server_address"
    t.string   "last_server_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
