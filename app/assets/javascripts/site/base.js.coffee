window.whenReady = (callback) ->
  $(document).ready callback

whenReady ->
  $('a[href*=#]:not([href=#])').smoothScroll
    easing: 'swing'
    speed: 400

  $('[data-toggle="tooltip"]').tooltip()