var map = null;
var marker = null;
var elevator = null;
// 
// Map coordinates
//
var coordinates = [];
var path;
var routePointIndex = 0;

$(function(){
  var infowindow = new google.maps.InfoWindow({ 
    size: new google.maps.Size(150,50)
  });
  
  // A function to create the marker and set up the event window function 
  function createMarker(latlng, name, html) {
    var contentString = html;
    var marker = new google.maps.Marker({
        position: latlng,
        map: map,
        zIndex: Math.round(latlng.lat()*-100000)<<5
    });
  
    google.maps.event.addListener(marker, 'click', function() {
        infowindow.setContent(contentString); 
        infowindow.open(map,marker);
    });
    google.maps.event.trigger(marker, 'click');    
    return marker;
  }
  
  // create the map
  var options = {
    zoom: 13,
    center: new google.maps.LatLng(43.213,-3.13),
    mapTypeControl: true,
    mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
    navigationControl: true,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("map-canvas"), options);
  
  elevator = new google.maps.ElevationService();
  
  google.maps.event.addListener(map, 'click', function(event) {
    if (infowindow) infowindow.close();
    
    if (routePointIndex == 0) {
      $('#poi-latitude').val(event.latLng.lat());
      $('#poi-longitude').val(event.latLng.lng());
      
      // Create marker
      if (marker) {
        marker.setMap(null);
        marker = null;
      }
      var markerTitle = $('input#poi_title').val();
      
      marker = createMarker(event.latLng, "name");
    }
    
    coordinates.push(event.latLng);
    drawRoute();

    $('#route-points').append('<div class="route-point" data-index="'+routePointIndex+'">'
      + '<input type="hidden" name="poi[route_points_list]['+routePointIndex+'][latitude]" value="'+event.latLng.lat()+'">'
      + '<input type="hidden" name="poi[route_points_list]['+routePointIndex+'][longitude]" value="'+event.latLng.lng()+'">'
      + '</div>');
    
    var idx = routePointIndex;
    elevator.getElevationForLocations({locations: [event.latLng]}, function(results, status) {
      if (status == google.maps.ElevationStatus.OK && results[0]) {
        $('.route-point[data-index="'+idx+'"]').append(
        '<input type="hidden" name="poi[route_points_list]['+idx+'][elevation]" value="'+results[0].elevation+'">');
      }
    });
    
    routePointIndex++;
  });
  
  function drawRoute(){
    if (path)
      path.setMap(null);
    
    path = new google.maps.Polyline({
      path: coordinates,
      strokeColor: "#FF0000",
      strokeOpacity: 0.45,
      strokeWeight: 3
    });
    
    path.setMap(map);
  }
  
  $('a#new-map-undo').click(function(){
    routePointIndex--;
    
    $('div#route-points[data-index="'+routePointIndex+'"]').remove();
    coordinates.pop();
    drawRoute();
    
    return false;
  });
  
  function poiTypeChanged(){
    if (path)
      path.setMap(null);
    if (marker)
      marker.setMap(null);
    coordinates = [];
    routePointIndex = 0;
  }
});