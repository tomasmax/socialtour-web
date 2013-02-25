$('a#filter-category-btn').click(function(){
  var sc = $('select#supercategory-select').val();
  var city = $('select#city-select').val();
  
  if (!sc && !city)
    return false;
  
  var url;
  if (!sc) {
    url = '/cities/'+city;
  } else if (!city) {
    url = '/que-hacer/'+sc;
  } else {
    url = '/'+city+'/que-hacer/'+sc;
  }
  
  $(this).attr('href', url);
  return true;
});