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