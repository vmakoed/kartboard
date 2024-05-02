require 'rest-client'

module Users
  class Sync
    def self.call
      bamboohr_subdomain = ENV.fetch('BAMBOOHR_SUBDOMAIN')
      bamboohr_api_key = ENV.fetch('BAMBOOHR_API_KEY')
      employees_url = "https://api.bamboohr.com/api/gateway.php/"\
        "#{bamboohr_subdomain}/v1/employees"
      photo_url = "#{employees_url}/%s/photo/large"

      directory = RestClient::Request
        .execute(
          method: :get,
          url: "#{employees_url}/directory",
          user: bamboohr_api_key,
          headers: { accept: :json }
        ).then { JSON.parse(_1) }

      directory['employees'].each do |employee|
        email = employee['workEmail']

        if email.blank?
          puts "Could not sync employee #{employee['workEmail']}: empty email"
          next
        end

        photo = RestClient::Request
          .execute(
            method: :get,
            url: photo_url % employee['id'],
            user: bamboohr_api_key
          ).body

        User
          .find_or_initialize_by(email: email.downcase)
          .tap { _1.name = employee['displayName'] }
          .tap {_1.photo.attach(
            io: StringIO.new(photo),
            filename: "#{employee['id']}.jpg",
            content_type: 'image/jpeg'
          ) }.save

      rescue => e
        puts "Could not sync employee #{employee['workEmail']}: #{e.message}"
      end
    end
  end
end
