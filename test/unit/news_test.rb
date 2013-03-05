require 'test_helper'

class NewsTest < ActiveSupport::TestCase
  def setup
    @news = Fabricate(:news)
    @institution = @news.institution
  end

  test 'create' do
    assert_difference 'News.count' do
      @news = News.create do |news|
        Fabricate.attributes_for(:news).each do |attr, value|
          news.send "#{attr}=", value
        end
      end
    end
  end

  test 'create with tags' do
    assert_difference ['News.count','Tagging.count','Tag.count'] do
      @news = @institution.news.build(
        (
          Fabricate.attributes_for(:news, institution_id: nil).slice(
            *News.accessible_attributes
          )
        ).merge(
          taggings_attributes: {
            tagging_1: { 
              tag_attributes: (
                Fabricate.attributes_for(:tag, institution_id: nil).slice(
                  *Tag.accessible_attributes
                )
              )
            }
          }
        )
      )

      @news.save
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
    @news.published_at = nil

    assert @news.invalid?
    assert_equal 2, @news.errors.size
    assert_equal [error_message_from_model(@news, :title, :blank)],
      @news.errors[:title]
    assert_equal [error_message_from_model(@news, :published_at, :blank)],
      @news.errors[:published_at]
  end
    
  test 'validates length of _long_ attributes' do
    @news.title = 'abcde' * 52

    assert @news.invalid?
    assert_equal 1, @news.errors.count
    assert_equal [
      error_message_from_model(@news, :title, :too_long, count: 255)
    ], @news.errors[:title]
  end

  test 'validates well formated attributes' do
    @news.published_at = '13/13/13 25:61:61'

    assert @news.invalid?
    assert_equal 2, @news.errors.size
    assert_equal [
      error_message_from_model(@news, :published_at, :blank),
      I18n.t('errors.messages.invalid_datetime')
    ].sort, @news.errors[:published_at].sort
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
