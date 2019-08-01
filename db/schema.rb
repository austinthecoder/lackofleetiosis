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

ActiveRecord::Schema.define(version: 2019_08_01_200443) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "vehicles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vin", null: false
    t.string "make"
    t.string "model"
    t.integer "year"
    t.string "trim"
    t.string "color"
    t.text "image_url"
    t.integer "status_id", default: 1
    t.integer "fleetio_vehicle_id"
    t.decimal "total_gallons"
    t.decimal "total_miles"
    t.index ["vin"], name: "index_vehicles_on_vin", unique: true
  end

end
