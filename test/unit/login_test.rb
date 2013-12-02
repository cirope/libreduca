require 'test_helper'

class LoginTest < ActiveSupport::TestCase
  setup do
    @login = Fabricate(:login)
  end

  test 'create' do
    assert_difference 'Login.count' do
      @login = Login.create Fabricate.attributes_for(:login)
    end
  end

  test 'update' do
    new_ip = Faker::Internet.ip_v4_address

    assert_not_equal new_ip, @login.ip

    assert_no_difference 'Login.count' do
      assert @login.update(ip: new_ip)
    end

    assert_equal new_ip, @login.reload.ip
  end

  test 'destroy' do
    assert_difference('Login.count', -1) { @login.destroy }
  end

  test 'validates blank attributes' do
    @login.ip = ''
    @login.user = nil

    assert @login.invalid?
    assert_equal 2, @login.errors.size
    assert_equal [error_message_from_model(@login, :ip, :blank)],
      @login.errors[:ip]
    assert_equal [error_message_from_model(@login, :user, :blank)],
      @login.errors[:user]
  end

  test 'validates length of attributes' do
    @login.ip = 'abcde' * 52

    assert @login.invalid?
    assert_equal 1, @login.errors.count
    assert_equal [
      error_message_from_model(@login, :ip, :too_long, count: 255)
    ], @login.errors[:ip]
  end
end
