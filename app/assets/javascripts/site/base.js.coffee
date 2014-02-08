$(document).ready ->
  $('a[href*=#]:not([href=#])').smoothScroll
    easing: 'swing'
    speed: 400

  $('[data-toggle="tooltip"]').tooltip()