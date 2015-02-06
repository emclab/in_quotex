// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
	$( "#quote_quote_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#quote_approved_date" ).datepicker({dateFormat: 'yy-mm-dd'});
});

$(function() {
	$( "#quote_start_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#quote_end_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#quote_quote_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#quote_approved_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
});

$(function() {
  $('#quote_product_name').change(function (){
  	$('#quote_field_changed').val('product_name);
    $.get(window.location, $('form').serialize(), null, "script");
    return false;
  });
});