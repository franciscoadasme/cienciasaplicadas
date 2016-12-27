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

# Force heading 2 instead of h1 in the trix editor toolbar
# (h1 is reserved for page title, so content headings start at h2)
$(document).on 'trix-initialize', ->
  Trix.config.blockAttributes.heading1 = { tagName: 'h2' };
