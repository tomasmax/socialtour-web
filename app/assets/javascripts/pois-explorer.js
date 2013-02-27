//= jquery.jscrollpane.min

var map, infowindow, markers = [];

$(function(){
  infowindow = new google.maps.InfoWindow({ 
    size: new google.maps.Size(200,50)
  });
  
  function createMarker(poi) {
  	var pinColor = "FE7569";
    		var pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld="+poi.index+"|" + pinColor+"|0000FF",
        new google.maps.Size(50, 60));
        
    var marker = new google.maps.Marker({
        position: new google.maps.LatLng(poi.latitude, poi.longitude),
        animation: google.maps.Animation.DROP,
        map: map,
        icon: pinImage
        
        //icon: supercategories[poi.supercategory_id] ? supercategories[poi.supercategory_id].icon_urls['small'] : null
    });
    
    marker.set("id", poi.id);
    
    var html = '<a href="/places/'+poi.slug+'"><b>'+poi.name+'</b></a><p>'+ poi.description +'</p>'
    
    google.maps.event.addListener(marker, 'click', function() {
        infowindow.setContent(html); 
        infowindow.open(map, marker);
    });
    
    google.maps.event.addListener(marker, 'mouseout', function() {
       
        marker.setAnimation(null);
    });
       
   	return marker;
  }
  
  function initialize() {
  
    var options = {
      scrollwheel: false,
      zoom: 14,
      /*center: new google.maps.LatLng(43.28,-3),*/
      mapTypeId: google.maps.MapTypeId.HYBRID
    };
    map = new google.maps.Map(document.getElementById('explorer-map-canvas'), options);
    
    // Try W3C Geolocation (Preferred)
	  if(navigator.geolocation) {
	    browserSupportFlag = true;
	    navigator.geolocation.getCurrentPosition(function(position) {
	      initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
	      map.setCenter(initialLocation);
	    }, function() {
	      handleNoGeolocation(browserSupportFlag);
	    });
	  }
	  // Browser doesn't support Geolocation
	  else {
	    browserSupportFlag = false;
	    handleNoGeolocation(browserSupportFlag);
	  }
	  
	  function handleNoGeolocation(errorFlag) {
	    if (errorFlag == true) {
	      alert("Geolocation service failed.");
	      initialLocation = newyork;
	    } else {
	      alert("Your browser doesn't support geolocation. We've placed you in Siberia.");
	      initialLocation = siberia;
	    }
	    map.setCenter(initialLocation);
	  }
	  
    $.each(pois, function(index, poi) {
      markers.push(createMarker(poi));
    });
  }
  google.maps.event.addDomListener(window, 'load', initialize);

});

var coordinates, path, poisDict = {}, selectedPOI = null;

$(function(){
  function loadRoute(poi, route_points) {
    if (path)
      path.setMap(null);
    
    coordinates = [];
    for (var index in route_points) {
      coordinates.push(new google.maps.LatLng(route_points[index].latitude, 
        route_points[index].longitude));
    }
    
    path = new google.maps.Polyline({
      path: coordinates,
      strokeColor: "#FF0000",
      strokeOpacity: 0.45,
      strokeWeight: 3
    });
    path.setMap(map);
    
    if (poi.route_info) {
      var bounds = new google.maps.LatLngBounds(
        new google.maps.LatLng(poi.route_info.s_bound, poi.route_info.w_bound), 
        new google.maps.LatLng(poi.route_info.n_bound, poi.route_info.e_bound));
        
      map.panToBounds(bounds);
    } else {
      map.panTo(new google.maps.LatLng(route_points[0].latitude, 
        route_points[0].longitude))
    }
    
    selectedPOI = poi;
  };


  $('#places-list ul.places-list li').mouseenter(function(){
    var el = $(this);
    //$(this).effect("highlight", {color:"#666666"}, 2000);
    var marker;
    var exit = false;
    	for (var i = 0; i < markers.length && !exit; i++) {
    		marker = markers[i];
			  if (marker.get("id") == el.attr('data-poi-id'))
			  {
			  	marker.setAnimation(google.maps.Animation.BOUNCE);
			  	infowindow.open(map, marker);
			    exit = true;
			  }
			}
			
    $('#places-list ul.places-list li').removeClass('hover');
    el.addClass('hover');
    var position = new google.maps.LatLng(el.attr('data-poi-lat'), el.attr('data-poi-lng'));
    map.panTo(position);
    map.setZoom(17);  
   	//map.setMarker(map, marker);
   	
   	el.mouseout(function(){
   		marker.setAnimation(null);
   	});
   	
    var poiSlug = el.attr('data-poi-slug');
    
    if (poisDict[poiSlug]){
      loadRoute(poisDict[poiSlug], poisDict[poiSlug].route_points);
    }else{
      $.getJSON('/places/'+poiSlug+'.json', function(poi){
        poisDict[poiSlug] = poi
        loadRoute(poi.poi, poi.route_points);
      }); 
    }
  });
   
  
  $('#places-list ul.places-list li').on('click', function(){
    var el = $(this);
    var poiSlug = el.attr('data-poi-slug');
    window.location.href = '/places/'+poiSlug;
  });

});
