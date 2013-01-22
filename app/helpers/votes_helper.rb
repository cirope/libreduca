module VotesHelper
  def link_to_like(vote, *args)
    options = args.extract_options!

    options['class'] ||= 'btn btn-mini text-success'
    options['disabled'] ||= vote.vote_flag

    text = content_tag(:span, '&#xe014'.html_safe, class: 'iconic')
    link_text = text + ' ' + t('label.like') + ' ' + "(#{vote.votable.votes_positives_count})"

    if vote.vote_flag
      content_tag(:span, link_text, options)
    else
      options['data-remote'] ||= true
      options['data-method'] ||= vote.new_record? ? 'post' : 'put'

      link_path = polymorphic_path([vote.votable, vote], vote_flag: 'positive')

      link_to link_text, link_path, options
    end
  end

  def link_to_dislike(vote, *args)
    options = args.extract_options!

    options[:class] ||= 'btn btn-mini text-error'
    options['disabled'] ||= !vote.vote_flag if vote.persisted?

    text = content_tag(:span, '&#xe016'.html_safe, class: 'iconic')
    link_text = text + ' ' + t('label.dislike') + ' ' + "(#{vote.votable.votes_negatives_count})"

    if vote.vote_flag == false
      content_tag(:span, link_text, options) 
    else
      options['data-remote'] ||= true
      options['data-method'] ||= vote.new_record? ? 'post' : 'put'

      link_path = polymorphic_path([vote.votable, vote], vote_flag: 'negative')

      link_to link_text, link_path, options
    end
  end
end
