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
end
