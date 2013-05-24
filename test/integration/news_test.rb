# encoding: utf-8

require 'test_helper'

class NewsTest < ActionDispatch::IntegrationTest
  include Integration::Login

  setup do
    @institution = Fabricate(:institution)
    @news = Fabricate.build(:news, institution_id: @institution.id)

    login_into_institution institution: @institution, as: 'janitor'
  end

  test 'should create a news' do
    visit new_news_path

    fill_in 'news_title', with: @news.title
    fill_in 'news_description', with: @news.description
    fill_in 'news_body', with: @news.body

    assert_difference 'News.count' do
      assert page.has_no_css?('.page-header h2.text-info')
      
      find('.btn.btn-primary').click

      assert page.has_css?('.page-header h2.text-info')
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

    fill_in 'news_title', with: @news.title
    fill_in 'news_description', with: @news.description
    fill_in 'news_body', with: @news.body
      
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
      :comment, commentable_id: news.id, commentable_type: news.class.model_name, user_id: nil
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

  test 'should paginate comments en news' do
    news = Fabricate(:news, institution_id: @institution.id)
    6.times { Fabricate(:comment, commentable_id: news.id, commentable_type: news.class.model_name) }
    
    visit news_path(news)

    assert page.has_no_css?('#comment-6')

    within '#pagination_container' do
      find('.btn').click
    end

    assert page.has_css?('#comment-6')
    assert page.has_no_css?('#pagination_container')
  end

  test 'should create and delete vote in news' do
    news = Fabricate(:news, institution_id: @institution.id)

    visit news_path(news)

    assert_difference 'news.reload.votes_count' do
      assert page.has_css?("div[id=#{news.anchor_vote}]")

      within "##{news.anchor_vote}" do
        click_link(I18n.t('label.like'))
      end

      assert page.has_css?("div[id=#{news.anchor_vote}] .btn.btn-mini.btn-success")
    end 

    assert_difference 'news.reload.votes_count', - 1 do
      within "##{news.anchor_vote}" do
        click_link(I18n.t('label.like'))
      end

      assert page.has_no_css?("div[id=#{news.anchor_vote}] .btn.btn-mini.btn-success")
    end
  end

  test 'should create news with tags' do
    news = Fabricate.build(:news)
    tag_build = Fabricate.build(:tag)
    tag_persisted = Fabricate(:tag, name: 'New tag', 
      institution_id: @institution.id, category: 'important'
    )

    visit new_news_path

    fill_in 'news_title', with: news.title
    fill_in 'news_description', with: news.description
    fill_in 'news_body', with: news.body
    
    within '#tags fieldset' do
      fill_in find('input[name$="[tag_attributes][name]"]')[:id], with: tag_build.name
    end

    assert page.has_no_css?('#tags fieldset:nth-child(2)')

    click_link I18n.t('view.news.new_tag')

    assert page.has_css?('#tags fieldset:nth-child(2)')

    within '#tags fieldset:nth-child(2)' do
      fill_in find('input[name$="[tag_attributes][name]"]')[:id], with: tag_persisted.name
    end

    assert !find('#tags fieldset:nth-child(2) input[value="important"]', visible: false).checked?

    find('.ui-autocomplete li.ui-menu-item a', visible: false).click

    assert find('#tags fieldset:nth-child(2) input[value="important"]', visible: false).checked?
 
    assert_difference ['News.count', 'Tag.count'] do
      assert_difference 'Tagging.count', 2 do
        find('.btn.btn-primary').click
      end
    end
  end

  test 'should not create duplicate tags' do
    @news.save

    tag = Fabricate(:tag, name: 'duplicate_name', institution_id: @institution.id)

    @news.taggings.create(tag_id: tag.id)
  
    visit edit_news_path(@news)

    assert page.has_css?('#tags fieldset:nth-child(3)')

    within '#tags fieldset:nth-child(3)' do
      fill_in find('input[name$="[tag_attributes][name]"]')[:id], with: tag.name
    end

    find('.ui-autocomplete li.ui-menu-item a').click

    assert_no_difference ['News.count', 'Tagging.count', 'Tag.count'] do
      find('.btn.btn-primary').click
    end

  end

  test 'should delete tags' do
    @news.save

    @news.taggings.create(
      tag_id: Fabricate(:tag, institution_id: @institution.id).id
    )

    visit edit_news_path(@news)
  
    assert page.has_css?('#tags fieldset')

    within '#tags fieldset:nth-child(1)' do
      click_link '✘' # Destroy link
    end

    assert_no_difference ['News.count', 'Tag.count'] do
      assert_difference 'Tagging.count', -1 do
        find('.btn.btn-primary').click
      end
    end
  end
end
