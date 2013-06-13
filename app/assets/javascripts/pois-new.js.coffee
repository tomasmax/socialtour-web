map = null
marker = null
elevator = null

# Map coordinates

coordinates = []
path = null
routePointIndex = 0

$ ->
  # A function to create the marker and set up the event window function 
  createMarker = (latlng, name, html) ->
    contentString = html
    marker = new google.maps.Marker(
      position: latlng
      map: map
      zIndex: Math.round(latlng.lat() * -100000) << 5
    )
    google.maps.event.addListener marker, "click", ->
      infowindow.setContent contentString
      infowindow.open map, marker

    google.maps.event.trigger marker, "click"
    marker
  
  drawRoute = ->
    path.setMap null if path
    path = new google.maps.Polyline(
      path: coordinates
      strokeColor: "#FF0000"
      strokeOpacity: 0.45
      strokeWeight: 3
    )
    path.setMap map
    
  poiTypeChanged = ->
    path.setMap null  if path
    marker.setMap null  if marker
    coordinates = []
    routePointIndex = 0
    
  infowindow = new google.maps.InfoWindow(size: new google.maps.Size(150, 50))
  
  options =
    zoom: 11
    center: new google.maps.LatLng(43.256, -2.924)
    mapTypeControl: true
    mapTypeControlOptions:
      style: google.maps.MapTypeControlStyle.DROPDOWN_MENU

    navigationControl: true
    mapTypeId: google.maps.MapTypeId.HYBRID

  # create the map
  map = new google.maps.Map(document.getElementById("map-canvas"), options)
  elevator = new google.maps.ElevationService()
  google.maps.event.addListener map, "click", (event) ->
    infowindow.close()  if infowindow
    if routePointIndex is 0
      $("#poi-latitude").val event.latLng.lat()
      $("#poi-longitude").val event.latLng.lng()
      if marker
        marker.setMap null
        marker = null
      markerTitle = $("input#poi_title").val()
      marker = createMarker(event.latLng, "name")
    coordinates.push event.latLng
    drawRoute()
    $("#route-points").append("\
    <div class=\"route-point\" data-index=\"#{routePointIndex}\">\
      <input type=\"hidden\" name=\"poi[route_points_list][#{routePointIndex}][latitude]\" value=\"#{event.latLng.lat()}\">\
      <input type=\"hidden\" name=\"poi[route_points_list][#{routePointIndex}][longitude]\" value=\"#{event.latLng.lng()}\">\
    </div>")
    idx = routePointIndex
    elevator.getElevationForLocations
      locations: [event.latLng]
    , (results, status) ->
      if status is google.maps.ElevationStatus.OK and results[0]
      	$(".route-point[data-index=\"#{idx}\"]").append "<input type=\"hidden\" name=\"poi[route_points_list][#{idx}][elevation]\" value=\"#{results[0].elevation}\">" 

    routePointIndex++

  $("a#new-map-undo").click ->
    routePointIndex--
    $("div#route-points[data-index=\"" + routePointIndex + "\"]").remove()
    coordinates.pop()
    drawRoute()
    false