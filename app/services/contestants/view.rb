module Contestants
  class View < SimpleDelegator
    def initials
      user.name.split.map(&:first).join
    end

    def name
      user.name
    end

    def first_name
      user.first_name
    end

    def signed_score_difference
      '%+d' % score_log.score_difference
    end

    def winner?
      place == Contestant::PLACES.first
    end

    def loser?
      !winner?
    end
  end
end
