module ParsingHelper
  def extract_images_from_content(content)
    collect_image_urls markdown(content)
  end

  def markdown(text, options = {})
    render_options = {
      filter_html:     false,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow' }
    }
    renderer = Redcarpet::Render::HTML.new(render_options.merge(options))

    extensions = {
      autolink:           true,
      fenced_code_blocks: true,
      lax_spacing:        true,
      no_intra_emphasis:  true,
      strikethrough:      true,
      superscript:        true
    }
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end

  def parse_content(content)
    markdown parse_inline_code(content)
  end

  def parse_inline_code(content)
    content.gsub /\{\{.+\}\}/ do |match|
      sentence = match.delete('{}').strip

      begin
        result = case
          when sentence =~ /\A\w+\./ then eval_sentence_collection(sentence)
          when sentence =~ /\A\w+[ \(].+/ then eval_sentence_single(sentence)
          else eval(sentence)
        end
        result.present? ? render_result(result) : raise(ActiveRecord::RecordNotFound)
      rescue SyntaxError => error
        render_error error, 'Parece que hubo un error de sintaxis en el código', sentence
      rescue NoMethodError => error
        render_error error, 'Al parecer escribió mal el nombre de un método', sentence
      rescue NameError => error
        render_error error, 'Al parecer escribió mal el nombre de la entidad', sentence
      rescue ActiveRecord::RecordNotFound => error
        render_error error, 'No se encontró ningún registro en la base de datos', sentence
      end
    end
  end

  private
    def eval_sentence_collection(sentence)
      name, expression = sentence.split '.', 2
      model = name.tclassify_and_constantize
      result = model.send (model.respond_to?(:default) ? :default : :all)
      result = eval("result.#{expression}") unless expression.blank?
    end

    def eval_sentence_single(sentence)
      name, condition = sentence.split /[ \(]/, 2
      model = name.tclassify_and_constantize
      result = model.send :named, condition.delete(':()\'\'""')
    end

    def render_error(error, description = nil, sentence = nil)
      if Rails.env.development?
        raise error
      else
        content_tag :div, class: 'alert alert-warning' do
          case
          when description.present?
            message = [ content_tag(:strong, 'Oops!') ]
            message << "#{description}."
            message << 'Favor revisar el código a continuación:' unless sentence.blank?
            concat content_tag(:p, message.join(' ').html_safe)
            concat content_tag(:code, sentence) if sentence.present?
          else error.to_s
          end
        end
      end
    end

    def render_result(result)
      model_proxy = result.is_model? ? result.class : result
      table_name = model_proxy.table_name
      if result.is_a? ActiveRecord::Relation
        render "#{table_name}/collection", collection: result
      elsif result.is_model?
        model_name = model_proxy.model_name.singular
        render "#{table_name}/single", model_name.to_sym => result
      else
        result
      end
    rescue ActionView::MissingTemplate => error
      entity_name = model_proxy.model_name.human.classify
      render_error error, "No se encontró una plantilla para la entidad #{entity_name}"
    end
end