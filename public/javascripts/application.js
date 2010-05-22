// Google Ajax Api Key
// ABQIAAAAVimlRb2aAW5cgcfvHFp1zBSphUg9eGBlzC3ENvNCNY8EWEmmLBSJnaSRujuDXblprps3f9ZJkT2IlA

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

String.prototype.titleize = function() { 
    res = new Array(); 
    var parts = this.split(" "); 
    parts.each(function(part) { 
        res.push(part.capitalize()); 
    }) 
    return res.join(" "); 
}

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
  facebox.showOverlay();
  facebox.reveal($("loader").innerHTML,null)
  $$('#facebox .footer').each(function(e){
    e.hide();
  })
}

function loadingComplete(){
  new Effect.Fade(facebox.facebox, {duration: 1});
  facebox.hideOverlay();
}

function logout(url){
  if(url == null){
    var url = "/logout"
  }
  FB.Connect.logout(function(){
    window.location.href = url;
  });
}

function showProgressBar(messageTxt){
  document.body.appendChild(buildProgressBar(messageTxt))
  facebox.showOverlay();
}

function hideProgressBar(){
  document.body.removeChild($('progress_bar'))
  facebox.hideOverlay()
}

function buildProgressBar(messageTxt){
  if(messageTxt == null){
    var messageTxt = "Loading"
  }
  var progressBarContainer = Element('div',{'id':'progress_bar','class':'progressbar opaque'})
  var progressBar = Element('img',{'src':'/images/progress-bar.gif','class':'opaque'})
  var message = Element('span')
  message.innerHTML = messageTxt
  progressBarContainer.appendChild(progressBar)
  progressBarContainer.appendChild(message)
  return progressBarContainer;
}

// LivePipe

/**
 * @author Ryan Johnson <http://saucytiger.com/>
 * @copyright 2008 PersonalGrid Corporation <http://personalgrid.com/>
 * @package LivePipe UI
 * @license MIT
 * @url http://livepipe.net/core
 * @require prototype.js
 */

if(typeof(Control) == 'undefined')
	Control = {};
	
var $proc = function(proc){
	return typeof(proc) == 'function' ? proc : function(){return proc};
};

var $value = function(value){
	return typeof(value) == 'function' ? value() : value;
};

Object.Event = {
	extend: function(object){
		object._objectEventSetup = function(event_name){
			this._observers = this._observers || {};
			this._observers[event_name] = this._observers[event_name] || [];
		};
		object.observe = function(event_name,observer){
			if(typeof(event_name) == 'string' && typeof(observer) != 'undefined'){
				this._objectEventSetup(event_name);
				if(!this._observers[event_name].include(observer))
					this._observers[event_name].push(observer);
			}else
				for(var e in event_name)
					this.observe(e,event_name[e]);
		};
		object.stopObserving = function(event_name,observer){
			this._objectEventSetup(event_name);
			if(event_name && observer)
				this._observers[event_name] = this._observers[event_name].without(observer);
			else if(event_name)
				this._observers[event_name] = [];
			else
				this._observers = {};
		};
		object.observeOnce = function(event_name,outer_observer){
			var inner_observer = function(){
				outer_observer.apply(this,arguments);
				this.stopObserving(event_name,inner_observer);
			}.bind(this);
			this._objectEventSetup(event_name);
			this._observers[event_name].push(inner_observer);
		};
		object.notify = function(event_name){
			this._objectEventSetup(event_name);
			var collected_return_values = [];
			var args = $A(arguments).slice(1);
			try{
				for(var i = 0; i < this._observers[event_name].length; ++i)
					collected_return_values.push(this._observers[event_name][i].apply(this._observers[event_name][i],args) || null);
			}catch(e){
				if(e == $break)
					return false;
				else
					throw e;
			}
			return collected_return_values;
		};
		if(object.prototype){
			object.prototype._objectEventSetup = object._objectEventSetup;
			object.prototype.observe = object.observe;
			object.prototype.stopObserving = object.stopObserving;
			object.prototype.observeOnce = object.observeOnce;
			object.prototype.notify = function(event_name){
				if(object.notify){
					var args = $A(arguments).slice(1);
					args.unshift(this);
					args.unshift(event_name);
					object.notify.apply(object,args);
				}
				this._objectEventSetup(event_name);
				var args = $A(arguments).slice(1);
				var collected_return_values = [];
				try{
					if(this.options && this.options[event_name] && typeof(this.options[event_name]) == 'function')
						collected_return_values.push(this.options[event_name].apply(this,args) || null);
					for(var i = 0; i < this._observers[event_name].length; ++i)
						collected_return_values.push(this._observers[event_name][i].apply(this._observers[event_name][i],args) || null);
				}catch(e){
					if(e == $break)
						return false;
					else
						throw e;
				}
				return collected_return_values;
			};
		}
	}
};

/* Begin Core Extensions */

//Element.observeOnce
Element.addMethods({
	observeOnce: function(element,event_name,outer_callback){
		var inner_callback = function(){
			outer_callback.apply(this,arguments);
			Element.stopObserving(element,event_name,inner_callback);
		};
		Element.observe(element,event_name,inner_callback);
	}
});

//mouseenter, mouseleave
//from http://dev.rubyonrails.org/attachment/ticket/8354/event_mouseenter_106rc1.patch
Object.extend(Event, (function() {
	var cache = Event.cache;

	function getEventID(element) {
		if (element._prototypeEventID) return element._prototypeEventID[0];
		arguments.callee.id = arguments.callee.id || 1;
		return element._prototypeEventID = [++arguments.callee.id];
	}

	function getDOMEventName(eventName) {
		if (eventName && eventName.include(':')) return "dataavailable";
		//begin extension
		if(!Prototype.Browser.IE){
			eventName = {
				mouseenter: 'mouseover',
				mouseleave: 'mouseout'
			}[eventName] || eventName;
		}
		//end extension
		return eventName;
	}

	function getCacheForID(id) {
		return cache[id] = cache[id] || { };
	}

	function getWrappersForEventName(id, eventName) {
		var c = getCacheForID(id);
		return c[eventName] = c[eventName] || [];
	}

	function createWrapper(element, eventName, handler) {
		var id = getEventID(element);
		var c = getWrappersForEventName(id, eventName);
		if (c.pluck("handler").include(handler)) return false;

		var wrapper = function(event) {
			if (!Event || !Event.extend ||
				(event.eventName && event.eventName != eventName))
					return false;

			Event.extend(event);
			handler.call(element, event);
		};
		
		//begin extension
		if(!(Prototype.Browser.IE) && ['mouseenter','mouseleave'].include(eventName)){
			wrapper = wrapper.wrap(function(proceed,event) {	
				var rel = event.relatedTarget;
				var cur = event.currentTarget;			 
				if(rel && rel.nodeType == Node.TEXT_NODE)
					rel = rel.parentNode;	  
				if(rel && rel != cur && !rel.descendantOf(cur))	  
					return proceed(event);   
			});	 
		}
		//end extension

		wrapper.handler = handler;
		c.push(wrapper);
		return wrapper;
	}

	function findWrapper(id, eventName, handler) {
		var c = getWrappersForEventName(id, eventName);
		return c.find(function(wrapper) { return wrapper.handler == handler });
	}

	function destroyWrapper(id, eventName, handler) {
		var c = getCacheForID(id);
		if (!c[eventName]) return false;
		c[eventName] = c[eventName].without(findWrapper(id, eventName, handler));
	}

	function destroyCache() {
		for (var id in cache)
			for (var eventName in cache[id])
				cache[id][eventName] = null;
	}

	if (window.attachEvent) {
		window.attachEvent("onunload", destroyCache);
	}

	return {
		observe: function(element, eventName, handler) {
			element = $(element);
			var name = getDOMEventName(eventName);

			var wrapper = createWrapper(element, eventName, handler);
			if (!wrapper) return element;

			if (element.addEventListener) {
				element.addEventListener(name, wrapper, false);
			} else {
				element.attachEvent("on" + name, wrapper);
			}

			return element;
		},

		stopObserving: function(element, eventName, handler) {
			element = $(element);
			var id = getEventID(element), name = getDOMEventName(eventName);

			if (!handler && eventName) {
				getWrappersForEventName(id, eventName).each(function(wrapper) {
					element.stopObserving(eventName, wrapper.handler);
				});
				return element;

			} else if (!eventName) {
				Object.keys(getCacheForID(id)).each(function(eventName) {
					element.stopObserving(eventName);
				});
				return element;
			}

			var wrapper = findWrapper(id, eventName, handler);
			if (!wrapper) return element;

			if (element.removeEventListener) {
				element.removeEventListener(name, wrapper, false);
			} else {
				element.detachEvent("on" + name, wrapper);
			}

			destroyWrapper(id, eventName, handler);

			return element;
		},

		fire: function(element, eventName, memo) {
			element = $(element);
			if (element == document && document.createEvent && !element.dispatchEvent)
				element = document.documentElement;

			var event;
			if (document.createEvent) {
				event = document.createEvent("HTMLEvents");
				event.initEvent("dataavailable", true, true);
			} else {
				event = document.createEventObject();
				event.eventType = "ondataavailable";
			}

			event.eventName = eventName;
			event.memo = memo || { };

			if (document.createEvent) {
				element.dispatchEvent(event);
			} else {
				element.fireEvent(event.eventType, event);
			}

			return Event.extend(event);
		}
	};
})());

Object.extend(Event, Event.Methods);

Element.addMethods({
	fire:			Event.fire,
	observe:		Event.observe,
	stopObserving:	Event.stopObserving
});

Object.extend(document, {
	fire:			Element.Methods.fire.methodize(),
	observe:		Element.Methods.observe.methodize(),
	stopObserving:	Element.Methods.stopObserving.methodize()
});

//mouse:wheel
(function(){
	function wheel(event){
		var delta;
		// normalize the delta
		if(event.wheelDelta) // IE & Opera
			delta = event.wheelDelta / 120;
		else if (event.detail) // W3C
			delta =- event.detail / 3;
		if(!delta)
			return;
		var element = Event.extend(event).target;
		element = Element.extend(element.nodeType == Node.TEXT_NODE ? element.parentNode : element);
		var custom_event = element.fire('mouse:wheel',{
			delta: delta
		});
		if(custom_event.stopped){
			Event.stop(event);
			return false;
		}
	}
	document.observe('mousewheel',wheel);
	document.observe('DOMMouseScroll',wheel);
})();

/* End Core Extensions */

//from PrototypeUI
var IframeShim = Class.create({
	initialize: function() {
		this.element = new Element('iframe',{
			style: 'position:absolute;filter:progid:DXImageTransform.Microsoft.Alpha(opacity=0);display:none',
			src: 'javascript:void(0);',
			frameborder: 0 
		});
		$(document.body).insert(this.element);
	},
	hide: function() {
		this.element.hide();
		return this;
	},
	show: function() {
		this.element.show();
		return this;
	},
	positionUnder: function(element) {
		var element = $(element);
		var offset = element.cumulativeOffset();
		var dimensions = element.getDimensions();
		this.element.setStyle({
			left: offset[0] + 'px',
			top: offset[1] + 'px',
			width: dimensions.width + 'px',
			height: dimensions.height + 'px',
			zIndex: element.getStyle('zIndex') - 1
		}).show();
		return this;
	},
	setBounds: function(bounds) {
		for(prop in bounds)
			bounds[prop] += 'px';
		this.element.setStyle(bounds);
		return this;
	},
	destroy: function() {
		if(this.element)
			this.element.remove();
		return this;
	}
});


function initGrid(container, grid_title, grid_fields, grid_columns, data){
  var store = new Ext.data.ArrayStore({
    fields: grid_fields
  });
  store.loadData(data);
  var grid = new Ext.grid.GridPanel({
    store: store,
    columns: grid_columns,
    stipeRows: true,
    height: 350,
    width: 550,
    title: grid_title
  })
}

// Initialize Users Grid
// Initialize the Deliveries Grid
function initUsersGrid(){
  var store = new Ext.data.Store({
      remoteSort: false,
      autoLoad: {params:{start:0, limit:100}},
      
      proxy: new Ext.data.HttpProxy({
          url: "/admin/users.json",
          method: "GET"
      }),

      reader: new Ext.data.JsonReader({
          root: 'users',
          totalProperty: 'totalCount',
          idProperty: 'id',
          fields: [
            {name: 'id', type: 'string'},
            {name: 'created_at', type: 'date', dateFormat: 'n/j h:ia'},
            {name: 'store_name', type: 'string'},
            {name: 'username', type: 'string'},
            {name: 'email', type: 'string'},
            {name: 'tools', type: 'string'}
          ]
      })
  });

  var grid = new Ext.grid.GridPanel({
      id: 'usersGrid',
      stripeRows: true,
      renderTo: 'users',
      width: 550,
      height:400,
      autoWidth: 'auto',
      frame:true,
      title:'Users',
      trackMouseOver:false,
      store: store,

      columns: [
           {header: 'ID', sortable: true, dataIndex: 'id', width: 40},
           {header: 'Created', sortable: true, renderer: Ext.util.Format.dateRenderer('m/d/Y'), dataIndex: 'created_at', width: 80},
           {header: 'Store Name', sortable: true, dataIndex: 'store_name'},
           {header: 'Username', sortable: true, dataIndex: 'username', width: 110},
           {header: 'Email', sortable: true, dataIndex: 'email'},
           {header: 'Tools', sortable: true, dataIndex: 'tools'}
       ],

    bbar: new Ext.PagingToolbar({
      id: 'paging',
      store: store,
      pageSize:100,
      displayInfo:true
    })
  });
}

// Initialize the Deliveries Grid
function initDeliveriesGrid(path){
  var store = new Ext.data.Store({
      remoteSort: true,
      autoLoad: {params:{start:0, limit:70}},
      
      proxy: new Ext.data.HttpProxy({
          url: path,
          method: "GET"
      }),

      reader: new Ext.data.JsonReader({
          root: 'deliveries',
          totalProperty: 'totalCount',
          idProperty: 'id',
          fields: [
            {name: 'id', type: 'string'},
            {name: 'created_at', type: 'date', dateFormat: 'n/j h:ia'},
            {name: 'store', type: 'string'},
            {name: 'route', type: 'string'},
            {name: 'state', type: 'string'},
            {name: 'tools', type: 'string'}
          ]
      })
  });

  var grid = new Ext.grid.GridPanel({
      id: 'deliveriesGrid',
      stripeRows: true,
      renderTo: 'deliveries',
      width: 550,
      height:400,
      autoWidth: 'auto',
      frame:true,
      title:'Deliveries',
      trackMouseOver:false,
      store: store,

      columns: [
           {header: 'ID', sortable: true, dataIndex: 'id', width: 70},
           {header: 'Created', sortable: true, renderer: Ext.util.Format.dateRenderer('m/d/Y'), dataIndex: 'created_at', width: 80},
           {header: 'Store', sortable: true, dataIndex: 'store', width: 110},
           {header: 'Route', sortable: true, dataIndex: 'route'},
           {header: 'Status', sortable: true, dataIndex: 'state', width: 60},
           {header: 'Tools', sortable: false, dataIndex: 'tools', width: 125}
       ],

    bbar: new Ext.PagingToolbar({
      id: 'paging',
      store: store,
      pageSize:70,
      displayInfo:true
    })
  });
}

function reloadDeliveriesGrid(action, admin){
  var grid = Ext.getCmp('deliveriesGrid');
  grid.setTitle("Deliveries / " + action);
  var store = grid.getStore()
  if(admin == true){ 
    store.proxy.setApi('read',"/admin/deliveries.json") 
  }else{ store.proxy.setApi('read',"/deliveries.json")  }
  store.baseParams = {status: action, start: 0, limit: 70};
  store.load();
  //tabs.setActiveTab("#pending")
  if($('clear_search_link'))
    $('clear_search_link').hide();
}

function setDeliveriesGridUrl(path){
  var grid = Ext.getCmp('deliveriesGrid')
  var store = grid.getStore()
  store.proxy.setApi('read',path)
  grid.getStore().reload()
  if($('clear_search_link').childNodes.length == 0){
    var clearLink = Element("a",{
      "href" : "javascript:reloadDeliveriesGrid('pending',true)"
    })
    $('clear_search_link').appendChild(clearLink)
    clearLink.innerHTML = "clear search"
  }else{
    $('clear_search_link').show();
  }
}

// Creates a time ticker
function timeTicker(){
  var today = new Date();
  var hour = today.getHours();
  var mins = today.getMinutes();
  var secs = today.getSeconds();

  if (secs <=9){
      secs = "0" + secs
  }
  
  if (mins <=9){
      mins = "0" + mins
  }
  
  if(hour > 12){
    hour = hour - 12;
    var ordinal = "pm"
  }else{
    var ordinal = "am"
  }

  var TotalTime = hour + ":" + mins + ":" + secs + " " + ordinal;

  $('current_time').innerHTML = TotalTime;

  setTimeout("timeTicker()", 1000)
}

function initDeliveriesGridWithDelivery(){
  setDeliveriesGridUrl('/admin/deliveries/' + $('id').value + '.json')
}

// Handle Key Event
function handleKeyPress(e){
  var key = e.keyCode == undefined ? e.which : e.keyCode;
  if (key==13){ // Enter Key
    initDeliveriesGridWithDelivery()
  }
}

function generateDeliveriesComplete(){
  reloadDeliveriesGrid('pending',true);
  $('ticket_spinner').hide();
}

function ticker(){
  var e = $$('#ticker_messages li')[0];
  $('ticker_messages').appendChild(e);
}