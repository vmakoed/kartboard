require 'test_helper'

class ContestantTest < ActiveSupport::TestCase
  setup do
    @contest = contests(:weekly_race)
    @user = users(:alice)
    @contestant = contestants(:alice_contestant)
  end

  test 'user should be unique within a contest' do
    duplicate_contestant = Contestant.new(contest: @contest, user: @user)
    assert_not duplicate_contestant.valid?, 'Contestant should not be valid due to uniqueness constraint'
    assert_includes duplicate_contestant.errors[:user], 'has already been taken'
  end

  test 'should belong to a contest' do
    assert_equal @contest, @contestant.contest, 'Contestant does not belong to the correct contest'
  end

  test 'should belong to a user' do
    assert_equal @user, @contestant.user, 'Contestant does not belong to the correct user'
  end

  test 'should destroy score_log when contestant is destroyed' do
    assert_difference('ScoreLog.count', -1) do
      @contestant.destroy
    end
  end
end
