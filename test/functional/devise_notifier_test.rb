# encoding: utf-8

require 'test_helper'

class DeviseNotifierTest < ActionMailer::TestCase

  setup do
    @institution = Fabricate(:institution)
    @user = Fabricate(:user, password: '123456', roles: [:normal])
    @job = Fabricate(
      :job, user_id: @user.id, institution_id: @institution.id, job: 'janitor'
    )
  end

  test 'welcome instructions' do
    mail = DeviseNotifier.welcome_instructions(@user)

    assert_equal I18n.t('devise.mailer.welcome_instructions.subject'), mail.subject
    assert_equal [@user.email], mail.to
    assert_match 'Para establecer tu primer', mail.body.encoded

    assert_difference 'ActionMailer::Base.deliveries.size' do
      mail.deliver
    end
  end

  test 'token instructions' do
    mail = DeviseNotifier.token_instructions(@user)

    assert_equal I18n.t('devise.mailer.token_instructions.subject'), mail.subject
    assert_equal [@user.email], mail.to
    assert_match 'Bienvenido a Libreduca', mail.body.encoded

    assert_difference 'ActionMailer::Base.deliveries.size' do
      mail.deliver
    end
  end

  test 'reset password instructions' do
    mail = DeviseNotifier.reset_password_instructions(@user)

    assert_equal I18n.t('devise.mailer.reset_password_instructions.subject'), mail.subject
    assert_equal [@user.email], mail.to
    assert_match 'Alguien ha pedido cambiar', mail.body.encoded

    assert_difference 'ActionMailer::Base.deliveries.size' do
      mail.deliver
    end
  end

  test 'embedded reset password instructions' do
    mail = DeviseNotifier.embedded_reset_password_instructions(@user)

    assert_equal I18n.t('devise.mailer.embedded_reset_password_instructions.subject'), mail.subject
    assert_equal [@user.email], mail.to
    assert_match 'Alguien ha pedido cambiar', mail.body.encoded

    assert_difference 'ActionMailer::Base.deliveries.size' do
      mail.deliver
    end
  end
end
