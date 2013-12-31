whenReady ->
  if $('#map').length
    handler = Gmaps.build("Google")
    handler.buildMap
      provider:
        disableDefaultUI: true
        scrollwheel: false
      internal:
        id: "map"
    , ->
      markers = handler.addMarkers([
        lat: -35.4054991
        lng: -71.63321930000001
      ])
      handler.bounds.extendWith markers
      handler.fitMapToBounds()
      handler.getMap().setZoom(7)