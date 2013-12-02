require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  setup do
    @course = Fabricate(:course)
    @grade = @course.grade
  end

  test 'create' do
    assert_difference 'Course.count' do
      @course = Course.create(Fabricate.attributes_for(:course))
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Course.count' do
        assert @course.update(name: 'Updated')
      end
    end

    assert_equal 'Updated', @course.reload.name
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Course.count', -1) { @course.destroy }
    end
  end

  test 'validates blank attributes' do
    @course.name = ''
    @course.grade_id = nil

    assert @course.invalid?
    assert_equal 2, @course.errors.size
    assert_equal [error_message_from_model(@course, :name, :blank)],
      @course.errors[:name]
    assert_equal [error_message_from_model(@course, :grade_id, :blank)],
      @course.errors[:grade_id]
  end

  test 'validates unique attributes' do
    new_course = Fabricate(:course, grade_id: @grade.id)
    @course.name = new_course.name

    assert @course.invalid?
    assert_equal 1, @course.errors.size
    assert_equal [error_message_from_model(@course, :name, :taken)],
      @course.errors[:name]
  end

  test 'validates length of _long_ attributes' do
    @course.name = 'abcde' * 52

    assert @course.invalid?
    assert_equal 1, @course.errors.count
    assert_equal [
      error_message_from_model(@course, :name, :too_long, count: 255)
    ], @course.errors[:name]
  end

  test 'magick search' do
    5.times do
      Fabricate(:course) { name { "magick_name #{sequence(:course_name)}" } }
    end

    courses = Course.magick_search('magick')

    assert_equal 5, courses.count
    assert courses.all? { |s| s.to_s =~ /magick/ }

    courses = Course.magick_search('noplace')

    assert courses.empty?
  end
end
