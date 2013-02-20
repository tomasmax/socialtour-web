
  function initialize() {
  
    var options = {
      scrollwheel: false,
      zoom: 12,
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
	  
  }
  google.maps.event.addDomListener(window, 'load', initialize);