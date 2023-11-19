class RunView < SimpleDelegator
  include Rails.application.routes.url_helpers

  def initialize(run:, current_user:)
    super(run)

    @current_user = current_user
  end

  def join_url
    @join_url ||= run_url(self)
  end

  def join_qr
    RQRCode::QRCode.new(join_url).as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6
    )
  end

  def default_url_options
    { host: "localhost", port: 3000 }
  end

  def current_user_player
    players.find_by(user: current_user)
  end

  def joined_by_current_user?
    current_user_player.present?
  end

  private

  attr_reader :current_user
end
