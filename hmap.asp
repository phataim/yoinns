<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->

<%
Dim Action
Dim pid,zipcode
Dim map_x,map_y,address,is_empty_map 'mike

Action = Request.QueryString("act")
Select Case Action
	Case "save"
		Call SaveRecord()
	Case "showedit"
		Call ShowEdit()
	Case Else
		Call Main()
End Select

Sub SaveRecord()
 	pid = Dream3CLS.ChkNumeric(Request.Form("pid"))
	
	map_x = Dream3CLS.RParam("map_x")
	map_y = Dream3CLS.RParam("map_y")
	
	
response.Write map_x
response.Write "-"
response.Write map_y
'response.End()

	If len(gMsgArr) > 0 Then 
		gMsgFlag = "E"
		
		Exit Sub
	End If
	
	'开始保存
	Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_User Where id= "&Session("_UserID")
		Rs.open Sql,conn,1,2
		zipcode="1"
		Rs("zipcode") 	=zipcode
		Rs.Update
		Rs.Close
		Set Rs = Nothing
	
	Set Rs = Server.CreateObject("Adodb.recordset")
	Sql = "Select * from T_hotel"
	If pid <> 0 Then
		
		Sql = Sql & " Where h_id="&pid&" and h_uid="&Session("_UserID")
		
	End If
	
	Rs.open Sql,conn,1,2
	Rs("h_mapx") = map_x
	Rs("h_mapy") = map_y
	
	Rs.Update

	Rs.Close
	Set Rs = Nothing
	
	
	directPage = VirtualPath&"/user/company/myhotel.asp"
	
	'response.Redirect(directPage)
	Dream3CLS.showMsg "您的酒店已发布成功，谢谢！","S", directPage
	
End Sub

Sub ShowEdit()
	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	
		Sql = "Select * from T_hotel Where h_id="&Pid&"  and h_uid="&Session("_UserID")
		
	Set Rs = Dream3CLS.Exec(Sql)
	If Rs.EOF Then
		Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
		response.End()
	End If

	address = 	Rs("h_address")
	map_x = Rs("h_mapx")  
	map_y = Rs("h_mapy")  

	If IsNull(map_x) Or map_x = "" Then
	
		map_x = "25.9912033508" '谷歌坐标 x
		map_y = "105.66736938" '谷歌坐标 y
		
		map_x = "113.400961" '百度坐标 x mike
		map_y = "23.057637" '百度坐标 y mike
		is_empty_map=1 '没有坐标

	End If 

End Sub

Sub validateSubmit()
	'图片必须至少上传一个
	If img1="" Then
		gMsgArr = gMsgArr&"|图片必须至少上传第一个！"
	End If

	
End Sub

Sub validateDraft()

End Sub




Sub Main()	
	
	Call ShowEdit()

End Sub

%>
<%
G_Title_Content = "设置地图"
%>

<!--#include file="common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

	<style>
      .gmap3{
        margin: 20px auto;
        border: 1px dashed #C0C0C0;
        width: 600px;
        height: 400px;
      }

    </style>

<script type="text/javascript">
function loadScript() {
  var script = document.createElement("script");
  script.src = "http://api.map.baidu.com/api?v=1.3&callback=initialize";
  document.body.appendChild(script);
}

window.onload = loadScript; //加载远程JS


function initialize(aa) { //主函数

  var map = new BMap.Map('map');

	var point = new BMap.Point(<%=map_x%>,<%=map_y%>); //广州 大学城坐标
	
	map.centerAndZoom(point,14);                   // 初始化地图,设置城市和地图级别。

	map.enableScrollWheelZoom();    //启用滚轮放大缩小，默认禁用
	map.enableContinuousZoom();    //启用地图惯性拖拽，默认禁用
	//标记 end 
	
	//map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));     //2D图，卫星图
	map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT}));    //左上角，默认地图控件

	//增加缩放控件
	var opts = {type: BMAP_NAVIGATION_CONTROL_ZOOM, anchor: BMAP_ANCHOR_BOTTOM_RIGHT} 
	map.addControl(new BMap.NavigationControl(opts));
	//增加缩放控件end

	<%if is_empty_map=1 then '数据库里没有坐标时%>
	
	//标注start
	map.addEventListener("rightclick",function(e){ //右击添加标注
		if (document.getElementById("map_x").value=="") //只能有一个标注
		{
			var point2 = new BMap.Point(e.point.lng,e.point.lat); //初始化标注位置
			var marker = new BMap.Marker(point2);
			map.addOverlay(marker);
			marker.enableDragging(); //启用地图惯性拖拽，默认禁用
			
			document.getElementById("map_x").value=e.point.lng; //坐标用鼠标点击坐标
			document.getElementById("map_y").value=e.point.lat;

			address_n(e.point.lng,e.point.lat); //显示实际名称
		
			marker.addEventListener("dragend", function(e){  //拖动完 弹出显示位标
				document.getElementById("map_x").value=e.point.lng; //记录后移动后的坐标
				document.getElementById("map_y").value=e.point.lat;
				address_n(e.point.lng,e.point.lat); //显示实际名称

			})
		};
	});  

	<%else%>
	//=========================================================================
	//加载 存储的标注 start
	address_n(<%=map_x%>,<%=map_y%>); //显示实际名称
	var point2 = new BMap.Point(<%=map_x%>,<%=map_y%>); //初始化标注位置
	var marker = new BMap.Marker(point2);
	map.addOverlay(marker);
	marker.enableDragging(); //启用地图惯性拖拽，默认禁用
		
			marker.addEventListener("dragend", function(e){  //拖动完 弹出显示位标
				document.getElementById("map_x").value=e.point.lng; //记录后移动后的坐标
				document.getElementById("map_y").value=e.point.lat;
				address_n(e.point.lng,e.point.lat); //显示实际名称

			})

	//=========================================================================
	//加载 标注 end

	<%end if%>

	function address_n(x,y){ //显示实际名称
	// 创建地理编码实例
		var myGeo = new BMap.Geocoder();
		// 根据坐标得到地址描述
		myGeo.getLocation(new BMap.Point(x,y), function(result){
		if (result){
		document.getElementById("suggestId").value=result.address;
		}
		});
	}




	if (aa==1) {s_text=document.getElementById("suggestId").value; setPlace();} //如果是搜索来的	
	
	function G(id) {
		return document.getElementById(id);
	}
	var ac = new BMap.Autocomplete(    //建立一个自动完成的对象
		{"input" : "suggestId"
		,"location" : map
	});
	ac.addEventListener("onhighlight", function(e) {  //鼠标放在下拉列表上的事件
	var str = "";
		var _value = e.fromitem.value;
		var value = "";
		if (e.fromitem.index > -1) {
			value = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
		}    
		str = "FromItem<br />index = " + e.fromitem.index + "<br />value = " + value;
		value = "";
		if (e.toitem.index > -1) {
			_value = e.toitem.value;
			value = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
		}    
	//alert("dd")    
		str += "<br />ToItem<br />index = " + e.toitem.index + "<br />value = " + value;
		//G("searchResultPanel").innerHTML = str;
	});
	
	var myValue;
	ac.addEventListener("onconfirm", function(e) {    //鼠标点击下拉列表后的事件
	var _value = e.item.value;
		myValue = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
		//G("searchResultPanel").innerHTML ="onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue;
		
		setPlace();
	});
	
	function setPlace(){
		map.clearOverlays();    //清除地图上所有覆盖物
		function myFun(){
			var pp = local.getResults().getPoi(0).point;    //获取第一个智能搜索的结果
			map.centerAndZoom(pp, 17);
	   //     map.addOverlay(new BMap.Marker(pp));    //添加标注
		}
		var local = new BMap.LocalSearch(map, { //智能搜索
		  onSearchComplete: myFun
		});
		if (aa==1){myValue=document.getElementById("suggestId").value ;}
		local.search(myValue);
	}
	
	if (aa==1){document.getElementById("suggestId").value=s_text ;}
}
</script>
</head>

	
    
    
  </head>
   <form class="validator"  action="?act=save" method="post" id="userForm" name="userForm">
<div class="area">
	

    
	<!--#include file="common/inc/hotelsend_header.asp"-->


    <div class="layer2">
    
    
  <div id="l-map"></div>
	<div id="r-result" style="font-size:16px;width:680px">
        <div style="float:left;width:552px;">
        请输入地址: <input type="text" id="suggestId" value="" style="width:350px;height:22px; font-size:16px" /> 
        <input type="button" value="搜 索" onClick="initialize(1)" style="height:25px;width:40px" /> 
        </div>
        <div style="float:right;width:128px; text-align:right; font-size:14px; padding-top:4px;">
        <a href="#" onclick="initialize()">[重新加载地图]</a>
        </div>
    </div>
    
    <%
	if is_empty_map=1 then%>
	<input type="text" id="map_x" name="map_x" size="20" value="" style="display:none" />
	<input type="text" id="map_y" name="map_y" size="20" value="" style="display:none" />
    <%else%>
	<input type="text" id="map_x" name="map_x" size="20" value="<%=map_x%>"   style="display:none"/>
	<input type="text" id="map_y" name="map_y" size="20" value="<%=map_y%>"   style="display:none"/>
    <%end if%>
	<div id="map" style="width:680px;height:420px"></div>
	<div id="t_text" style="float:none;font-size:12px;width:680px; background-color:#fdfdfd">
	* 如果还没标注您的位置, 您可在地图里右击鼠标, 可指定您店的所在位置.<br />
    * 左键按住标注, 可随意拖动到您的地理位置上<br />
    * 如果有其它问题可点击"重新加载地图"
    </div>
   </div>

	
    <div class="next">
        <dl>
        	<dt class="Button-3 font14_white"><a href="hotelsend.asp?act=showedit&pid=<%=pid%>">上一步</a></dt>
			<dd><input type="submit" id="searchBt" value="保存" class="input_next"></dd>
        </dl>
    </div>
    
    <div class="clear"></div>
    
</div>
<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
</form> 

<!--#include file="common/inc/footer_user.asp"-->