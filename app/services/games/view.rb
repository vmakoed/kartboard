module Games
  class View < SimpleDelegator
    def suggested_players
      User
        .joins(players: { contestants: :contest })
        .where('contests.game_id = ?', id)
        .group('users.id')
        .order('COUNT(contests.id) DESC')
        .select(:id, :name)
        .limit(10)
    end

    def all_players
      @all_players ||= User
        .select(:id, :name).order(:name)
    end
  end
end
