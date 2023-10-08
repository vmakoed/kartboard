class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    find_or_initialize_by(
      provider: auth.provider,
      uid: auth.uid
    ).tap { |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.save!
    }
  end
end
