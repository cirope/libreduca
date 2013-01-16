module TeachesHelper
  def teach_splited_enrollments(teach)
    splited_enrollments = teach.enrollments.group_by(&:job)

    Job::TYPES.map do |job|
      enrollments = splited_enrollments.detect { |type, _| type == job }

      enrollments ?
        [
          t(
            "view.teaches.enrollment_types.#{job}",
            count: enrollments.last.size
          ),
          enrollments.last.sort
        ] : nil
    end.compact
  end

  def build_blank_teach_scores(teach)
    to_build = []

    teach.enrollments.only_students.each do |e|
      unless teach.scores.detect { |s| s.new_record? && s.user_id == e.enrollable_id }
        to_build << e.enrollable_id
      end
    end

    teach.scores.build(to_build.map { |u_id| { user_id: u_id } })
  end

  def build_new_teach_scores(teach)
    existing_scores = teach.scores.select(&:new_record?)
    blank_scores = build_blank_teach_scores teach

    (existing_scores + blank_scores).sort { |s1, s2| s1.user <=> s2.user }
  end

  def teach_scores_grouped_by_student(teach)
    max = 0
    tmp_scores = {}

    teach.scores.each do |score|
      tmp_scores[score.user_id] ||= []
      tmp_scores[score.user_id] << score

      tmp_scores[score.user_id].size.tap do |size|
        max = size if size > max
      end
    end

    grouped_scores = tmp_scores.map do |user_id, scores|
      sorted_scores = scores.sort { |s1, s2| s1.created_at <=> s2.created_at } +
        (max - scores.size).times.map { nil }

      [(User.find(user_id) rescue '-'), sorted_scores]
    end

    grouped_scores.sort do |user_scores1, user_scores2|
      user_scores1.first <=> user_scores2.first
    end
  end

  def show_teach_score_details(score)
    if score
      content = content_tag(
        :ul, [
          content_tag(
            :li, [
              content_tag(:strong, Score.human_attribute_name('multiplier')),
              number_with_precision(score.multiplier)
            ].join(' ').html_safe
          ),
          content_tag(
            :li, [
              content_tag(:strong, Score.human_attribute_name('created_at')),
              l(score.created_at, format: :long)
            ].join(' ').html_safe
          ),
          content_tag(
            :li, [
              content_tag(:strong, Score.human_attribute_name('whodunnit')),
              (User.find(score.originator) rescue '-')
            ].join(' ').html_safe
          )
        ].join('').html_safe
      )

      content_tag(
        :abbr, number_with_precision(score.score), title: score.description,
        data: { 'show-popover' => true, 'content' => raw(content) }
      )
    else
      '-'
    end
  end

  def show_teach_visit_progress_to(teach, user)
    @teach_content_ids ||= {}
    content_ids = @teach_content_ids[teach.id] ||= teach.contents.map(&:id)

    if content_ids.size > 0
      visits_count = user.visits.visited(Content, *content_ids).count
      text = '%.2f%%' % ((visits_count.to_f / content_ids.size) * 100)
      html_class = visits_count == content_ids.size ? 'text-success' : 'text-warning'

      request.format == 'text/html' ? content_tag(:span, text, class: html_class) : text
    else
      '-'
    end
  end

  def show_teach_survey_progress_to(teach, user)
    @teach_question_ids ||= {}
    question_ids = @teach_question_ids[teach.id] ||= teach.questions.map(&:id)

    if question_ids.size > 0
      questions_count = user.replies.of_questions(*question_ids).count
      text = '%.2f%%' % ((questions_count.to_f / question_ids.size) * 100)
      html_class = questions_count == question_ids.size ? 'text-success' : 'text-warning'

      request.format == 'text/html' ? content_tag(:span, text, class: html_class) : text
    else
      '-'
    end
  end

  def generate_teach_tracking_csv
    CSV.generate(col_sep: ';') do |csv|
      csv << [
        t('view.teaches.enrollment_types.student', count: 1),
        t('view.teaches.visited_content'),
        t('view.teaches.questions_answered')
      ]

      @teach.enrollments.only_students.each do |enrollment|
        csv << [
          enrollment.user.to_s,
          show_teach_visit_progress_to(@teach, enrollment.user),
          show_teach_survey_progress_to(@teach, enrollment.user)
        ]
      end
    end
  end
end
