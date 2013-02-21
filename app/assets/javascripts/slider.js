//= require jquery.easing
//= require jquery.eislideshow

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

/* $(document).ready(function() 
{   
  var index = 0;
  var images = $("#gallery img");
  var thumbs = $("#thumbs img");
  var imgHeight = 100;//$(thumbs).attr("height");
  $(thumbs).slice(0,4).clone().appendTo("#thumbs");
  for (i=0; i<thumbs.length; i++)
  {
    $(thumbs[i]).addClass("thumb-"+i);
    $(images[i]).addClass("image-"+i);
    $(thumbs[i]).click((function(idx){
      return function(){ show(idx); };
    })(i));
    $(images[i]).click(function(){
      window.open(this.getAttribute('data-url'), '_self');
    });
  }

  show(index);
  setInterval(sift, 8000);
  
  function sift()
  {
    if (index<(thumbs.length-1)){index+=1 ; }
    else {index=0}
    show (index);
  }
  
  function show(num)
  {
    $(images).fadeOut(400);
    $(".image-"+num).stop().fadeIn(400);
    var scrollPos = (num-1)*imgHeight;
    $("#thumbs").stop().animate({scrollTop: scrollPos}, 400);    
    console.log(scrollPos, "img.image-"+num);
  } */