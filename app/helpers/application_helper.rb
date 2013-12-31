module ApplicationHelper
  def flash_class(level)
    case level
    when :notice then 'alert-info'
    when :alert then 'alert-warning'
    when :success then 'alert-success'
    when :error then 'alert-danger'
    end
  end

  def markdown(text, options = {})
    render_options = {
      # will remove from the output HTML tags inputted by user
      filter_html:     false,
      # will insert <br /> tags in paragraphs where are newlines
      # (ignored by default)
      hard_wrap:       true,
      # hash for extra link options, for example 'nofollow'
      link_attributes: { rel: 'nofollow' }
      # more
      # will remove <img> tags from output
      # no_images: true
      # will remove <a> tags from output
      # no_links: true
      # will remove <style> tags from output
      # no_styles: true
      # generate links for only safe protocols
      # safe_links_only: true
      # and more ... (prettify, with_toc_data, xhtml)
    }
    renderer = Redcarpet::Render::HTML.new(render_options.merge(options))

    extensions = {
      #will parse links without need of enclosing them
      autolink:           true,
      # blocks delimited with 3 ` or ~ will be considered as code block.
      # No need to indent.  You can provide language name too.
      # ```ruby
      # block of code
      # ```
      fenced_code_blocks: true,
      # will ignore standard require for empty lines surrounding HTML blocks
      lax_spacing:        true,
      # will not generate emphasis inside of words, for example no_emph_no
      no_intra_emphasis:  true,
      # will parse strikethrough from ~~, for example: ~~bad~~
      strikethrough:      true,
      # will parse superscript after ^, you can wrap superscript in ()
      superscript:        true
      # will require a space after # in defining headers
      # space_after_headers: true
    }
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end

  def parse_template(content)
    content.try :gsub, /\{\{.+\}\}/ do |match|
      sentence = match.gsub(/[{}]/, '').strip
      name, expression = sentence.strip.split '.', 2
      begin
        begin
          model = name.classify.constantize
          result = model.send (model.respond_to?(:default) ? :default : :all)
          result = eval("result.#{expression}") rescue result.map{ |i| i.send(expression) }.join(', ') unless expression.nil?
        rescue NameError
          result = eval(sentence)
        end

        if result.is_a? ActiveRecord::Relation
          begin
            render("#{result.table.name}/collection", collection: result)
          rescue ActionView::MissingTemplate
            content_tag(:p, "Missing template for collection #{name}", class: 'alert alert-warning')
          end
        else
          result
        end
      rescue NameError, SyntaxError => e
        Rails.env.development? ? raise(e) : content_tag(:p, "Expression couldn't be parsed: #{sentence}", class: 'alert alert-warning')
      end
    end
  end

# Translation
  def tt(keypath, options={}, prefix=nil)
    no_action = options.delete :no_action
    no_controller = options.delete :no_controller
    keypath = (controller_name unless no_controller).to_s + (".#{params[:action]}" unless no_action).to_s + keypath if keypath.start_with? '.'
    keypath = "#{prefix}.#{keypath}" unless prefix.blank?
    I18n.t keypath, options
  end

  def tc(keypath, options={})
    tt keypath, options, 'controllers'
  end

  def tf(keypath, options={})
    keypath = '.flash' + keypath if keypath.start_with? '.'
    tc keypath, options
  end

  def tv(keypath, options={})
    tt keypath, options, 'views'
  end

  def ts(keypath, options={})
    tt keypath, { no_controller: true, no_action: true }.merge(options), 'views._sidebar'
  end
end