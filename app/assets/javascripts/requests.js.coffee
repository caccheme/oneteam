# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $( "#request_start_date" ).datepicker     
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    showOn: 'both',
    buttonImageOnly: true,
    buttonImage: "calendar_icon1.png",

  $( "#request_end_date" ).datepicker
    showOn: 'both',
    buttonImage: "images/calendar_icon1.png",
    buttonImageOnly: true, 
    dateFormat: 'yy-mm-dd',
    changeMonth: true