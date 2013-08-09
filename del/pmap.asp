<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->

<%
Dim Action
Dim pid
Dim map_x,map_y,address

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
	
	
	
	If len(gMsgArr) > 0 Then 
		gMsgFlag = "E"
		
		Exit Sub
	End If
	
	'��ʼ����
	
	
	Set Rs = Server.CreateObject("Adodb.recordset")
	Sql = "Select * from T_Product"
	If pid <> 0 Then
		If Session("_IsManager") = "Y" Then
			Sql = Sql & " Where ID="&pid
		Else
			Sql = Sql & " Where ID="&pid&" and user_id="&Session("_UserID")
		End If
	End If
	
	Rs.open Sql,conn,1,2
	Rs("map_x") = map_x
	Rs("map_y") = map_y
	Rs("state") = "pending" 

	
	Rs.Update

	Rs.Close
	Set Rs = Nothing
	
	
	directPage = "pstep1.asp?pid="&pid
	
	response.Redirect(directPage)
	
End Sub

Sub ShowEdit()
	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	If Session("_IsManager") = "Y" Then
		Sql = "Select * from T_Product Where id="&Pid
	Else
		Sql = "Select * from T_Product Where id="&Pid&"  and user_id="&Session("_UserID")
	End If
	Set Rs = Dream3CLS.Exec(Sql)
	If Rs.EOF Then
		Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
		response.End()
	End If

	address = 	Rs("address")
	map_x = Rs("map_x")  
	map_y = Rs("map_y")  

	If IsNull(map_x) Or map_x = "" Then
		map_x = "25.9912033508"
		map_y = "105.66736938"
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
<script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>
<script language="javascript" src="<%=VirtualPath%>/common/js/jquery/gmap3.min.js"></script>

	<style>
      .gmap3{
        margin: 20px auto;
        border: 1px dashed #C0C0C0;
        width: 600px;
        height: 400px;
      }

    </style>
	
	<script type="text/javascript">
    
      $(function(){
     
        $("#test1").gmap3();
  
          var addr = "<%=address%>";
          if ( !addr || !addr.length ) return;
          $("#test1").gmap3({
            action:   'getlatlng',
            address:  addr,
            callback: function(results){
              if ( !results ) return;
              $(this).gmap3({
                action:'addMarker',
                latLng:results[0].geometry.location,
                map:{
                  center: true,
				  zoom: 14
                },infowindow:{
				  options:{
					size: new google.maps.Size(50,20),
					content: '<div id="elevation"><%=address%></div>'
				  },
				  onces: {
					domready: function(){
					  //refreshinfowindow( center );
					}
				  }
				}
              });
            }
          });
        
       
      });

    </script> 
	
    
    
  </head>
   <form class="validator"  action="?act=save" method="post" id="productForm" name="productForm">
<div class="area">
	
    <div class="Details-tit">
        <span class="t1"><b>��������</b></span>
        <span class="t2"><b>�ϴ���Ƭ</b></span>
        <span class="t3"><b>��ʩ����</b></span>
        <span class="t4"><b>��ס��۸�</b></span>
        <span class="t5"><b>Ԥ��</b></span>
    </div>
    
	<!--#include file="common/inc/publish_header.asp"-->
    
    <div class="layer2">
        <div class="side-top"></div>
        <div class="side-center">
           
		   <div id="test1" class="gmap3"></div>
           <div>
		   <input type="text" name="map_x" id="map_x" value="<%=map_x%>" size="60" style="display:none "/>
		   <input type="text" name="map_y" id="map_y" value="<%=map_y%>" size="60" style="display:none "/>
		   </div>
        </div>
        <div class="side-bottom"></div>
	</div>
	
    <div class="next">
        <dl>
        	<dt class="Button-3 font14_white"><a href="publish.asp?act=showedit&pid=<%=pid%>">��һ��</a></dt>
			<dd><input type="submit" id="searchBt" value="��һ��" class="input_next"></dd>
        </dl>
    </div>
    
    <div class="clear"></div>
    
</div>
<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
</form> 

<!--#include file="common/inc/footer_user.asp"-->