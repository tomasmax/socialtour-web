// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery-1.8.3.min
//= require jquery-ui-1.10.0.custom.min
//= require bootstrap.min
//= require chosen.jquery
//= require categories-show
//= require jquery.endless-scroll
//= require starbar
//= require_self

$(document).ready(function() {
  // Init custom selects
  $(".js-select").chosen();
  
  $(".chosen").chosen();
  
  $('.starbar').each(function(){
    starbar($(this));
  });
  
  $('.file-uploader').each(function(){
    var uploader = $(this);
    uploader.children('input[type="file"]').change(function(){
    
      uploader.children('.uploader-content').append(' <span class="uploader-filename">'+$(this).val().split('\\').pop()+'</span>');
      
      uploader.addClass('btn-success');
      
      uploader.parent('form').children('input[type="submit"]').css('display', 'inline-block');
    });
  });
});

  // Vertical slider
	$(".h-slider").slider({
	    range: "min",
	    min: -10,
	    max: 10,
	    value: 0
	});

