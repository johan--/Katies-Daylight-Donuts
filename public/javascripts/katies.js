var Katies = Class.create()
Katies.prototype = {
  initialize : function(){
    this.options = $H({
      app : "heroku"
    })
  },
  
  test : function(){
    alert("test")
  },
  
  initQtyHelpers : function(){ 
    $$("input.quantity").each(function(e){
      //var idName = ("qty_links_for_" + e.id + "")
      //var container = new Element("span", {"id" : idName})
      /*var noneLink = new Element("a",{"onclick" : function(){
        this.setFieldValue(e,0)
      }});
      var oneDzLink = new Element("a",{"onclick" : function(){
        this.setFieldValue(e,12)
      }});
      var twoDzLink = new Element("a",{"onclick" : function(){
        this.setFieldValue(e,24)
      }});
      [noneLink,oneDzLink,twoDzLink].each(function(e){
        container.appendChild(e)
      })*/
      alert(e.id)
      //e.style.background.color = "333"
      //e.appendChild(container)
    })
  },
  
  setFieldValue : function(field, value){
    field.value = value;
  }
}

var katies = new Katies;
//katies.initQtyHelpers();


document.observe("dom:loaded",function(){
//example 2  
var tabs_example_two = new Control.Tabs('tabs_example_two',{  
    afterChange: function(new_container){  
        $A($('tabs_example_two_select').options).each(function(option,i){  
            if(option.value == new_container.id){  
                $('tabs_example_two_select').options.selectedIndex = i;  
                throw $break;  
            }  
        });  
    }  
});  
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