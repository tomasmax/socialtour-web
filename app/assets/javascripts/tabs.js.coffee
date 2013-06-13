$ ->
  $('.tabs > .tab-selector > a').click ->
  	$('.tabs > .tab-selector > a').removeClass 'selected'
  	$(this).addClass 'selected'
  	tab = $(this).attr 'href'
  	$('.tabs .tab').hide()
  	$(tab).show()
  	false