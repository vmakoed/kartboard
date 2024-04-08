module Contestants
  class View < SimpleDelegator
    delegate :position_difference, to: :score_log

    def initials
      user.name.split.map(&:first).join
    end

    def name
      user.name
    end

    def signed_score_difference
      '%+d' % score_log.score_difference
    end

    def signed_position_difference
      if position_difference.positive?
        "↑#{position_difference}"
      elsif position_difference.negative?
        "↓#{position_difference.abs}"
      else
        nil
      end
    end

    def winner?
      place == Contestant::PLACES.first
    end

    def loser?
      !winner?
    end
  end
end
