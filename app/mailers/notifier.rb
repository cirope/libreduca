class Notifier < ActionMailer::Base
  layout 'notifier_mailer'
  helper :application
  default from: "'#{I18n.t('app_name')}' <#{APP_CONFIG['smtp']['user_name']}>"
  
  def enrollment_status(enrollment)
    # TODO: fix when nested through works =)
    @institution = enrollment.grade.try(:institution)
    @enrollment = enrollment
    @users = [enrollment.user] + enrollment.user.relatives.to_a
    
    mail(
      subject: t(
        'notifier.enrollment_status.subject',
        user: @enrollment.user,
        course: @enrollment.course
      ),
      to: @enrollment.user.email,
      cc: @enrollment.user.relatives.map(&:email)
    )
  end

  def new_forum(forum, institution)
    @institution = institution
    @forum = forum
    users = @forum.users

    mail(
      subject: t('notifier.new_forum.subject', forum: @forum),
      bcc: users.map(&:email)
    )
  end

  def new_comment(comment, institution)
    @institution = institution
    @comment = comment
    @forum = @comment.forum
    users = @forum.users

    mail(
      subject: t('notifier.new_comment.subject', forum: @forum),
      bcc: users.map(&:email)
    )
  end

  def new_enrollment(enrollment)
    # TODO: fix when nested through works =)
    @institution = enrollment.grade.try(:institution)
    @enrollment = enrollment
    @users = [enrollment.user] + enrollment.user.relatives.to_a

    mail(
      subject: t(
        'notifier.new_enrollment.subject',
        user: @enrollment.user,
        course: @enrollment.course
      ),
      to: enrollment.user.email,
      cc: enrollment.user.relatives.map(&:email)
    )
  end
end
