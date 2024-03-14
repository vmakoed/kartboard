require 'test_helper'

class UsersEmailVerificationTest < ActiveSupport::TestCase
  setup do
    @original_allowed_domains = ENV['ALLOWED_DOMAINS']
    @original_allowed_emails = ENV['ALLOWED_EMAILS']

    ENV['ALLOWED_DOMAINS'] = 'example.com,test.com'
    ENV['ALLOWED_EMAILS'] = 'allowed@example.org'
  end

  teardown do
    ENV['ALLOWED_DOMAINS'] = @original_allowed_domains
    ENV['ALLOWED_EMAILS'] = @original_allowed_emails
  end

  test 'passes for allowed domain' do
    verifier = Users::EmailVerification.passed?(email: 'user@example.com')
    assert verifier
  end

  test 'fails for disallowed domain' do
    verifier = Users::EmailVerification.passed?(email: 'user@disallowed.com')
    assert_not verifier
  end

  test 'passes when no restrictions set' do
    ENV['ALLOWED_DOMAINS'] = ''
    ENV['ALLOWED_EMAILS'] = ''
    verifier = Users::EmailVerification.passed?(email: 'anyone@anywhere.com')
    assert verifier
  end
end
