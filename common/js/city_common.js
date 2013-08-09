// JavaScript Document for public functions
function $(id){	//return HTML object by object id
	var obj = document.getElementById(id);
	return obj ? obj : undefined;
}

function $V(id){	//return HTML object's value
	if($(id) != undefined){
		return $(id).value;
	}else{
		return null;
	}
}

function $Len(id){
	if($(id) != undefined){
		return $(id).options.length;
	}else{
		return null;
	}
}

function $Rows(id){
	if($(id) != undefined){
		return $(id).rows.length;
	}else{
		return null;
	}
}

//------ajax---------
var Ajax = {
  getTransport: function() {
    return Try.these(
      function() {return new XMLHttpRequest()},
      function() {return new ActiveXObject("Msxml2.XMLHTTP")},
      function() {return new ActiveXObject("Microsoft.XMLHTTP")}
    ) || false;
  },

  activeRequestCount: 0
}

var Try = {
  these: function() {
    var returnValue;

    for (var i = 0, length = arguments.length; i < length; i++) {
      var lambda = arguments[i];
      try {
        returnValue = lambda();
        break;
      } catch (e) {}
    }

    return returnValue;
  }
}

//------select options control-----
function addOptions(selectId, arrValue, arrText){
	if($(selectId) != undefined){
		for(i = 0, arrLen = arrValue.length; i < arrLen; i++){
			$(selectId).options.add( new Option(arrText[i], arrValue[i]) );
		}
	}else{
		return false;
	}
}

function clearOptions(selectId){
	if($(selectId) != undefined){
		$(selectId).options.length=0;
	}else{
		return false;
	}
}

function setSelected(selectId, index){
	if($(selectId) != undefined){
		$(selectId).options[index].selected = true;
	}else{
		return false;
	}	
}

function setSelectedByValue(selectId, selectedValue){
	var i = 0;
	if($(selectId) != undefined){
		for(i=0; i<$(selectId).options.length; i++){
			if($(selectId).options[i].value == selectedValue){
				$(selectId).options[i].selected = true;
				break;
			}
		}
	}else{
		return false;
	}	
}