class Notifier < ActionMailer::Base
  layout 'notifier_mailer'
  default from: "'#{I18n.t('app_name')}' <#{APP_CONFIG['smtp']['user_name']}>"
  
  def enrollment_status(enrollment)
    @enrollment = enrollment
    @users = [enrollment.user] + enrollment.user.relatives.to_a
    
    mail(
      subject: t(
        'notifier.enrollment_status.subject',
        user: @enrollment.user,
        course: @enrollment.course
      ),
      to: enrollment.user.email,
      cc: enrollment.user.relatives.map(&:email)
    )
  end
end
