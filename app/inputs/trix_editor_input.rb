# Custom simple_form input for Trix editor
class TrixEditorInput < SimpleForm::Inputs::TextInput
  def input(_wrapper_options = nil)
    input_id = "#{object_name}_#{attribute_name}"

    out = ActiveSupport::SafeBuffer.new
    out << @builder.hidden_field(attribute_name.to_s)
    out << template.content_tag('trix-editor', '', input: input_id)
    out << template.content_tag(:p, class: 'help-block') do
      I18n.t 'simple_form.trix-editor'
    end
  end
end
