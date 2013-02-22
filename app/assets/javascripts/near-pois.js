//= require jquery.easing
//= require jquery.eislideshow

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
    
    var html = '<a href="/places/'+poi.slug+'"><b>'+poi.name+'</b></a><p>'+ poi.description +'</p>'
    
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
      /*center: new google.maps.LatLng(43.28,-3),*/
      mapTypeId: google.maps.MapTypeId.HYBRID
    };
    map = new google.maps.Map(document.getElementById('map-canvas'), options);
    
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


var mapExpanded = false;
$(function(){
  $("a.map-expand").click(function() {
    $('#map-canvas').animate({
      height: mapExpanded ? 350 : 600
    }, {
    	duration: 300,
    	easing: "swing",
    	complete: function(){
    	  google.maps.event.trigger(map, "resize");
    	  $("a.map-expand > center").text(mapExpanded ? '↑' : '↓');
    	}
    });
    
    $("html, body").animate({
  		scrollTop: $($(this).attr("href")).offset().top + "px"
  	}, {
  		duration: 300,
  		easing: "swing"
  	});

    mapExpanded = !mapExpanded;
    return false;
  });
});