class CodesController < ApplicationController
  def create
    @code = SecureRandom.alphanumeric(6).upcase
    @url = participants_url(match_code: @code)
    @svg = RQRCode::QRCode.new(@url).as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6
    )

    respond_to do |format|
      format.turbo_stream
    end
  end
end
