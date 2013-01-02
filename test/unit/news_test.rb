require 'test_helper'

class NewsTest < ActiveSupport::TestCase
  def setup
    @news = Fabricate(:news)
    @institution = @news.institution
  end

  test 'create' do
    assert_difference 'News.count' do
      @news = News.create(Fabricate.attributes_for(:news))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'News.count' do
        assert @news.update_attributes(title: 'Updated')
      end
    end

    assert_equal 'Updated', @news.reload.title
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('News.count', -1) { @news.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @news.title = ''
    @news.institution_id = nil

    assert @news.invalid?
    assert_equal 2, @news.errors.size
    assert_equal [error_message_from_model(@news, :title, :blank)],
      @news.errors[:title]
    assert_equal [error_message_from_model(@news, :institution_id, :blank)],
      @news.errors[:institution_id]
  end
    
  test 'validates length of _long_ attributes' do
    @news.title = 'abcde' * 52

    assert @news.invalid?
    assert_equal 1, @news.errors.count
    assert_equal [
      error_message_from_model(@news, :title, :too_long, count: 255)
    ], @news.errors[:title]
  end

  test 'magick search' do
    5.times do
      Fabricate(:news) { title { "magick_title #{sequence(:news_title)}" } }
    end

    news = News.magick_search('magick')

    assert_equal 5, news.count
    assert news.all? { |s| s.to_s =~ /magick/ }

    news = News.magick_search('noplace')

    assert news.empty?
  end
end
