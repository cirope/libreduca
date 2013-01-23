# encoding: utf-8

require 'test_helper'

class NewsTest < ActionDispatch::IntegrationTest

  setup do
    @institution = Fabricate(:institution)
    @news = Fabricate.build(:news, institution_id: @institution.id)

    login_into_institution institution: @institution, as: 'janitor'
  end

  test 'should create news without images' do
    visit new_news_path

    fill_in 'news_title', with: @news.title
    fill_in 'news_description', with: @news.description
    fill_in 'news_body', with: @news.body

    assert_difference 'News.count' do
      assert page.has_no_css?('.page-header h1.text-info')
      
      find('.btn.btn-primary').click

      assert page.has_css?('.page-header h1.text-info')
    end
  end

  test 'should create news with images' do
    image_attributes = Fabricate.attributes_for(:image, raw_file_path: true)

    visit new_news_path

    fill_in 'news_title', with: @news.title
    fill_in 'news_description', with: @news.description
    fill_in 'news_body', with: @news.body

    assert_difference 'News.count' do
      assert page.has_no_css?('form[id=new_image]')
      
      find('#new_image_btn').click

      assert page.has_css?('form[id=new_image]')
    end

    assert_difference 'Image.count' do
      assert page.has_no_css?('div[id^=image]')

      within '#new_image' do
        fill_in 'image_name', with: image_attributes['name']
        attach_file 'image_file', image_attributes['file']
      end

      assert page.has_css?('div[id^=image]')
    end
  end

  test 'should delete images in news' do
    image_attributes = Fabricate.attributes_for(:image, raw_file_path: true)

    visit new_news_path

    fill_in News.human_attribute_name('title'), with: @news.title
    fill_in News.human_attribute_name('description'), with: @news.description
    fill_in News.human_attribute_name('body'), with: @news.body
      
    find('#new_image_btn').click

    assert_difference 'Image.count' do
      assert page.has_no_css?('div[id^=image]')

      within '#new_image' do
        fill_in 'image_name', with: image_attributes['name']
        attach_file 'image_file', image_attributes['file']
      end

      assert page.has_css?('div[id^=image]')
    end

    assert_no_difference 'News.count' do
      assert_difference 'Image.count', -1 do 

        within 'div[id^=image]' do
          click_link ''
      
          page.driver.browser.switch_to.alert.accept
        end

        assert page.has_no_css?('div[id^=image]')
      end
    end
  end

  test 'should create a comment in news' do
    news = Fabricate(:news, institution_id: @institution.id)
    comment = Fabricate.build(
      :comment, commentable_id: news.id, commentable_type: 'News', user_id: nil
    )

    visit news_path(news)

    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      assert_difference 'news.comments.count' do
        assert page.has_no_css?("div[id^=#{comment.anchor}]")

        within '#new_comment' do
          fill_in 'comment_comment', with: comment.comment

          find('.btn').click
        end

        assert page.has_css?("div[id^=#{comment.anchor}]")
      end
    end
  end

  test 'should create a vote in news' do
    news = Fabricate(:news, institution_id: @institution.id)

    visit news_path(news)

    assert_difference 'news.votes.positives.count' do
      assert page.has_css?("div[id=#{news.anchor_vote}]")

      within "##{news.anchor_vote}" do
        click_link(I18n.t('label.like'))
      end

      assert page.has_css?("div[id=#{news.anchor_vote}] span.btn.btn-mini.text-success")
    end 
  end
end
