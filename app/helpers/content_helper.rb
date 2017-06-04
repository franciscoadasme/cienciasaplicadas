# Methods to deal with user-created content (e.g., posts, pages)
module ContentHelper
  def paragraphify(content)
    content = content.gsub(/div>/, 'p>') # change <div> by <p>
                     .split(/\s*<br><br>\s*/)
                     .map { |text| content_tag(:p, text, nil, false) }
                     .join('')
    ensure_well_formed_html content
  end

  private

  def ensure_well_formed_html(content)
    Nokogiri::HTML.fragment(content).to_s.tap do |html|
      html.gsub! %r{<p>(<br>)?</p>}, '' # remove empty paragraphs
      html.gsub! %r{<br>\s*</p>}, '</p>' # remove newline from paragraph
    end
  end
end
