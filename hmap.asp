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
	
	'��ʼ����
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
	Dream3CLS.showMsg "���ľƵ��ѷ����ɹ���лл��","S", directPage
	
End Sub

Sub ShowEdit()
	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	
		Sql = "Select * from T_hotel Where h_id="&Pid&"  and h_uid="&Session("_UserID")
		
	Set Rs = Dream3CLS.Exec(Sql)
	If Rs.EOF Then
		Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
		response.End()
	End If

	address = 	Rs("h_address")
	map_x = Rs("h_mapx")  
	map_y = Rs("h_mapy")  

	If IsNull(map_x) Or map_x = "" Then
	
		map_x = "25.9912033508" '�ȸ����� x
		map_y = "105.66736938" '�ȸ����� y
		
		map_x = "113.400961" '�ٶ����� x mike
		map_y = "23.057637" '�ٶ����� y mike
		is_empty_map=1 'û������

	End If 

End Sub

Sub validateSubmit()
	'ͼƬ���������ϴ�һ��
	If img1="" Then
		gMsgArr = gMsgArr&"|ͼƬ���������ϴ���һ����"
	End If

	
End Sub

Sub validateDraft()

End Sub




Sub Main()	
	
	Call ShowEdit()

End Sub

%>
<%
G_Title_Content = "���õ�ͼ"
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

window.onload = loadScript; //����Զ��JS


function initialize(aa) { //������

  var map = new BMap.Map('map');

	var point = new BMap.Point(<%=map_x%>,<%=map_y%>); //���� ��ѧ������
	
	map.centerAndZoom(point,14);                   // ��ʼ����ͼ,���ó��к͵�ͼ����

	map.enableScrollWheelZoom();    //���ù��ַŴ���С��Ĭ�Ͻ���
	map.enableContinuousZoom();    //���õ�ͼ������ק��Ĭ�Ͻ���
	//��� end 
	
	//map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));     //2Dͼ������ͼ
	map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT}));    //���Ͻǣ�Ĭ�ϵ�ͼ�ؼ�

	//�������ſؼ�
	var opts = {type: BMAP_NAVIGATION_CONTROL_ZOOM, anchor: BMAP_ANCHOR_BOTTOM_RIGHT} 
	map.addControl(new BMap.NavigationControl(opts));
	//�������ſؼ�end

	<%if is_empty_map=1 then '���ݿ���û������ʱ%>
	
	//��עstart
	map.addEventListener("rightclick",function(e){ //�һ���ӱ�ע
		if (document.getElementById("map_x").value=="") //ֻ����һ����ע
		{
			var point2 = new BMap.Point(e.point.lng,e.point.lat); //��ʼ����עλ��
			var marker = new BMap.Marker(point2);
			map.addOverlay(marker);
			marker.enableDragging(); //���õ�ͼ������ק��Ĭ�Ͻ���
			
			document.getElementById("map_x").value=e.point.lng; //���������������
			document.getElementById("map_y").value=e.point.lat;

			address_n(e.point.lng,e.point.lat); //��ʾʵ������
		
			marker.addEventListener("dragend", function(e){  //�϶��� ������ʾλ��
				document.getElementById("map_x").value=e.point.lng; //��¼���ƶ��������
				document.getElementById("map_y").value=e.point.lat;
				address_n(e.point.lng,e.point.lat); //��ʾʵ������

			})
		};
	});  

	<%else%>
	//=========================================================================
	//���� �洢�ı�ע start
	address_n(<%=map_x%>,<%=map_y%>); //��ʾʵ������
	var point2 = new BMap.Point(<%=map_x%>,<%=map_y%>); //��ʼ����עλ��
	var marker = new BMap.Marker(point2);
	map.addOverlay(marker);
	marker.enableDragging(); //���õ�ͼ������ק��Ĭ�Ͻ���
		
			marker.addEventListener("dragend", function(e){  //�϶��� ������ʾλ��
				document.getElementById("map_x").value=e.point.lng; //��¼���ƶ��������
				document.getElementById("map_y").value=e.point.lat;
				address_n(e.point.lng,e.point.lat); //��ʾʵ������

			})

	//=========================================================================
	//���� ��ע end

	<%end if%>

	function address_n(x,y){ //��ʾʵ������
	// �����������ʵ��
		var myGeo = new BMap.Geocoder();
		// ��������õ���ַ����
		myGeo.getLocation(new BMap.Point(x,y), function(result){
		if (result){
		document.getElementById("suggestId").value=result.address;
		}
		});
	}




	if (aa==1) {s_text=document.getElementById("suggestId").value; setPlace();} //�������������	
	
	function G(id) {
		return document.getElementById(id);
	}
	var ac = new BMap.Autocomplete(    //����һ���Զ���ɵĶ���
		{"input" : "suggestId"
		,"location" : map
	});
	ac.addEventListener("onhighlight", function(e) {  //�����������б��ϵ��¼�
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
	ac.addEventListener("onconfirm", function(e) {    //����������б����¼�
	var _value = e.item.value;
		myValue = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
		//G("searchResultPanel").innerHTML ="onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue;
		
		setPlace();
	});
	
	function setPlace(){
		map.clearOverlays();    //�����ͼ�����и�����
		function myFun(){
			var pp = local.getResults().getPoi(0).point;    //��ȡ��һ�����������Ľ��
			map.centerAndZoom(pp, 17);
	   //     map.addOverlay(new BMap.Marker(pp));    //��ӱ�ע
		}
		var local = new BMap.LocalSearch(map, { //��������
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
        �������ַ: <input type="text" id="suggestId" value="" style="width:350px;height:22px; font-size:16px" /> 
        <input type="button" value="�� ��" onClick="initialize(1)" style="height:25px;width:40px" /> 
        </div>
        <div style="float:right;width:128px; text-align:right; font-size:14px; padding-top:4px;">
        <a href="#" onclick="initialize()">[���¼��ص�ͼ]</a>
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
	* �����û��ע����λ��, �����ڵ�ͼ���һ����, ��ָ�����������λ��.<br />
    * �����ס��ע, �������϶������ĵ���λ����<br />
    * �������������ɵ��"���¼��ص�ͼ"
    </div>
   </div>

	
    <div class="next">
        <dl>
        	<dt class="Button-3 font14_white"><a href="hotelsend.asp?act=showedit&pid=<%=pid%>">��һ��</a></dt>
			<dd><input type="submit" id="searchBt" value="����" class="input_next"></dd>
        </dl>
    </div>
    
    <div class="clear"></div>
    
</div>
<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
</form> 

<!--#include file="common/inc/footer_user.asp"-->