class User < ApplicationRecord
  has_many :contestants, dependent: :destroy
  has_many :contests, through: :contestants

  validates :email, :name, :provider, :uid, presence: true
  validates :score, numericality: { greater_than_or_equal_to: 0 }
  validate :email_allowed, if: -> { email.present? }

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    find_or_initialize_by(
      provider: auth.provider,
      uid: auth.uid
    ).tap { |user|
      user.email = auth.info.email
      user.name = auth.info.name
    }
  end

  private

  def email_allowed
    return if Users::EmailVerification.passed?(email: email)

    errors.add(:email, 'is not allowed')
  end
end
