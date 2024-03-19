module Contests
  class View < SimpleDelegator
    def initialize(contest, contestants_view_class = Contestants::View)
      super(contest)
      @contestants_view_class = contestants_view_class
    end

    def contestants
      super.map(&@contestants_view_class.method(:new))
    end

    def winners
      contestants.select(&:winner?).sort_by(&:name)
    end

    def losers
      contestants.select(&:loser?).sort_by(&:place)
    end
  end
end
