whenReady ->
# Recipient popover
  disableButton = (button) ->
    button.data 'originalContent', button.html()

    button.addClass('disabled')
      .css(width: button.outerWidth())
      .empty()

    $('<i />', class: 'fa fa-spinner fa-spin').appendTo button

  restoreButton = (button, enable = true) ->
    button.html(button.data('originalContent'))
      .css(width: 'auto')
    button.removeClass('disabled') if enable

  setupAndShowRecipientPopover = (target, content) ->
    target.popover
      title: 'Add Recipients'
      content: content
      html: true
      container: 'body'
    .popover('show')

    # setup close button
    $('.mailing-list[data-action="cancel"]').on 'click', (e) ->
      e.preventDefault()
      target.popover('destroy').removeClass('disabled')

    # setup select2 tags plus set correct input size
    input = $('#mailing_list_member_address')
    input.select2 tags: input.data('addresses')

    $choices = $('.select2-choices')
    $choices.css 'min-height', '150px'
    $choices.css 'width', '244px'
    $choices.click()

  $('.mailing-list[data-action="add_member"]')
    .on 'ajax:beforeSend', (evt, data, status, xhr) ->
      disableButton $(@)
    .on 'ajax:complete', (evt, data, status, xhr) ->
      restoreButton $(@), false
      setupAndShowRecipientPopover $(@), data.responseText

# Mailing list form
  $mailing_list_address = $("#mailing_list_address")
  $mailing_list_address.data 'originalValue', $mailing_list_address.attr('placeholder')
  $mailing_list_address.on "click keyup", ->
    $self = $(@)
    value = $self.val()
    suffix = $mailing_list_address.data 'originalValue'
    output = value.substring(0, value.length - suffix.length) + suffix
    cursorPosition = output.length - suffix.length;
    $self.val(output);
    $self[0].selectionStart = $self[0].selectionEnd = cursorPosition;