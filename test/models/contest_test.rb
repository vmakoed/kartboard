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

  test 'validates places within sequence' do
    @contest = Contest.new

    @contest.contestants.build(place: 1, user: users(:alice))
    @contest.contestants.build(place: 2, user: users(:bob))
    @contest.contestants.build(place: 4, user: users(:charlie))

    assert_not @contest.valid?
    assert_includes @contest.errors[:contestants], 'have invalid placement, expected 3rd place instead of 4th place'
  end

  test 'validates contestants size within range' do
    @contest = Contest.new

    @contest.contestants.build(place: 1, user: users(:alice))
    @contest.contestants.build(place: 2, user: users(:bob))
    assert @contest.valid?

    @contest.contestants = []
    @contest.contestants.build(place: 1, user: users(:alice))
    @contest.contestants.build(place: 1, user: users(:bob))
    @contest.contestants.build(place: 1, user: users(:charlie))
    @contest.contestants.build(place: 1, user: users(:dave))
    @contest.contestants.build(place: 1, user: users(:edward))
    assert_not @contest.valid?
    assert_includes @contest.errors[:base], 'The number of participants must be between 2 and 4'
  end
end
