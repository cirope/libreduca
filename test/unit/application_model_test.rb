require 'test_helper'

# Clase para probar el modelo "ApplicationModel"
class ApplicationModelTest < ActiveSupport::TestCase
  test 'extract magick query terms' do
    terms = ApplicationModel.send(:extract_magick_query_terms, 'a b')
    assert_equal [['a', 'b']], terms
    
    terms = ApplicationModel.send(:extract_magick_query_terms,
      "a #{I18n.t('query.or')} b"
    )
    assert_equal [['a'], ['b']], terms
    
    terms = ApplicationModel.send(:extract_magick_query_terms, 'long_abc')
    assert_equal [['long_abc']], terms
    
    terms = ApplicationModel.send(:extract_magick_query_terms, '  ')
    assert_equal [], terms
  end
  
  test 'map magick column operator' do
    Object.send :remove_const, :DB_ADAPTER
    ::DB_ADAPTER = 'PostgreSQL'
    
    operator = ApplicationModel.send(:map_magick_column_operator, '=')
    assert_equal '=', operator
    
    operator = ApplicationModel.send(:map_magick_column_operator, :like)
    assert_equal 'ILIKE', operator
    
    Object.send :remove_const, :DB_ADAPTER
    ::DB_ADAPTER = 'MySQL'
    
    operator = ApplicationModel.send(:map_magick_column_operator, :like)
    assert_equal 'LIKE', operator
  end
end