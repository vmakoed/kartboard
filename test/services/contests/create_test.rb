require 'test_helper'

class ContestsCreateTest < ActiveSupport::TestCase
  K_FACTOR = 32
  SCALING_FACTOR = 400.0

  setup do
    @user1 = users(:alice)
    @user2 = users(:bob)
    @contestants_attributes = {
      "0" => { user_id: @user1.id },
      "1" => { user_id: @user2.id }
    }
  end

  test 'correctly creates a contest with contestants' do
    contest = Contests::Create.call(contestants_attributes: @contestants_attributes)

    assert_equal 2, contest.contestants.size
    assert_equal @user1, contest.contestants.first.user
    assert_equal @user2, contest.contestants.second.user
  end

  test 'assigns places based on the order of contestants' do
    contest = Contests::Create.call(contestants_attributes: @contestants_attributes)

    assert_equal 1, contest.contestants.first.place
    assert_equal 2, contest.contestants.second.place
  end

  test 'calculates score changes correctly' do
    contest = Contests::Create.call(contestants_attributes: @contestants_attributes)

    assert_equal contest.contestants[0].user.score, 1024
    assert_equal contest.contestants[1].user.score, 1176
  end
end
