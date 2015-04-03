class PagedownInput < SimpleForm::Inputs::TextInput
  def input
    out = "<div id=\"wmd-button-bar-#{attribute_name}\"></div>\n"
    css = 'text required form-control monospaced wmd-input'
    options = input_html_options.merge(class: css,
                                       id: "wmd-input-#{attribute_name}")
    out << @builder.text_area(attribute_name, options)
    if input_html_options[:preview]
      out << "<div id=\"wmd-preview-#{attribute_name}\" class=\"wmd-preview\"></div>"
    end
    out.html_safe
  end
end
