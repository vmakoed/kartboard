module Contests
  class Create
    K_FACTOR = 32
    SCALING_FACTOR = 400.0

    def self.call(contestants_attributes:)
      contest = Contest.new

      contestants_attributes.each do |place, contestant_attributes|
        next if contestant_attributes[:user_id].blank?

        contest.contestants.build(contestant_attributes.merge(place: place.to_i + 1))
      end

      score_differences = contest.contestants.each_with_object(Hash.new) do |contestant, result|
        result[contestant] = contestant.user.score
      end

      contest.contestants.each do |player|
        contest.contestants.each do |opponent|
          next if player == opponent

          expected_score = 1.0 / (1.0 + 10**((opponent.user.score - player.user.score) / SCALING_FACTOR))

          actual_score = if player.place < opponent.place
                           1.0
                         elsif player.place == opponent.place
                           0.5
                         else
                           0.0
                         end

          score_difference = (K_FACTOR * (actual_score - expected_score)).round

          score_differences[player] = score_difference
        end
      end

      score_differences.each do |contestant, score_difference|
        previous_score = contestant.user.score
        new_score = previous_score + score_difference

        contestant.build_score_log(
          previous_score: previous_score,
          new_score: new_score,
          score_difference: score_difference
        )

        contestant.assign_attributes(user_attributes: { score: new_score })
      end

      contest
    end
  end
end
