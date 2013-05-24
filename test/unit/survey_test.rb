require 'test_helper'

class SurveyTest < ActiveSupport::TestCase
  setup do
    @survey = Fabricate(:survey)
  end

  test 'create' do
    assert_difference 'Survey.count' do
      @survey = Survey.create do |survey|
        Fabricate.attributes_for(:survey).each do |attr, value|
          survey.send "#{attr}=", value
        end
      end
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Survey.count' do
        assert @survey.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @survey.reload.name
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Survey.count', -1) { @survey.destroy }
    end
  end

  test 'can not create for past teach' do
    teach = Fabricate(:teach, start: 5.days.ago, finish: 2.day.ago)
    content = Fabricate(:content, teach_id: teach.id)

    assert_raise(RuntimeError) do
      survey = Fabricate.build(:survey, content_id: content.id)

      survey.save
    end
  end

  test 'validates blank attributes' do
    @survey.name = ''

    assert @survey.invalid?
    assert_equal 1, @survey.errors.size
    assert_equal [error_message_from_model(@survey, :name, :blank)],
      @survey.errors[:name]
  end

  test 'validates length of _long_ attributes' do
    @survey.name = 'abcde' * 52

    assert @survey.invalid?
    assert_equal 1, @survey.errors.count
    assert_equal [
      error_message_from_model(@survey, :name, :too_long, count: 255)
    ], @survey.errors[:name]
  end

  test 'index to csv' do
    Fabricate(:question, survey_id: @survey.id, question_type: 'list').tap do |question|
      Fabricate(:answer, question_id: question.id).tap do |answer|
        5.times {
          Fabricate(:reply, answer_id: answer.id, question_id: question.id)
        }
      end
    end

    CSV.parse(Survey.to_csv(@survey.teach)).tap do |result|
      assert_equal @survey.teach.contents.count, result.size
    end
  end

  test 'show to csv' do
    Fabricate(:question, survey_id: @survey.id, question_type: 'list').tap do |question|
      Fabricate(:answer, question_id: question.id).tap do |answer|
        5.times {
          Fabricate(:reply, answer_id: answer.id, question_id: question.id)
        }
      end
    end

    CSV.parse(@survey.to_csv).tap do |result|
      assert_equal 2 + @survey.questions.count + @survey.answers.count, result.size
    end
  end
end
