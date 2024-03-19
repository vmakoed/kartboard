require 'test_helper'

module Contestants
  class MockContestant
    attr_reader :user, :place, :score_log

    PLACES = [1, 2, 3, 4]

    def initialize(user:, place:, score_log:)
      @user = user
      @place = place
      @score_log = score_log
    end
  end

  MockUser = Struct.new(:name, :first_name)
  MockScoreLog = Struct.new(:score_difference)

  class ViewTest < Minitest::Test
    def setup
      user = MockUser.new("John Doe", "John")
      score_log = MockScoreLog.new(15)
      @first_place_contestant = MockContestant.new(user: user, place: MockContestant::PLACES.first, score_log: score_log)
      @view = Contestants::View.new(@first_place_contestant)
    end

    def test_initials
      assert_equal "JD", @view.initials
    end

    def test_name
      assert_equal "John Doe", @view.name
    end

    def test_first_name
      assert_equal "John", @view.first_name
    end

    def test_signed_score_difference
      assert_equal "+15", @view.signed_score_difference
    end

    def test_winner_when_first_place
      assert @view.winner?
    end

    def test_loser_when_not_first_place
      second_place_contestant = MockContestant.new(user: @first_place_contestant.user, place: MockContestant::PLACES[1], score_log: @first_place_contestant.score_log)
      view = Contestants::View.new(second_place_contestant)
      assert view.loser?
    end
  end
end


