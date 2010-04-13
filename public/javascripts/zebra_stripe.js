function stripe(e) {
  var evens = $$('table.stripe tr:nth-child(odd)');
    if(evens) {
      evens.each(function(tr) {
        tr.addClassName('oddRow');
      });
    }
}
 
Event.observe(window, 'load', stripe);