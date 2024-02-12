require 'test_helper'

class ContestTest < ActiveSupport::TestCase
  setup do
    @contest = contests(:weekly_race)
  end

  test 'should have many contestants' do
    assert @contest.contestants.length > 0, "Contest should have contestants"
  end

  test 'should have many users through contestants' do
    assert @contest.users.length > 0, "Contest should have users through contestants"
  end

  test 'should destroy contestants when contest is destroyed' do
    contest = contests(:weekly_race)

    assert_difference('Contestant.count', -contest.contestants.count) do
      contest.destroy
    end
  end
end
