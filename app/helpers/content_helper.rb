module ContentHelper
  def parse_content(content)
    markdown parse_inline_code(content)
  end

  def parse_inline_code(content)
    content.gsub /\{\{.+\}\}/ do |match|
      sentence = match.delete('{}').strip

      begin
        case
        when sentence =~ /\A\w+\./
          name, expression = sentence.split '.', 2
          model = name.tclassify_and_constantize
          result = model.send (model.respond_to?(:default) ? :default : :all)
          result = eval("result.#{expression}") unless expression.blank?
        when sentence =~ /\A\w+[ \(].+/
          name, condition = sentence.split /[ \(]/, 2
          model = name.tclassify_and_constantize
          result = model.send :named, condition.delete(':()\'\'""')
        else
          result = eval(sentence)
        end

        if result.is_a? ActiveRecord::Relation
          begin
            render "#{result.table.name}/collection", collection: result
          rescue ActionView::MissingTemplate
            content_tag(:p, "Missing template for collection #{name}", class: 'alert alert-warning')
          end
        else
          result
        end
      rescue SyntaxError => error
        display_error error, sentence, 'Parece que hubo un error de sintaxis en el código'
      rescue NoMethodError => error
        display_error error, sentence, 'Al parecer escribió mal el nombre de un método'
      rescue NameError => error
        display_error error, sentence, 'Al parecer escribió mal el nombre de la entidad'
      end
    end
  end

  private
    def display_error(error, sentence, description = nil)
      if !Rails.env.development?
        raise error
      else
        content_tag :div, class: 'alert alert-warning' do
          case
          when description.present?
            message = [ content_tag(:strong, 'Oops!') ]
            message << "#{description}."
            message << 'Favor revisar el código a continuación:'
            concat content_tag(:p, message.join(' ').html_safe)
            concat content_tag(:code, sentence)
          else error.to_s
          end
        end
      end
    end
end