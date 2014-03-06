$(document).ready ->
  $('a[href*=#]:not([href=#])').smoothScroll
    easing: 'swing'
    speed: 400

  $('[data-toggle="tooltip"]').tooltip()

  sidebar = $('aside[role="sidebar"]')
  if sidebar.length && sidebar.siblings().outerHeight() - sidebar.outerHeight() > 250
    sidebar.height sidebar.siblings().outerHeight()
    sidebar.find('.container').affix
      offset:
        top: $('header[role="main"]').outerHeight()
        bottom: ->
          @.bottom = $('footer[role="main"]').outerHeight(true) + parseInt($('section[role="content"]').css('padding-bottom'), 10)