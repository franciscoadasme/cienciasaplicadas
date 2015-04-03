$ ->
  $('textarea.wmd-input').autosize()
  .each (i, input) ->
    attr = $(input).attr('id').split('wmd-input')[1]
    converter = new Markdown.Converter()
    Markdown.Extra.init(converter)
    help =
      handler: () ->
        window.open('https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet')
        return false
      title: "<%= I18n.t('components.markdown_editor.help', default: 'Markdown Editing Help') %>"
    editor = new Markdown.Editor(converter, attr, help)
    editor.run()
  .on 'focus', (e) ->
    $(@).trigger 'resize'
  .focusout (e) ->
    $(@).trigger 'resize'
