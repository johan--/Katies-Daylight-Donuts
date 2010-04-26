document.observe("dom:loaded",function(){
//example 2  
var tabs_example_two = new Control.Tabs('tabs_example_two');
  
$('tabs_example_two_select').observe('change',function(){  
    tabs_example_two.setActiveTab($('tabs_example_two_select').value);  
});  
$('tabs_example_two_first').observe('click',function(event){  
    this.first();  
    Event.stop(event);  
}.bindAsEventListener(tabs_example_two));  
$('tabs_example_two_previous').observe('click',function(event){  
    this.previous();  
    Event.stop(event);  
}.bindAsEventListener(tabs_example_two));  
$('tabs_example_two_next').observe('click',function(event){  
    this.next();  
    Event.stop(event);  
}.bindAsEventListener(tabs_example_two));  
$('tabs_example_two_last').observe('click',function(event){  
    this.last();  
    Event.stop(event);  
}.bindAsEventListener(tabs_example_two));
})