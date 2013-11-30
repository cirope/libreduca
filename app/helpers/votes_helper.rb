module VotesHelper
  def link_to_like(vote, *args)
    options = args.extract_options!

    options['class'] ||= 'btn btn-mini'

    text = content_tag(:span, '&#xe014;'.html_safe, class: 'iconic')
    link_text = text + " #{t('label.like')} (#{vote.votable.votes_count})"

    options['data-remote'] ||= true
    options['data-method'] ||= 'post'

    link_path = polymorphic_path([vote.votable, vote])

    link_to link_text, link_path, options
  end

  def link_to_dislike(vote, *args)
    options = args.extract_options!

    options[:class] ||= 'btn btn-mini btn-success'

    text = content_tag(:span, '&#xe014;'.html_safe, class: 'iconic')
    link_text = text + " #{t('label.like')} (#{vote.votable.votes_count})"

    options['data-remote'] ||= true
    options['data-method'] ||= 'delete'
    options['data-original-title'] ||= t('label.dislike')

    link_path = polymorphic_path([vote.votable, vote])

    link_to link_text, link_path, options
  end
end
