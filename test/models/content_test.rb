require 'test_helper'

class ContentTest < ActiveSupport::TestCase
  setup do
    @content = Fabricate(:content)
    @teach = @content.teach
  end

  test 'create' do
    counts = [
      'Content.count',
      "PaperTrail::Version.where(item_type: 'Content').count",
      '@teach.contents.count'
    ]

    assert_difference counts do
      @content = @teach.contents.create(
        Fabricate.attributes_for(:content)
      )
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Content.count' do
        assert @content.update(title: 'Updated')
      end
    end

    assert_equal 'Updated', @content.reload.title
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Content.count', -1) { @content.destroy }
    end
  end

  test 'validates blank attributes' do
    @content.title = ''
    @content.teach_id = nil

    assert @content.invalid?
    assert_equal 2, @content.errors.size
    assert_equal [error_message_from_model(@content, :title, :blank)],
      @content.errors[:title]
    assert_equal [error_message_from_model(@content, :teach_id, :blank)],
      @content.errors[:teach_id]
  end

  test 'validates length of _long_ attributes' do
    @content.title = 'abcde' * 52

    assert @content.invalid?
    assert_equal 1, @content.errors.count
    assert_equal [
      error_message_from_model(@content, :title, :too_long, count: 255)
    ], @content.errors[:title]
  end

  test 'visited by' do
    user = Fabricate(:user)

    assert !@content.visited_by?(user)

    assert_difference '@content.visits.count' do
      assert @content.visited_by(user)
    end

    assert @content.reload.visited_by?(user)

    # If there is a visit, then no visit is created =)
    assert_no_difference '@content.visits.count' do
      assert !@content.visited_by(user)
    end
  end

  test 'magick search' do
    5.times do
      Fabricate(:content) {
        title { "magick_title #{sequence(:content_name)}" }
      }
    end

    contents = Content.magick_search('magick')

    assert_equal 5, contents.count
    assert contents.all? { |s| s.to_s =~ /magick/ }

    contents = Content.magick_search('noplace')

    assert contents.empty?
  end

  test 'next and prev for' do
    Content.destroy_all

    assert_equal 0, Content.count

    content = Fabricate(:content, title: 'B')
    prev_content = Fabricate(:content, title: 'A')
    next_content = Fabricate(:content, title: 'C')

    assert_equal prev_content.id, Content.prev_for(content).id
    assert_equal next_content.id, Content.next_for(content).id
    assert_nil Content.next_for(next_content)
    assert_nil Content.prev_for(prev_content)
  end
end
