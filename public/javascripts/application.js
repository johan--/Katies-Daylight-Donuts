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

function show_comment_fields(comment_id){
  $(comment_id).show();
}

function loading(){
  showOverlay();
  facebox.reveal($("loader").innerHTML,null)
  $$('#facebox .footer').each(function(e){
    e.hide();
  })
}

function loadingComplete(){
  new Effect.Fade(facebox.facebox, {duration: 1});
  hideOverlay();
}

function showOverlay(){
  var overlay = Element("div", {"class" : "facebox_hide", "id" : "facebox_overlay"});
  document.body.appendChild(overlay);
  overlay.addClassName("facebox_overlayBG");
  overlay.setOpacity(0.5);
  overlay.show();
}

function hideOverlay(){
  if($('facebox_overlay')){
    $('facebox_overlay').hide();
    $('facebox_overlay').remove();
  }
}