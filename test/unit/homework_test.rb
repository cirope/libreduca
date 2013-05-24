require 'test_helper'

class HomeworkTest < ActiveSupport::TestCase
  def setup
    @homework = Fabricate(:homework)
  end

  test 'create' do
    assert_difference 'Homework.count' do
      @homework = Homework.create(
        Fabricate.attributes_for(:homework).slice(
          *Homework.accessible_attributes
        )
      )
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Homework.count' do
        assert @homework.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @homework.reload.name
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Homework.count', -1) { @homework.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @homework.name = ''
    
    assert @homework.invalid?
    assert_equal 1, @homework.errors.size
    assert_equal [error_message_from_model(@homework, :name, :blank)],
      @homework.errors[:name]
  end

  test 'validates well formated attributes' do
    @homework.closing_at = '13/13/13'
    
    assert @homework.invalid?
    assert_equal 1, @homework.errors.size
    assert_equal [I18n.t('errors.messages.invalid_date')],
      @homework.errors[:closing_at].sort
  end

  test 'validates attributes boundaries' do
    @homework.closing_at = Date.yesterday
    
    assert @homework.invalid?
    assert_equal 1, @homework.errors.size
    assert_equal [
      I18n.t('errors.messages.on_or_after', restriction: I18n.l(Time.zone.today))
    ], @homework.errors[:closing_at].sort
  end

  test 'validates length of _long_ attributes' do
    @homework.name = 'abcde' * 52
    
    assert @homework.invalid?
    assert_equal 1, @homework.errors.count
    assert_equal [
      error_message_from_model(@homework, :name, :too_long, count: 255)
    ], @homework.errors[:name]
  end
end
