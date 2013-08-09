<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<%
Dim Action
Dim pid
Dim facilities

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
	
	facilities = Dream3CLS.RParam("facilities")
	
	'验证表单
	Call validateSubmit()

	
	If(len(trim(facilities)) > 0 ) Then	
		facilityArr = Split(facilities,",")
		facilities = ""
		For i = 0 To UBound(facilityArr)
			If i = 0 Then 
				facilities = Trim(facilityArr(i))
			Else
				facilities = facilities & "," & Trim(facilityArr(i))
			End If
			
		Next
	End If
	
	
	
	
	If len(gMsgArr) > 0 Then 
		gMsgFlag = "E"
		
		Exit Sub
	End If
	
	'开始保存
	
	
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
	
	Rs("facilities") = facilities
	Rs("state") = "pending" 
	
	Rs.Update

	Rs.Close
	Set Rs = Nothing
	
	
	directPage = "pstep4.asp?pid="&pid
	
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
		Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
		response.End()
	End If
	
	facilities = Rs("facilities") 
	facilities = ","&facilities&","

End Sub

Sub validateSubmit()
	If  Trim(facilities) = "" Then
		gMsgArr = gMsgArr&"|请选择设施服务！"
	End If
	
End Sub

Sub validateDraft()

End Sub




Sub Main()	
	
	Call ShowEdit()

End Sub

%>
<%
G_Title_Content = "发布系统"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="common/js/tools.js"></script>
<script type="text/javascript" src="common/js/calendar.js"></script> 

<form class="validator"  action="?act=save" method="post" id="productForm" name="productForm">
<div class="area">
	
    <div class="Details-tit">
        <span class="t6"><b><a href="pstep1.asp?pid=<%=pid%>">房间详情</a></b></span>
        <span class="t8"><b><a href="pstep2.asp?pid=<%=pid%>">上传照片</a></b></span>
        <span class="t9"><b>设施服务</b></span>
        <span class="t4"><b>入住与价格</b></span>
        <span class="t5"><b>预览</b></span>
    </div>
    
	<!--#include file="common/inc/publish_header.asp"-->
    
    <div class="layer2">
        <div class="side-top"></div>
        <div class="side-center">
            <div class="service">
                <h4 class="title">设施服务</h4>
                <div class="ser-check">   
					<%
					Set facilityRs = Server.CreateObject("adodb.recordset")			
					Sql = "select id,cname from T_Facility Where  enabled='Y' order by seqno desc"
					facilityRs.open Sql,conn,1,2
					i = 0
					Do While Not facilityRs.EOF 
						
						If instr(facilities,","&facilityRs("id")&",") Then
							isChecked = "checked"
						Else
							isChecked = ""
						End If
						'response.Write(facilityRs("cname")&"<input type=""checkbox"" "&isChecked&" name=""facilities"" value="&facilityRs("id")&" />")
						response.Write("<span><input type=""checkbox"" "&isChecked&" name=""facilities"" value="&facilityRs("id")&"><label>"&facilityRs("cname")&"</label></span>")
						facilityRs.Movenext
						i = i + 1
						'if(i mod 2 = 0) Then response.Write("<BR>")
					Loop
					%>                
                   
            	</div>
            	<div class="clear"></div>
                <div style="display:none;" id="iframesub_message"></div>
            </div>
        </div>
       	<div class="side-bottom"></div>
        </div>
      	<!---layer2 end-->
        <div class="next">
        <dl>
        	<dt class="Button-3 font14_white"><a href="pstep2.asp?act=showedit&pid=<%=pid%>">上一步</a></dt>
        	<dd><input type="submit" id="searchBt" value="下一步" class="input_next"></dd>
        </dl>
    </div>
        <div class="clear"></div>
    </div>
    
</div>

<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
</form>
<!--#include file="common/inc/footer_user.asp"-->