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
      zoom: 11,
      center: new google.maps.LatLng(43.213,-3.13),
      mapTypeId: google.maps.MapTypeId.HYBRID
    };
    map = new google.maps.Map(document.getElementById('map-canvas'), options);
  
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

  $('#routes-list ul.places-list li').mouseenter(function(){
    var el = $(this);
    
    $('#routes-list ul.places-list li').removeClass('hover');
    el.addClass('hover');
    var position = new google.maps.LatLng(el.attr('data-poi-lat'), el.attr('data-poi-lng'));
    map.panTo(position);
    map.setZoom(14);
    
    var poiSlug = el.attr('data-poi-slug');
    
    if (poisDict[poiSlug]){
      loadRoute(poisDict[poiSlug], poisDict[poiSlug].route_points);
    }else{
      $.getJSON('/pois/'+poiSlug+'.json', function(poi){
        poisDict[poiSlug] = poi
        loadRoute(poi.poi, poi.route_points);
      });
      
    }
  });
  
  $('#routes-list ul.places-list li').on('click', function(){
    var el = $(this);
    var poiSlug = el.attr('data-poi-slug');
    window.location.href = '/rutas/'+poiSlug;
  });

});

$(function() {
  $('#slider').eislideshow({
    animation			: 'center',
    autoplay			: true,
    slideshow_interval	: 6000,
    titlesFactor		: 0,
	  easing		: 'easeOutExpo',
	  titleeasing	: 'easeOutExpo',
	  titlespeed	: 1200
  });
});


var mapExpanded = false;
$(function(){
  $("a.map-expand").click(function() {
    $('#map-canvas').animate({
      height: mapExpanded ? 300 : 600
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

