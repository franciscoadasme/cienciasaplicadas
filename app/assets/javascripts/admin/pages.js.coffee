whenReady ->
  $('.list-group-pages.sortable').sortable
    axis: 'y'
    update: ->
      $.post($(@).data('update-url'), $(@).sortable('serialize'))