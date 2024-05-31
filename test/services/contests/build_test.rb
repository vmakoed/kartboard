require 'test_helper'

module Contests
  class BuildTest < ActiveSupport::TestCase
    K_FACTOR = 32
    SCALING_FACTOR = 400.0

    setup do
      @user1 = users(:alice)
      @user2 = users(:bob)
      @contest_params = {
        "contestants_attributes" => {
          "0" => { user_id: @user1.id, place: "1" },
          "1" => { user_id: @user2.id, place: "2" }
        }
      }
    end

    test 'correctly builds a contest with contestants' do
      contest = Contests::Build.call(contest_params: @contest_params)
      users = contest.contestants.map(&:user)

      assert_equal 2, contest.contestants.size
      assert_includes users, @user1
      assert_includes users, @user2
    end

    test 'calculates score logs correctly' do
      contest = Contests::Build.call(contest_params: @contest_params)

      assert_equal contest.contestants[0].user.score, 1031
      assert_equal contest.contestants[1].user.score, 969
      assert_equal contest.contestants[0].place, 1
      assert_equal contest.contestants[1].place, 2
      assert_equal contest.contestants[0].score_log.previous_score, 1016
      assert_equal contest.contestants[0].score_log.new_score, 1031
      assert_equal contest.contestants[0].score_log.score_difference, 15
      assert_equal contest.contestants[1].score_log.previous_score, 984
      assert_equal contest.contestants[1].score_log.new_score, 969
      assert_equal contest.contestants[1].score_log.score_difference, -15
      assert_equal contest.contestants[0].score_log.previous_position, 1
      assert_equal contest.contestants[0].score_log.new_position, 1
      assert_equal contest.contestants[0].score_log.position_difference, 0
      assert_equal contest.contestants[1].score_log.previous_position, 2
      assert_equal contest.contestants[1].score_log.new_position, 2
      assert_equal contest.contestants[1].score_log.position_difference, 0
    end
  end
end
