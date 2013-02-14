function starbar(starbar) {
  function loadRealRating() {
    starbar.children('.star').removeClass("half full focus");
    
    var rating = parseFloat(starbar.attr('data-poi-rating')) / parseFloat(starbar.attr('data-poi-ratings-count'));
    
    starbar.children('.star').each(function(){
      if (rating > 0){
        if (rating <= 0.5) {
          $(this).addClass("half");
        }else{
          $(this).addClass("full");
        }
      }
      rating -= 1;
    });
  }
  
  loadRealRating();

  starbar.children('.star').mousemove(function(ev){
    starbar.children('.star').removeClass("half full focus");
    $(this).addClass(ev.offsetX > 8 ? "full focus" : "half focus");
    $(this).prevAll().addClass("full focus");
  
  }).click(function(ev){
    var rating = $(this).prevAll().length
    rating += ev.offsetX > 8 ? 1 : 0.5;
    
    var poiId = starbar.attr('data-poi-id');

    starbar.children('#loading').css('display', 'inline-block');
    $.post('/ratings', {rating: {poi_id: poiId, rating: rating}}, function(result){
      starbar.children('#loading').css('display', 'none');
      starbar.attr('data-poi-rating', result.poi_rating);
      starbar.children('.starbar-rating').text(""+result.poi_ratings_count + (result.poi_ratings_count==1?" Votación":" Votaciones"));
      loadRealRating();
    });
    
  }).mouseleave(loadRealRating);
}
