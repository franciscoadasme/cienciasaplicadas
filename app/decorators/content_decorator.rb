class ContentDecorator < Draper::Decorator
  # TODO: avoid this hack to ensure well-formed html
  def body
    @body ||= paragraphify(object.body)
              .gsub %r{<(/?)h1>}, '<\1h2>'
    @body.html_safe
  end

  private

  def ensure_well_formed_html(content)
    Nokogiri::HTML.fragment(content).to_s.tap do |html|
      html.gsub! %r{<p>(<br>)?</p>}, '' # remove empty paragraphs
      html.gsub! %r{<br>\s*</p>}, '</p>' # remove newline from paragraph
    end
  end

  def paragraphify(content)
    content = content.gsub(/div>/, 'p>') # change <div> by <p>
                     .split(/\s*<br><br>\s*/)
                     .map { |text| h.content_tag(:p, text, nil, false) }
                     .join('')
    ensure_well_formed_html content
  end
end
