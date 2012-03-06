class ApplicationModel < ActiveRecord::Base
  self.abstract_class = true
  
  def self.magick_search(query)
    columns = self.respond_to?(:magick_columns) ? self.magick_columns : []
    or_queries = []
    terms = {}
    
    extract_magick_query_terms(query).each_with_index do |or_term, i|
      and_queries = []
      
      or_term.each_with_index do |and_term, j|
        mini_query = []
        
        columns.each_with_index do |column, k|
          if and_term =~ column[:condition]
            operator = map_magick_column_operator(column[:operator])
            terms[:"t_#{i}_#{j}_#{k}"] = column[:mask] % { t: and_term }
            
            mini_query << "#{column[:field]} #{operator} :t_#{i}_#{j}_#{k}"
          end
        end
        
        and_queries << mini_query.join(' OR ')
      end
      
      or_queries << and_queries.map { |a_q| "(#{a_q})" }.join(' AND ')
    end
    
    where(or_queries.map { |o_q| "(#{o_q})" }.join(' OR '), terms)
  end
  
  private
  
  def self.extract_magick_query_terms(query)
    ands = Regexp.quote("#{I18n.t('query.and')}")
    ors = Regexp.quote("#{I18n.t('query.or')}")
    clean_query = query.strip
      .gsub(%r{\A\s*(#{ands})\s+}, '')
      .gsub(%r{\s+(#{ands})\s*\z}, '')
      .gsub(%r{\A\s*(#{ors})\s+}, '')
      .gsub(%r{\s+(#{ors})\s*\z}, '')
    or_terms = []
    
    clean_query.split(%r{\s+(#{ors})\s+}).each do |or_term|
      or_terms << or_term.split(%r{\s+(#{ands})\s+|\s+}).reject do |t|
        t =~ %r{\A(#{ands})\z} || t =~ %r{\A(#{ors})\z}
      end
    end
    
    or_terms.reject(&:empty?)
  end
  
  def self.map_magick_column_operator(operator)
    operator == :like ?
      (DB_ADAPTER == 'PostgreSQL' ? 'ILIKE' : 'LIKE') : operator
  end
end