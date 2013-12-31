whenReady ->
  settings_update_nickname_by_provider = $('#settings_update_nickname_by_provider')
  settings_update_nickname_by_provider_wrapper = settings_update_nickname_by_provider.closest('.input')
  settings_update_image_by_provider = $('#settings_update_image_by_provider')
  settings_update_image_by_provider_wrapper = settings_update_image_by_provider.closest('.input')

  $('#settings_update_attributes_by_provider').on 'change', ->
    checked = $(@).prop('checked')
    settings_update_nickname_by_provider.prop('disabled', !checked)
    settings_update_nickname_by_provider_wrapper.toggleClass('disabled')

    settings_update_image_by_provider.prop('disabled', !checked)
    settings_update_image_by_provider_wrapper.toggleClass('disabled')

    if !checked
      settings_update_nickname_by_provider.prop('checked', checked)
      settings_update_image_by_provider.prop('checked', checked)