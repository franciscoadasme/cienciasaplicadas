window.createStyleSheet = ->
  style = document.createElement 'style'
  style.appendChild document.createTextNode('')
  document.head.appendChild style
  return style.sheet
