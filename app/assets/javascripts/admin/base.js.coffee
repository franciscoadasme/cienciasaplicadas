$ ->
  $('body').toggleClass 'on off'

window.whenReady = (callback) ->
  $(document).ready callback
  $(document).on 'page:load', callback

$(document).on 'page:before-change', ->
  $('body').toggleClass 'on off'
  $('.loader').removeClass 'hidden'
.on 'page:change', ->
  setTimeout ->
    $('body').toggleClass 'on off'
    $('.loader').addClass 'hidden'
  , 50