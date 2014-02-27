jQuery ->
  canvas = $('#graph_publication_per_year')
  raw_data = canvas.data 'graph'

  labels = raw_data.map (i) -> i[0]
  values = raw_data.map (i) -> i[1]
  max_value = Math.max.apply @, values

  data =
    labels: labels,
    datasets: [
      fillColor : "rgba(151,187,205,0.5)"
      strokeColor : "rgba(151,187,205,1)"
      pointColor : "rgba(151,187,205,1)"
      pointStrokeColor : "#fff"
      data: values
    ]

  options =
    scaleShowGridLines: false
    scaleOverride: true
    scaleSteps: max_value
    scaleStepWidth: 1
    scaleStartValue: 0

  ctx = canvas.get(0).getContext("2d")
  chart = new Chart(ctx).Line(data, options)