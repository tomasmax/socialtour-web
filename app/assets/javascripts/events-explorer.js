var mapControl = null;
var points = [];
var infowindow = null;

$(function(){
  infowindow = new google.maps.InfoWindow({ 
    size: new google.maps.Size(200,50)
  });
  
  function createMarker(poi) {
  	var pinColor = "FE7569";
    		var pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld="+poi.index+"|" + pinColor+"|0000FF",
        new google.maps.Size(60, 70));
        
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
  	var latlng = new google.maps.LatLng(43.034768, -2.620239);
		var myOptions = {
			zoom : 9,
			center : latlng,
			mapTypeId : google.maps.MapTypeId.ROADMAP
		};

	mapControl = new google.maps.Map(document.getElementById("events-map-canvas"), myOptions);

	var today = $.datepicker.formatDate('yy-mm-dd', new Date());
	LoadEvents(today, today, 'es');


  }
  google.maps.event.addDomListener(window, 'load', initialize);

});


$(function() {
	$('#datepicker').datepicker({
		firstDay: 1,
		onSelect : function(dateText, inst) {
			Reload();
		}
	});

	$("#datepicker").datepicker($.datepicker.regional['es']);
});


function LoadEvents(start, end, lang) {
	if (infowindow != null) {
		infowindow.setMap(null);
	}

	var wsUrl = "http://www.kulturklik.euskadi.net/?api_call=events&from=" + start + "&to=" + end + "&lang=" + lang;
	$.ajax({
		type : 'GET',
		url : wsUrl,
		dataType : "jsonp",
		async : true,
		contentType : "application/json; charset=utf-8",
		success : GetLoadEventsSuccess,
		error : OnFailure
	});
}

function GetLoadEventsSuccess(events) {
	//Eliminamos existents
	for (var i = 0; i < points.length; i++) {
		points[i].setMap(null);
	}

	//Cargamos eventos en mapa
	if (events != null) {
		var total = events.count;
		for (var i = 0; i < events.eventos.length; i++) {
			AddEvent(events.eventos[i]);
		}
	}
}

function AddEvent(evt) {
	//Añadimos marcador al mapa
	var latlon = new google.maps.LatLng(evt.latitude, evt.longitude);
	var marker = new google.maps.Marker({
		map : mapControl,
		position : latlon,
		animation : google.maps.Animation.DROP,
		title : evt.evento_titulo.replace(/&quot;/g, "\"")
	});

	//Asignamos el evento click
	google.maps.event.addListener(marker, 'click', function() {
		ShowData(evt);
	});

	//Incluimos en array
	points.push(marker);
}

function ShowData(evt) {
	//Ocultamos el infowindow
	if (infowindow != null) {
		infowindow.setMap(null);
	}

	//Mostramos el infowidow con nuevos datos
	var latlon = new google.maps.LatLng(evt.latitude, evt.longitude);
	var content = "<div class='mapinfobox'><b>" + evt.evento_tipo + ":</b> " + evt.evento_titulo + "<br/><br/><a target='_blank' href='" + evt.evento_url + "'> Ver Web </a></div>";
	infowindow = new google.maps.InfoWindow({
		content : content,
		position : latlon,
		disableAutoPan : true
	});

	infowindow.open(mapControl);
}

function OnFailure(error) {
	alert("ERROR: La restriccion de 50 peticiones diarias se ha superado");
}

function LangChanged() {
	Reload();
}

function Reload() {
	var lang = $("input[name=langRadio]:radio:checked").val();
	var date = $.datepicker.formatDate('yy-mm-dd', $("#datepicker").datepicker('getDate'));
	LoadEvents(date, date, lang);
}