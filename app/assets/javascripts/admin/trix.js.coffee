# Produce well-formed HMTL for trix editor content (replace div and br with p)
paragraphify = (content) ->
  content = content.replace /&nbsp;/g, ""
  content = content.replace /(<br><br>)(<\/[a-z]+>)/g, "$2$1"
  content = content.replace /(<[a-z]+>)(<br><br>)/g, "$2$1"
  content = content.replace /<br><br>(<h\d>)/g, "$1"
  content = content.replace /<br>(<\/[a-z]+>)/g, "$1"
  content = content.replace /<\/?div>/g, ""
  content = content.replace /(<br>)+(<(?:ul)>)/, "$2"
  content = content.replace /(ul|ol)>(<br>)+/g, "$1>"
  content = content.replace /(<br>)+$/, ""

  content = "<p>" + content.split(/ *<br><br> */).join("</p><p>") + "</p>"
  content = content.replace /<h\d>/g, "</p>$&"
  content = content.replace /<\/h\d>/g, "$&<p>"
  content = content.replace /<(ul|ol)>/g, "</p><$1>"
  content = content.replace /<\/(ul|ol)><\/p>/g, "</$1>"
  content = content.replace /(ul|ol)>([a-z])/gi, "$1><p>$2"
  content = content.replace /<p><\/p>/g, ""


# Set custom toolbar buttons
Trix.config.blockAttributes.heading1.tagName = "h2"
Trix.config.blockAttributes.heading2 =
  tagName: "h3"
  terminal: true
  breakOnReturn: true
  group: false

groupElement = Trix.config.toolbar.content.querySelector(".heading-1")
groupElement.innerHTML = "H2"
groupElement.classList.remove("icon")

buttonHTML = "<button type=\"button\" class=\"heading-2\" data-trix-attribute=\"heading2\" title=\"Subheading\">H3</button>"
groupElement.insertAdjacentHTML("afterend", buttonHTML)

# Add hooks when loading and submitting content from trix editor
$ ->
  element = document.querySelector "trix-editor"
  return unless element

  # Ensure well-formed HTML before submitting form
  form = element.closest "form"
  target = form.querySelector "input##{element.attributes["input"].value}"
  form.addEventListener "submit", (event) ->
    target.value = paragraphify element.value
