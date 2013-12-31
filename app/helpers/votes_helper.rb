module VotesHelper
  def link_to_like(vote, *args)
    options = args.extract_options!

    options['class'] ||= 'btn btn-default btn-xs'

    text = content_tag(:span, nil, class: 'glyphicon glyphicon-circle-arrow-up')
    link_text = text + " #{t('label.like')} (#{vote.votable.votes_count})"

    options['data-remote'] ||= true
    options['data-method'] ||= 'post'

    link_path = polymorphic_path([vote.votable, vote])

    link_to link_text, link_path, options
  end

  def link_to_dislike(vote, *args)
    options = args.extract_options!

    options[:class] ||= 'btn btn-success btn-xs'

    text = content_tag(:span, nil, class: 'glyphicon glyphicon-circle-arrow-down')
    link_text = text + " #{t('label.like')} (#{vote.votable.votes_count})"

    options['data-remote'] ||= true
    options['data-method'] ||= 'delete'
    options['data-original-title'] ||= t('label.dislike')

    link_path = polymorphic_path([vote.votable, vote])

    link_to link_text, link_path, options
  end
end
