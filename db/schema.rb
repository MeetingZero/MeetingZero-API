# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_07_000458) do

  create_table "opportunity_question_responses", force: :cascade do |t|
    t.integer "workshop_id"
    t.integer "user_id"
    t.text "response_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "problem_responses", force: :cascade do |t|
    t.integer "workshop_id"
    t.integer "user_id"
    t.text "response_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reframe_problem_responses", force: :cascade do |t|
    t.integer "workshop_id"
    t.integer "user_id"
    t.text "response_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "solution_response_priorities", force: :cascade do |t|
    t.integer "workshop_id"
    t.integer "user_id"
    t.integer "solution_response_id"
    t.integer "impact_level"
    t.integer "effort_level"
    t.string "assessment_category"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "solution_responses", force: :cascade do |t|
    t.integer "workshop_id"
    t.integer "user_id"
    t.text "response_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "star_voting_results", force: :cascade do |t|
    t.integer "workshop_id"
    t.string "resource_model_name"
    t.integer "round_1_runner_up_resource_id"
    t.integer "round_1_runner_up_tally"
    t.integer "round_1_winner_resource_id"
    t.integer "round_1_winner_tally"
    t.integer "runoff_runner_up_resource_id"
    t.integer "runoff_runner_up_tally"
    t.integer "runoff_winner_resource_id"
    t.integer "runoff_winner_tally"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "star_voting_votes", force: :cascade do |t|
    t.integer "workshop_id"
    t.integer "user_id"
    t.string "resource_model_name"
    t.integer "resource_id"
    t.integer "vote_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password"
    t.string "password_digest"
    t.string "account_activation_token"
    t.string "password_reset_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "what_is_working_responses", force: :cascade do |t|
    t.integer "workshop_id"
    t.integer "user_id"
    t.text "response_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workshop_directors", force: :cascade do |t|
    t.integer "workshop_id"
    t.integer "workshop_stage_id"
    t.integer "workshop_stage_step_id"
    t.boolean "completed", default: false
    t.datetime "workshop_stage_step_start_time"
    t.datetime "workshop_stage_step_expire_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workshop_members", force: :cascade do |t|
    t.integer "workshop_id"
    t.integer "user_id"
    t.string "email"
    t.boolean "online", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workshop_stage_steps", force: :cascade do |t|
    t.integer "workshop_stage_id"
    t.string "key"
    t.string "name"
    t.integer "default_time_limit"
    t.text "description"
    t.boolean "discussion_allowed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workshop_stages", force: :cascade do |t|
    t.string "key"
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workshop_template_stages", force: :cascade do |t|
    t.integer "workshop_template_id"
    t.integer "workshop_stage_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workshop_templates", force: :cascade do |t|
    t.string "key"
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workshops", force: :cascade do |t|
    t.string "workshop_token"
    t.integer "host_id"
    t.text "purpose"
    t.datetime "date_time_planned"
    t.datetime "started_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
