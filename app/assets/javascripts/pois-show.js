//= require jquery.mousewheel-3.0.4.pack
//= require jquery.fancybox-1.3.4.pack
//= require raphael-min
//= require g.raphael-min
//= require g.line-min

var map, coordinates, path, infowindow;
$(function(){
  infowindow = new google.maps.InfoWindow({ 
    size: new google.maps.Size(150,50)
  });
  
function initialize() {
  var myOptions = {
    zoom: 15,
    draggableCursor: poi.name,
    center: new google.maps.LatLng(poi.latitude, poi.longitude),
    mapTypeId: poi.category && poi.category.is_route ? google.maps.MapTypeId.SATELLITE : google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById('poi-map-canvas'), myOptions);
  
  marker = new google.maps.Marker({
    position: new google.maps.LatLng(poi.latitude, poi.longitude),
    map: map,
    icon: poi.supercategory ? poi.supercategory.icon_urls['small'] : null
  });
  
  var html = '<a href="/places/'+poi.slug+'"><b>'+poi.name+'</b></a><p>'
  
  google.maps.event.addListener(marker, 'click', function() {
        infowindow.setContent(html); 
        infowindow.open(map, marker);
    });
  
  var bounds = null;
  if (poi.route_infos.first) {
    bounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(poi.route_info.s_bound, poi.route_info.w_bound), 
      new google.maps.LatLng(poi.route_info.n_bound, poi.route_info.e_bound));
      
    map.fitBounds(bounds);
  }
  
  if (poi.category && poi.category.is_route){
    coordinates = [];
    for (var index in poi.route_points) {
      coordinates.push(new google.maps.LatLng(poi.route_points[index].latitude, 
        poi.route_points[index].longitude));
    }
    
    path = new google.maps.Polyline({
      path: coordinates,
      strokeColor: "#FF0000",
      strokeOpacity: 0.45,
      strokeWeight: 3
    });
    path.setMap(map);
  }
}
google.maps.event.addDomListener(window, 'load', initialize);
});

function showEventForm(){
  $('#create-event-button').css('display', 'none');
  $('#new-event').fadeToggle();
}

$(function() {
  $('.poi-photo-fancy').each(function(){
    $(this).fancybox({
    		overlayShow: false,
    		transitionIn: 'elastic',
    		transitionOut: 'elastic'
    	});
  });
});

function distance(lat1, lon1, lat2, lon2){
  function toRad(deg) {
    return deg *3.14159265 / 180.0;
  };
  var R = 6371 * 1000; // km
  var dLat = toRad(lat2-lat1);
  var dLon = toRad(lon2-lon1);
  var lat1 = toRad(lat1);
  var lat2 = toRad(lat2);
  
  var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
          Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
  return R * c;
};

window.onload = function () {
  if (poi.route_points && poi.route_points.length > 0) {
    var r = Raphael("route-graph", 290, 170);
    var x = [], y = [], d = 0.0;
    for (var i in poi.route_points) {
      if (i > 0) {
        d += distance(poi.route_points[i-1].latitude, poi.route_points[i-1].longitude, poi.route_points[i].latitude, poi.route_points[i].longitude);
      }
      x[i] = parseInt(d);
      y[i] = parseFloat(poi.route_points[i].elevation);
    }
    r.linechart(20, 0, 270, 170, x, [y], { shade: true, axis: "0 0 0 1" });
  }
};


