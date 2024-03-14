require 'test_helper'
require 'minitest/autorun'

class UserTest < ActiveSupport::TestCase
  setup do
    @alice = users(:alice)
  end

  test 'valid user' do
    Users::EmailVerification.stub :passed?, Proc.new { |email:|
      assert_equal @alice.email, email
      true
    } do
      assert @alice.valid?
    end
  end

  test 'invalid without score' do
    @alice.score = nil
    refute @alice.valid?, 'saved user without a score'
    assert_not_nil @alice.errors[:score], 'no validation error for score present'
  end

  test 'score must be a number greater than or equal to 0' do
    @alice.score = -1
    refute @alice.valid?, 'saved user with a negative score'
    assert_includes @alice.errors[:score], 'must be greater than or equal to 0'
  end

  test 'from_omniauth finds an existing user' do
    auth = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: @alice.uid,
      info: {
        email: @alice.email,
        name: @alice.name
      }
    })

    user = User.from_omniauth(auth)
    assert_equal @alice.id, user.id
  end

  def test_validates_that_a_disallowed_email_adds_an_error
    Users::EmailVerification.stub :passed?, Proc.new { |email:|
        assert_equal @alice.email, email
        false
      } do
        refute @alice.valid?
    end

    assert_includes @alice.errors[:email], 'is not allowed'
  end
end
