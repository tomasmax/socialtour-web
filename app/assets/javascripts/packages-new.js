$(document).ready(function() {
	$("#package a.add_fields").
	  data("association-insertion-position", 'before').
	  data("association-insertion-node", 'this');
	
	$('#package').bind('insertion-callback',
	     function() {
	         $(".package-poi-fields a.add_fields").
	             data("association-insertion-position", 'before').
	             data("association-insertion-node", 'this');
	         $('.package-poi-fields').bind('insertion-callback',
	              function() {
	                $(this).children("#pacakge_form_list").remove();
	                $(this).children("a.add_fields").hide();
	              });
	     });
});