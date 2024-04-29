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
      @new_user_positions = Hash.new
    end

    def call
      build_score_logs
      calculate_score_differences
      assign_score_attributes
      calculate_new_positions
      assign_position_attributes

      contest
    end

    private

    attr_reader :contest_params, :score_differences, :new_user_positions

    def build_score_logs
      contest.contestants.each(&:build_score_log)
    end

    def calculate_score_differences
      contest.contestants.each do |player|
        contest.contestants.each do |opponent|
          next if player == opponent

          calculate_matchup(player, opponent)
        end
      end
    end

    def assign_score_attributes
      score_differences.each do |contestant, score_difference|
        previous_score = contestant.user.score
        new_score = previous_score + score_difference

        contestant.score_log.assign_attributes(
          previous_score: previous_score,
          new_score: new_score,
          score_difference: score_difference
        )

        contestant.assign_attributes(user_attributes: { score: new_score })
      end
    end

    def calculate_new_positions
      scores = User
        .with_contestants
        .order(score: :desc)
        .pluck(:id, :score)
        .to_h
        .tap { _1.default = User::DEFAULT_SCORE }

      contest.contestants.each do |contestant|
        scores[contestant.user_id] += score_differences[contestant]
      end

      scores
        .sort_by { |_, score| -score }
        .each_with_index do |(user_id, _), index|
          next if user_ids.exclude?(user_id)

          new_user_positions[user_id] = index + 1
        end
    end

    def assign_position_attributes
      contest.contestants.each do |contestant|
        previous_position = previous_user_positions[contestant.user_id]
        new_position = new_user_positions[contestant.user_id]
        contestant.score_log.assign_attributes(
          previous_position: previous_position,
          new_position: new_position,
          position_difference: previous_position - new_position
        )
      end
    end

    def user_ids
      @user_ids ||= contest.contestants.map(&:user_id)
    end

    def contest
      @contest ||= Contest.new(contest_params)
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

    def previous_user_positions
      all_contestants = User.with_contestants
      current_contestants = User.where(id: user_ids)

      @previous_positions ||= User
        .where(id: all_contestants.select(:id))
        .or(User.where(id: current_contestants.select(:id)))
        .order(score: :desc)
        .pluck(:id)
        .each_with_index
        .to_h
        .slice(*user_ids)
        .transform_values { _1 + 1 }
    end
  end
end
