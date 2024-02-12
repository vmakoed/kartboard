# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @alice = users(:alice)
  end

  test 'valid user' do
    assert @alice.valid?
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

  test 'from_omniauth creates a new user if not exists' do
    auth = OmniAuth::AuthHash.new({
                                    provider: 'google_oauth2',
                                    uid: 'new_uid',
                                    info: {
                                      email: 'new_user@google.com',
                                      name: 'New User'
                                    }
                                  })

    assert_difference 'User.count', 1 do
      User.from_omniauth(auth)
    end
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

    assert_no_difference 'User.count' do
      user = User.from_omniauth(auth)
      assert_equal @alice.id, user.id
    end
  end
end
