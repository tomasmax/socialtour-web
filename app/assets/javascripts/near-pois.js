
var map, infowindow, markers = [];

$(function(){
  infowindow = new google.maps.InfoWindow({ 
    size: new google.maps.Size(150,50)
  });
  
  function createMarker(poi) {
    var marker = new google.maps.Marker({
        position: new google.maps.LatLng(poi.latitude, poi.longitude),
        map: map,
        icon: supercategories[poi.supercategory_id] ? supercategories[poi.supercategory_id].icon_urls['small'] : null
    });
    
    var html = '<a href="/pois/'+poi.slug+'"><b>'+poi.name+'</b></a><p>'+poi.description+'</p>'
    
    google.maps.event.addListener(marker, 'click', function() {
        infowindow.setContent(html); 
        infowindow.open(map, marker);
    });   
    return marker;
  }
  
	function initialize() {
  var options = {
    scrollwheel: false,
    zoom: 12,
    draggableCursor: 'SocialTour',
    center: new google.maps.LatLng(44,-4),
    mapTypeId: google.maps.MapTypeId.HYBRID
  };
  map = new google.maps.Map(document.getElementById('map-canvas'), options);

  $.each(pois, function(index, poi) {
    markers.push(createMarker(poi));
  });
}
google.maps.event.addDomListener(window, 'load', initialize);

