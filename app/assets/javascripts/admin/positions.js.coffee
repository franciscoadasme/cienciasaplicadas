whenReady ->
  KEYCODE_ESC = 27

  enableButton = (button) ->
    button.html(button.data('originalContent'))
          .removeClass('disabled')

  disableButton = (button) ->
    button.data('originalContent', button.html()) unless button.data('originalContent')
    button.html(button.data('disableContent'))
          .addClass('disabled')

  cancelEditAction = (button, cell, input) ->
    cell.html input.data('originalValue')
    enableButton button

  cancelNewAction = (button, wrapper) ->
    wrapper.empty()
    button.appendTo wrapper

  new_action_button = $('.position[data-action="new"]')
  new_action_button
    .on 'ajax:complete', (evt, data, status, xhr) ->
      wrapper = $(@).parent()

      new_action_button.detach()
      wrapper.html data.responseText
      wrapper.find('.form-control')
        .on 'focusout', ->
          cancelNewAction(new_action_button, wrapper)
        .on 'keyup', (e) ->
          cancelNewAction(new_action_button, wrapper) if e.which == KEYCODE_ESC
        .focus()

  $('.position [data-action="edit"]')
    .on 'ajax:beforeSend', (evt, data, status, xhr) ->
      disableButton $(@)
    .on 'ajax:complete', (evt, data, status, xhr) ->
      button = $(@)

      row = button.closest('tr')
      editable_cell = row.find('.editable')
      editable_cell.html(data.responseText)

      input = editable_cell.find('input#position_name')
      input.data 'originalValue', input.val()
      input.focus()
           .on 'keyup', (e) ->
             cancelEditAction(button, editable_cell, input) if e.which == KEYCODE_ESC
           .on 'focusout', ->
             cancelEditAction button, editable_cell, input

