module Users
  class EmailVerification
    def self.passed?(email:)
      new(email: email).passed?
    end

    def initialize(email:)
      @email = email
    end

    def passed?
      return true if allowed_domains.empty? && allowed_emails.empty?
      return true if allowed_domains.include?(domain)
      return true if allowed_emails.include?(email.downcase)

      false
    end

    private

    attr_reader :email

    def domain
      @domain ||= email.split('@').last.downcase
    end

    def allowed_domains
      @allowed_domains = ENV.fetch('ALLOWED_DOMAINS', '').split(',')
    end

    def allowed_emails
      @allowed_emails = ENV.fetch('ALLOWED_EMAILS', '').split(',')
    end
  end
end
