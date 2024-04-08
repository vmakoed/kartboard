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

      assert_equal 2, contest.contestants.size
      assert_equal @user1, contest.contestants.first.user
      assert_equal @user2, contest.contestants.second.user
    end

    test 'calculates score logs correctly' do
      contest = Contests::Build.call(contest_params: @contest_params)

      assert_equal contest.contestants[0].user.score, 1017
      assert_equal contest.contestants[1].user.score, 1013
      assert_equal contest.contestants[0].place, 1
      assert_equal contest.contestants[1].place, 2
      assert_equal contest.contestants[0].score_log.previous_score, 1000
      assert_equal contest.contestants[0].score_log.new_score, 1017
      assert_equal contest.contestants[0].score_log.score_difference, 17
      assert_equal contest.contestants[1].score_log.previous_score, 1030
      assert_equal contest.contestants[1].score_log.new_score, 1013
      assert_equal contest.contestants[1].score_log.score_difference, -17
      assert_equal contest.contestants[0].score_log.previous_position, 3
      assert_equal contest.contestants[0].score_log.new_position, 2
      assert_equal contest.contestants[0].score_log.position_difference, 1
      assert_equal contest.contestants[1].score_log.previous_position, 2
      assert_equal contest.contestants[1].score_log.new_position, 3
      assert_equal contest.contestants[1].score_log.position_difference, -1
    end
  end
end
