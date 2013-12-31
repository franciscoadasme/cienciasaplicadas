window.whenReady = (callback) ->
  $(document).ready callback
  $(document).on 'page:load', callback

whenReady ->
  $('a[href*=#]:not([href=#])').smoothScroll
    easing: 'swing'
    speed: 400

  sidebar = $('.sidebar-fixed')
  if sidebar.length
    $('a:not([href*=#])').on 'click', (e) ->
      current = location.pathname.match(/\/(users|posts)\//i)
      href = $(@).attr('href').match(/\/(users|posts)\//i)
      if current && (!href || current[1] != href[1])
        sidebar.addClass 'fadein'
        $('.gr-nav').addClass 'fadein'

# Yummi loader
$ ->
  $('body, html').removeClass('off').addClass('on')

$(document).on 'page:before-change', ->
  $('body, html').removeClass('on').addClass('off')
.on 'page:fetch', ->
  $.smoothScroll 0
.on 'page:change', ->
  setTimeout ->
    $('body, html').removeClass('off').addClass('on')
  , 50