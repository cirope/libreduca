module GradesHelper
  def link_to_grade_courses(grade)
    courses_count = grade.courses.count

    if courses_count > 0
      link_to(
        t('view.grades.show_courses', count: courses_count),
        grade_courses_path(grade)
      )
    else
      link_to t('view.courses.new'), new_grade_course_path(grade)
    end
  end
end
