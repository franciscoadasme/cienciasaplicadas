# SimpleForm.setup do |config|
#   config.wrappers :input_table, tag: 'tr', error_class: 'error' do |b|
#     b.use :html5
#     b.use :placeholder
#     # b.use :label, wrap_with: { tag: 'th' }
#     b.wrapper tag: :td, class: 'main' do |ba|
#       ba.use :input
#       ba.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
#       ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
#     end
#   end

#   config.form_class = 'form-table'
#   config.browser_validations = true
#   config.default_wrapper = :input_table
# end