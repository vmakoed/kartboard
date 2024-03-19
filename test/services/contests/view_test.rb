require 'test_helper'
require 'minitest/autorun'

module Contests
  class ViewTest < Minitest::Test
    MockContest = Struct.new(:contestants)
    MockContestant = Struct.new(:name, :place, :winner?, :loser?)

    def setup
      @winner1 = MockContestant.new("Alice", 1, true, false)
      @winner2 = MockContestant.new("Carol", 2, true, false)
      @loser1 = MockContestant.new("Bob", 3, false, true)
      @loser2 = MockContestant.new("Dave", 4, false, true)

      @contestants = [@winner1, @loser1, @winner2, @loser2]
      @contest = MockContest.new(@contestants)

      @view = Contests::View.new(@contest, SimpleDelegator)
    end

    def test_winners
      assert_equal [@winner1, @winner2].map(&:name), @view.winners.map(&:name)
    end

    def test_losers
      assert_equal [@loser1, @loser2].map(&:place), @view.losers.map(&:place)
    end
  end
end
