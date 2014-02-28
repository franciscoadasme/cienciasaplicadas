module FormHelper
  def has_value_for_field?(object, field)
    model_name = object.class.model_name.singular
    params.has_key?(model_name) && (object.send(field).present? || object.errors.has_key?(field))
  end

  def validation_class_for_field(object, field, feedback: true)
    if has_value_for_field?(object, field)
      css = [ object.errors.has_key?(field) ? 'has-error' : 'has-success' ]
      css << 'has-feedback' if feedback
      css.join ' '
    end
  end

  def feedback_icon_for_field(object, field)
    if has_value_for_field?(object, field)
      icon_name = object.errors.has_key?(field) ? 'times' : 'check'
      content_tag :span, fa_icon(icon_name), class: 'form-control-feedback'
    end
  end

  def error_for_field(object, field)
    content_tag :p, object.errors[field].first, class: 'help-block' if object.errors.has_key?(field)
  end
end