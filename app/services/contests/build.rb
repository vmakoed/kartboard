module Contests
  class Build
    K_FACTOR = 32
    SCALING_FACTOR = 400.0

    def self.call(contest_params:)
      new(contest_params: contest_params).call
    end

    def initialize(contest_params:)
      @contest_params = contest_params
      @score_differences = Hash.new(0)
    end

    def call
      calculate_score_differences
      assign_attributes

      contest
    end

    private

    attr_reader :contest_params, :score_differences

    def contest
      @contest ||= Contest.new(contest_params)
    end

    def calculate_score_differences
      contest.contestants.each do |player|
        contest.contestants.each do |opponent|
          next if player == opponent

          calculate_matchup(player, opponent)
        end
      end
    end

    def assign_attributes
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
    end

    # TODO: review algorithm, extract to a separate service
    def calculate_matchup(player, opponent)
      expected_score = calculate_expected_score(player.user.score, opponent.user.score)
      actual_score = calculate_actual_score(player.place, opponent.place)
      matchup_score_difference = (K_FACTOR * (actual_score - expected_score)).round

      score_differences[player] += matchup_score_difference
    end

    def calculate_expected_score(player_score, opponent_score)
      1.0 / (1.0 + 10**((opponent_score - player_score) / SCALING_FACTOR))
    end

    def calculate_actual_score(player_place, opponent_place)
      if player_place < opponent_place
        1.0
      elsif player_place == opponent_place
        0.5
      else
        0.0
      end
    end
  end
end
