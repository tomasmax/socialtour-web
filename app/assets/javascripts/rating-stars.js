/************************************************************************
*************************************************************************
@Name :         jRating - jQuery Plugin
@Revison :      2.1
@Date :     26/01/2011
@Author:        ALPIXEL - (www.myjqueryplugins.com - www.alpixel.fr) 
@License :     Open Source - MIT License : http://www.opensource.org/licenses/mit-license.php
 
**************************************************************************
*************************************************************************/
(function($) {
  $.fn.jRating = function(op) {
    var defaults = {
      /** String vars **/
      bigStarsPath : '/assets/stars.png', // path of the icon stars.png
      grayStarsPath : '/assets/stars-gray.png', // path of the icon stars.png
      smallStarsPath : '/assets/small.png', // path of the icon small.png
      postURL : '/ratings.json', // path of the php file jRating.php
      type : 'big', // can be set to 'small' or 'big'
      
      /** Boolean vars **/
      step:false, // if true,  mouseover binded star by star,
      isDisabled:false,
      showRateInfo: false,
      
      /** Integer vars **/
      length:5, // number of star to display
      rateMax : 10, // maximal rate - integer from 0 to 9999 (or more)
      rateInfosX : -45, // relative position in X axis of the info box when mouseover
      rateInfosY : 5, // relative position in Y axis of the info box when mouseover
    }; 
    
    if(this.length>0)
    return this.each(function() {
      var opts = $.extend(defaults, op),    
      newWidth = 0,
      starWidth = 0,
      starHeight = 0,
      bgPath = '';

      if($(this).hasClass('jDisabled') || opts.isDisabled)
        var jDisabled = true;
      else
        var jDisabled = false;

      getStarWidth();
      $(this).height(starHeight);

      var average = parseFloat($(this).attr('data').split('_')[0]),
      idBox = parseInt($(this).attr('data').split('_')[1]), // get the id of the box
      widthRatingContainer = starWidth*opts.length, // Width of the Container
      widthColor = average/opts.rateMax*widthRatingContainer, // Width of the color Container
      
      quotient = 
      $('<div>', 
      {
        'class' : 'jRatingColor',
        css:{
          width:widthColor
        }
      }).appendTo($(this)),
      
      average = 
      $('<div>', 
      {
        'class' : 'jRatingAverage',
        css:{
          width:0,
          top:- starHeight
        }
      }).appendTo($(this)),

       jstar =
      $('<div>', 
      {
        'class' : 'jStar',
        css:{
          width:widthRatingContainer,
          height:starHeight,
          top:- (starHeight*2),
          background: 'url('+bgPath+') repeat-x'
        }
      }).appendTo($(this));

      $(this).css({width: widthRatingContainer,overflow:'hidden',zIndex:1,position:'relative'});

      if(!jDisabled)
      $(this).bind({
        mouseenter: function(e){
          var realOffsetLeft = findRealLeft(this);
          var relativeX = e.pageX - realOffsetLeft;
          if (opts.showRateInfo)
          var tooltip = 
          $('<p>',{
            'class' : 'jRatingInfos',
            html : getNote(relativeX)+' <span class="maxRate">/ '+opts.rateMax+'</span>',
            css : {
              top: (e.pageY + opts.rateInfosY),
              left: (e.pageX + opts.rateInfosX)
            }
          }).appendTo('body').show();
        },
        mouseover: function(e){
          $(this).css('cursor','pointer');  
        },
        mouseout: function(){
          $(this).css('cursor','default');
          average.width(0);
        },
        mousemove: function(e){
          var realOffsetLeft = findRealLeft(this);
          var relativeX = e.pageX - realOffsetLeft;
          if(opts.step) newWidth = Math.floor(relativeX/starWidth)*starWidth + starWidth;
          else newWidth = relativeX;
          average.width(newWidth - newWidth%23 + 11 + (newWidth%23 > 11 ? 12 : 0));          
          if (opts.showRateInfo)
          $("p.jRatingInfos")
          .css({
            left: (e.pageX + opts.rateInfosX)
          })
          .html(getNote(newWidth) +' <span class="maxRate">/ '+opts.rateMax+'</span>');
        },
        mouseleave: function(){
          $("p.jRatingInfos").remove();
        },
        click: function(e){
          $(this).unbind().css('cursor','default').addClass('jDisabled');
          if (opts.showRateInfo) $("p.jRatingInfos").fadeOut('fast',function(){$(this).remove();});
          e.preventDefault();
          var rate = getNote(newWidth);
          average.width(newWidth - newWidth%23 + 11 + (newWidth%23 > 11 ? 12 : 0));
          
          $.post(opts.postURL,{
              rating: {
                rating: rate,
                poi_id: opts.poiId
              }
            },
            function(data) {
              
            },
            'json'
          );
        }
      });

      function getNote(newWidth) {
        return Math.round(2*newWidth/23) / 2.0;
      };

      function getStarWidth(){
        switch(opts.type) {
          case 'small' :
            starWidth = 12; // width of the picture small.png
            starHeight = 10; // height of the picture small.png
            bgPath = opts.smallStarsPath;
          break;
          case 'gray':
              starWidth = 23; // width of the picture stars.png
              starHeight = 20; // height of the picture stars.png
              bgPath = opts.grayStarsPath;
          break;
          default :
            starWidth = 23; // width of the picture stars.png
            starHeight = 20; // height of the picture stars.png
            bgPath = opts.bigStarsPath;
        }
      };
      
      function findRealLeft(obj) {
        if( !obj ) return 0;
        return obj.offsetLeft + findRealLeft( obj.offsetParent );
      };
    });

  }
})(jQuery);
