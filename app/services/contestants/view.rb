module Contestants
  class View < SimpleDelegator
    delegate :previous_position, :new_position, to: :score_log
    delegate :user, to: :player

    def initials
      user.name.split.map(&:first).join
    end

    def name
      user.name
    end

    def signed_score_difference
      '%+d' % score_log.score_difference
    end

    def position_update
      return nil if new_position.blank?
      return nil if previous_position.blank?
      return new_position if new_position == previous_position

      "#{previous_position}→#{new_position}"
    end

    def winner?
      place == Contestant::PLACES.first
    end

    def loser?
      !winner?
    end
  end
end
