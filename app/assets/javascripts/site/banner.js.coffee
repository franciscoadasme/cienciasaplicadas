$(document).ready ->
  banner_node = document.querySelector '*[data-banner-url]'
  if banner_node
    image_url = banner_node.dataset.bannerUrl
    banner_node.removeAttribute 'data-banner-url'

    document.querySelector('section[role="main"]').classList.add 'banner'
    sheet = createStyleSheet()
    sheet.addRule ".banner::before", "background-image: url(#{image_url});", 0
