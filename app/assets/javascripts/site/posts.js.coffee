whenReady ->
  if $('.sidebar-nav').length && $('#sidebar-active').length
    $('.sidebar-nav').scrollTop $('#sidebar-active').parent().position().top