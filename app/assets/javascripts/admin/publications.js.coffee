whenReady ->
  if window.File && window.FileReader && window.FileList && window.Blob
    import_btn = $('.btn-publication-import')
    fileSelector = $('<input type="file" accept="" multiple />')

    submitResult = (result) ->
      $('#ris_content').val result
      $('#form-publication-import').submit()

    fileSelector.on 'change', (e) ->
      if @.files
        invalid_files = (item for item in @.files when item.name.indexOf('.ris') == -1)
        if invalid_files.length
          alert "One or more files aren't RIS files."
          return false

        result = []
        total = @.files.length
        for file in @.files
          reader = new FileReader()
          reader.onload = (f) ->
            contents = f.target.result
            result.push contents

            if result.length >= total
              submitResult result.join('')

          reader.readAsText file
      else
        alert 'Failed to load files.'

    import_btn.on 'click', (e) ->
      e.preventDefault()
      fileSelector.click()

  setupAndShowAuthorListPopover =  (target, content) ->
    target.addClass('with-popover')
    .popover
      html: true
      title: 'Authors'
      content: content
      width: 300
    .popover('show')

  $('.author_item_more')
    .on 'ajax:beforeSend', (evt, data, status, xhr) ->
      $self = $(@)
      if $self.hasClass('with-popover')
        $self.popover('destroy').removeClass('with-popover')
        return false
    .on 'ajax:complete', (evt, data, status, xhr) ->
      $(@).removeClass('disabled')
      setupAndShowAuthorListPopover $(@), data.responseText