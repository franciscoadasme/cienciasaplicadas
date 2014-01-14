# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

whenReady ->
  $contact_list = $('.list-group-contacts')
  $contact_container = $('.panel-contact')

  $('.list-group-item-contact')
    .on 'ajax:beforeSend', (evt, data, status, xhr) ->
      $contact_container.empty()
      $('<i />', class: 'fa fa-refresh fa-spin fa-2x loader-contact').appendTo $contact_container
    .on 'ajax:complete', (evt, data, status, xhr) ->
      $contact_container.html data.responseText
      $contact_list.find('.active').removeClass('active')
      $(@).addClass('active')