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
      calculate_previous_user_positions
      calculate_score_differences
      assign_score_attributes
      calculate_new_positions
      assign_position_attributes

      contest
    end

    private

    attr_reader :contest_params, :previous_positions, :score_differences,
                :new_user_positions

    def build_score_logs
      contest.contestants.each(&:build_score_log)
    end

    def calculate_previous_user_positions
      current_players = contest.contestants.map(&:player)
      other_players = contest_params[:game]
        .players
        .where
        .not(id: current_players.pluck(:id).compact)


      @previous_positions = (current_players + other_players)
        .sort_by(&:score)
        .reverse
        .pluck(:user_id)
        .each_with_index
        .to_h
        .slice(*user_ids)
        .transform_values { _1 + 1 }
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
        previous_score = contestant.player.score
        new_score = previous_score + score_difference

        contestant.score_log.assign_attributes(
          previous_score: previous_score,
          new_score: new_score,
          score_difference: score_difference
        )

        contestant.player.score = new_score # check if validation would work (instead of assign_attributes)
      end
    end

    def calculate_new_positions
      scores = Player
        .where(game_id: contest.game_id)
        .pluck(:user_id, :score)
        .to_h
        .tap { _1.default = Player::DEFAULT_SCORE }

      contest.contestants.each do |contestant|
        scores[contestant.player.user_id] += score_differences[contestant]
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
        previous_position = previous_positions[contestant.player.user_id]
        new_position = new_user_positions[contestant.player.user_id]
        contestant.score_log.assign_attributes(
          previous_position: previous_position,
          new_position: new_position,
          position_difference: previous_position - new_position
        )
      end
    end

    def user_ids
      @user_ids ||= contest.contestants.map { _1.player.user_id }
    end

    def contest
      @contest ||= build_contest
    end

    def build_contest
      Contest
        .new(contest_params.slice(:game, :created_by))
        .tap(&method(:build_contestants))
    end

    def build_contestants(contest_object)
      contest_params[:contestants_attributes]
        .select { |_, attributes| attributes[:user_id].present? }
        .values
        .each do |attributes|
          contest_object
            .contestants
            .build(attributes.slice(:place))
            .then {
              assign_player(
                contestant: _1,
                user_id: attributes[:user_id]
              )
            }
      end
    end

    def assign_player(contestant:, user_id:)
      contestant.player = Player.find_or_initialize_by(
        game: contest_params[:game],
        user_id: user_id
      )
    end

    # TODO: review algorithm, extract to a separate service
    def calculate_matchup(contestant_player, contestant_opponent)
      expected_score = calculate_expected_score(
        contestant_player.player.score,
        contestant_opponent.player.score
      )
      actual_score = calculate_actual_score(
        contestant_player.place,
        contestant_opponent.place
      )
      matchup_score_difference = (
        K_FACTOR * (actual_score - expected_score)
      ).round

      score_differences[contestant_player] += matchup_score_difference
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
