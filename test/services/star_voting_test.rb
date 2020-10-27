require "test_helper"
require_relative "../../app/services/star_voting"

class StarVotingTest < ActiveSupport::TestCase
  test "Existing Result Short-Circuit" do
    StarVotingResult
    .create(
      resource_model_name: "ProblemResponse",
      workshop_id: 1,
      round_1_runner_up_resource_id: 1,
      round_1_runner_up_tally: 5,
      round_1_winner_resource_id: 2,
      round_1_winner_tally: 10,
      runoff_runner_up_resource_id: 1,
      runoff_runner_up_tally: 5,
      runoff_winner_resource_id: 2,
      runoff_winner_tally: 10
    )

    star_voting = StarVoting.new(1, "ProblemResponse")

    star_voting_results = star_voting.calculate_votes

    assert_equal(
      "Hello World 2",
      star_voting_results[:round_1_winner][:resource].response_text
    )

    assert_equal(
      10,
      star_voting_results[:round_1_winner][:tally]
    )
  end

  test "Standard Vote with Runoff" do
    star_voting = StarVoting.new(2, "ProblemResponse")

    star_voting_results = star_voting.calculate_votes

    assert_equal(
      1,
      star_voting_results[:round_1_winner][:resource].id
    )

    assert_equal(
      10,
      star_voting_results[:round_1_winner][:tally]
    )

    assert_equal(
      1,
      star_voting_results[:runoff_winner][:resource].id
    )

    assert_equal(
      12,
      star_voting_results[:runoff_winner][:tally]
    )

    assert_equal(
      0,
      star_voting_results[:runoff_runner_up][:tally]
    )
  end

  test "Standard Vote with Different Support Levels" do
    star_voting = StarVoting.new(3, "ProblemResponse")

    star_voting_results = star_voting.calculate_votes

    assert_equal(
      2,
      star_voting_results[:round_1_winner][:resource].id
    )

    assert_equal(
      8,
      star_voting_results[:round_1_winner][:tally]
    )

    assert_equal(
      2,
      star_voting_results[:runoff_winner][:resource].id
    )

    assert_equal(
      13,
      star_voting_results[:runoff_winner][:tally]
    )

    assert_equal(
      0,
      star_voting_results[:runoff_runner_up][:tally]
    )
  end

  test "Only one vote submitted should prevent round 1" do
    star_voting = StarVoting.new(4, "ProblemResponse")

    star_voting_results = star_voting.calculate_votes

    assert_nil(star_voting_results[:round_1_winner])

    assert_equal(1, star_voting_results[:runoff_winner][:resource].id)

    assert_equal(3, star_voting_results[:runoff_winner][:tally])
  end

  test "No votes should run catch all" do
    star_voting = StarVoting.new(10, "ProblemResponse")

    star_voting_results = star_voting.calculate_votes

    assert_nil(star_voting_results[:round_1_winner])

    assert_nil(star_voting_results[:runoff_winner])
  end
end
