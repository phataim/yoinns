<script type="text/javascript" charset="gb2312">
// JavaScript Document for China Province, City, Town link select
var myAjax = Ajax.getTransport();
/*
var default_province;
var default_city;
var default_town;
*/

var CPCTSelect = {
	init: function(){
		CPCTConstruct();
		initProvince();
	},
	
	POnChange: function(){
		clearOptions("city_select");
		clearOptions("town_select");
		var select_index = $("province_select").selectedIndex;
		var provinceId = $("province_select").options[select_index].value;

		default_city = 0;
		default_town = 0;
		initCity(provinceId);
	},
	
	COnChange: function(){
		clearOptions("town_select");
		var select_index = $("city_select").selectedIndex;
		var cityId = $("city_select").options[select_index].value;

		default_town = 0;
		initTown(cityId);		
	}
}

function CPCTConstruct(){
	html = "地区" +
	   "<select name='province_select' id='province_select' onChange='CPCTSelect.POnChange()' class='select_city'>" +
           "</select>" +
          "城市" +
           " <select name='city_select' id='city_select' onChange='CPCTSelect.COnChange()' class='select_city'>" +
           " </select> " +
           "地区" +
           " <select name='town_select' id='town_select' class='select_city'>" +
           " </select>";
    
	document.write(html);
}

function initProvince(){
	try{
		var url = "<%=VirtualPath%>/ajax/getProvince.asp";
		myAjax.open("GET", url, true);
		myAjax.onreadystatechange = initProvinceOK;
		myAjax.send(null);
		Ajax.activeRequestCount++;
	}catch(exception){}
}

function initProvinceOK(){
	if (myAjax.readyState == 4) {
		var response = myAjax.responseText;
		
		try{
			clearOptions("province_select");
			var arr = response.split(",");
			var arrValue = new Array(), arrText = new Array(), arrTemp = new Array();
			for(i=0, arrLen = arr.length; i < arrLen; i++){
				arrTemp = arr[i].split("-");
				arrValue[i] = arrTemp[0];
				arrText[i] = arrTemp[1];
			}
			
			addOptions("province_select", arrValue, arrText);
			setSelectedByValue("province_select", default_province);
			initCity(default_province);
		}catch(exception){}
		Ajax.activeRequestCount--;
	}	
}

function initCity(provinceId){
	try{
		var url = "<%=VirtualPath%>/ajax/getCity.asp?provinceId=" + escape(provinceId);
		myAjax.open("GET", url, true);
		myAjax.onreadystatechange = initCityOk;
		myAjax.send(null);
		Ajax.activeRequestCount++;
	}catch(exception){}	
}

function initCityOk(){
	if (myAjax.readyState == 4) {
		var response = myAjax.responseText;
		
		try{
			clearOptions("city_select");
			var arr = response.split(",");
			var arrValue = new Array(), arrText = new Array(), arrTemp = new Array();
			for(i=0, arrLen = arr.length; i < arrLen; i++){
				arrTemp = arr[i].split("-");
				arrValue[i] = arrTemp[0];
				arrText[i] = arrTemp[1];
			}
			
			addOptions("city_select", arrValue, arrText);
			setSelectedByValue("city_select", default_city);
			if(default_city == 0){
				initTown(arrValue[0]);
			}else{
				initTown(default_city);
			}
		}catch(exception){}
		Ajax.activeRequestCount--;
	}
}

function initTown(cityId){
	try{
		var url = "<%=VirtualPath%>/ajax/getTown.asp?cityId=" + escape(cityId);
		myAjax.open("GET", url, true);
		myAjax.onreadystatechange = initTownOk;
		myAjax.send(null);
		Ajax.activeRequestCount++;
	}catch(exception){}	
}

function initTownOk(){
	if (myAjax.readyState == 4) {
		var response = myAjax.responseText;
		
		try{
			clearOptions("town_select");
			var arr = response.split(",");
			var arrValue = new Array(), arrText = new Array(), arrTemp = new Array();
			for(i=0, arrLen = arr.length; i < arrLen; i++){
				arrTemp = arr[i].split("-");
				arrValue[i] = arrTemp[0];
				arrText[i] = arrTemp[1];
			}
			
			addOptions("town_select", arrValue, arrText);
			setSelectedByValue("town_select", default_town);
		}catch(exception){}
		Ajax.activeRequestCount--;
	}
}

CPCTSelect.init();
</script>