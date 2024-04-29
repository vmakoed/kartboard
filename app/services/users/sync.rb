require 'rest-client'

module Users
  class Sync
    def self.call
      bamboohr_subdomain = ENV.fetch('BAMBOOHR_SUBDOMAIN')
      bamboohr_api_key = ENV.fetch('BAMBOOHR_API_KEY')

      directory = RestClient::Request.execute(
        method: :get,
        url: "https://api.bamboohr.com/api/gateway.php/#{bamboohr_subdomain}/v1/employees/directory",
        user: bamboohr_api_key,
        headers: { accept: :json }
      ).then { JSON.parse(_1) }

      directory['employees'].each do |employee|
        email = employee['workEmail']
        next if email.blank?

        user = User.find_or_initialize_by(email: email.downcase)
        user.name = employee['displayName']

        user.save
      end
    end
  end
end
