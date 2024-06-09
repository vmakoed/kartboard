class User < ApplicationRecord
  DEFAULT_SCORE = 1000

  has_many :contestants, dependent: :destroy
  has_many :score_logs, through: :contestants
  has_many :contests, through: :contestants

  has_one_attached :photo

  validates :email, :name, presence: true
  validates :score, numericality: { greater_than_or_equal_to: 0 }
  validate :email_allowed, if: -> { email.present? }

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  scope :with_contestants, -> { joins(:contestants).distinct }

  def self.from_omniauth(auth)
    find_or_initialize_by(email: auth.info.email.downcase).tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
    end
  end

  def last_played_game
    return nil unless contestants.exists?

    contestants.last.contest.game
  end

  private

  def email_allowed
    return if Users::EmailVerification.passed?(email: email)

    errors.add(:email, 'is not allowed')
  end
end
