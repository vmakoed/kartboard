class Run < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :users, through: :players

  validates :code, presence: true, uniqueness: true, length: { is: 6 }

  after_initialize :set_defaults

  def players_stream_id
    "run_#{id}_players"
  end

  private

  def set_defaults
    self.code ||= SecureRandom.alphanumeric(6).upcase
  end
end
