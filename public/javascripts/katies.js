// Load Hook
document.observe("dom:loaded",function(){
  var tabs = new Control.Tabs($('subnavigation'));
  Control.Tabs.findByTabId('subnavigation').setActiveTab('sub_nav_pending');
});
