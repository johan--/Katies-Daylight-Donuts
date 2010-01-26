// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function enableCalendar(){
  $$('.calendar_date_select_popup_icon').each(function(e){
    e.onclick();
    return;
  });
}


function paginate(target){
  document.observe("dom:loaded", function() {
    $("#more_link").morePaginate({ container: target });
  });
  
}

function setText(selector, text){
  $(selector).innerHTML = text;
}