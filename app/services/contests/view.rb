module Contests
  class View < SimpleDelegator
    def contestants
      super.map(&Contestants::View.method(:new))
    end

    def winners
      contestants.select(&:winner?).sort_by(&:name)
    end

    def losers
      contestants.select(&:loser?).sort_by(&:place)
    end
  end
end
