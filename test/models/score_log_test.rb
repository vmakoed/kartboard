require 'test_helper'

class ScoreLogTest < ActiveSupport::TestCase
  setup do
    @contestant = contestants(:alice_contestant)
    @score_log = score_logs(:alice_score_log)
  end

  test 'valid score log' do
    assert @score_log.valid?
  end

  test 'invalid without previous_score' do
    @score_log.previous_score = nil
    assert_not @score_log.valid?, 'ScoreLog is valid without a previous_score'
    assert_not_nil @score_log.errors[:previous_score], 'No validation error for previous_score present'
  end

  test 'invalid without new_score' do
    @score_log.new_score = nil
    assert_not @score_log.valid?, 'ScoreLog is valid without a new_score'
    assert_not_nil @score_log.errors[:new_score], 'No validation error for new_score present'
  end

  test 'invalid without score_difference' do
    @score_log.score_difference = nil
    assert_not @score_log.valid?, 'ScoreLog is valid without a score_difference'
    assert_not_nil @score_log.errors[:score_difference], 'No validation error for score_difference present'
  end

  test 'new_score must be a number greater than or equal to 0' do
    score_log = ScoreLog.new(contestant: @contestant, previous_score: 900, new_score: -10, score_difference: -910)
    assert_not score_log.valid?, 'ScoreLog should not be valid if new_score is less than 0'
    assert_includes score_log.errors[:new_score], 'must be greater than or equal to 0'
  end

  test 'previous_score must be a number greater than or equal to 0' do
    score_log = ScoreLog.new(contestant: @contestant, previous_score: -50, new_score: 950, score_difference: 1000)
    assert_not score_log.valid?, 'ScoreLog should not be valid if previous_score is less than 0'
    assert_includes score_log.errors[:previous_score], 'must be greater than or equal to 0'
  end

  test 'score difference must be consistent with new_score and previous_score' do
    assert @score_log.valid?, 'ScoreLog should be valid when score_difference is the actual difference'

    @score_log.score_difference += 1
    assert_not @score_log.valid?, 'ScoreLog should not be valid if score_difference does not match the difference between new_score and previous_score'
    assert_includes @score_log.errors[:score_difference], 'must be the difference between new_score and previous_score'
  end
end
