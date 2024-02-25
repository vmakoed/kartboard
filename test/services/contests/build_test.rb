require 'test_helper'

class ContestsBuildTest < ActiveSupport::TestCase
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

  test 'calculates score changes correctly' do
    contest = Contests::Build.call(contest_params: @contest_params)

    assert_equal contest.contestants[0].user.score, 1024
    assert_equal contest.contestants[1].user.score, 1176
  end
end
