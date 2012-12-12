require 'test_helper'

class PresentationTest < ActiveSupport::TestCase
  def setup
    @presentation = Fabricate(:presentation)
  end

  test 'create' do
    user = Fabricate(:user)

    assert_difference 'Presentation.count' do
      @presentation = user.presentations.build(
        Fabricate.attributes_for(:presentation).slice(
          *Presentation.accessible_attributes
        )
      )

      @presentation.homework = Fabricate(:homework)

      assert @presentation.save
    end 
  end
    
  test 'update' do
    # Readonly attributes
    assert_no_difference 'Presentation.count' do
      @presentation.homework_id = 0

      assert @presentation.save
    end

    assert_not_equal 0, @presentation.reload.homework_id
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Presentation.count', -1) { @presentation.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @presentation.remove_file!
    
    assert @presentation.invalid?
    assert_equal 1, @presentation.errors.size
    assert_equal [error_message_from_model(@presentation, :file, :blank)],
      @presentation.errors[:file]
  end
  
  test 'validates unique attributes' do
    new_presentation = Fabricate(:presentation)

    @presentation.homework_id = new_presentation.homework_id
    @presentation.user_id = new_presentation.user_id
    
    assert @presentation.invalid?
    assert_equal 1, @presentation.errors.size
    assert_equal [
      error_message_from_model(@presentation, :homework_id, :taken)
    ], @presentation.errors[:homework_id]
  end

end
