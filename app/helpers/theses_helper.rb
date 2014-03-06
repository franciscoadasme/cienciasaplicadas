module ThesesHelper
  def human_keywords_param_name 
    :'palabras-claves'
  end

  def keywords_param
    params[human_keywords_param_name] || []
  end

  def params_has_keyword?(keyword)
    keywords_param.include? keyword.parameterize
  end

  def params_with_keyword(keyword, override: false)
    keyword = keyword.parameterize
    keywords = case
      when override 
        [ keyword ]
      when params_has_keyword?(keyword)
        keywords_param.reject { |kw| kw == keyword }
      else
        keywords_param.dup.push(keyword)
    end
    params.merge human_keywords_param_name => keywords.empty? ? nil : keywords
  end
end
