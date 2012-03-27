module SchoolsHelper
  def link_to_school_grades(school)
    grades_count = school.grades.count
    
    if grades_count > 0
      link_to(
        t('view.schools.show_grades', count: grades_count),
        school_grades_path(school)
      )
    else
      link_to t('view.grades.new'), new_school_grade_path(school)
    end
  end
end
