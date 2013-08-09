<!--#include file="../conn.asp"-->
<!--#include file="../common/inc/permission_manage.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_tpl.asp"-->
<!--#include file="../common/api/cls_product.asp"-->
<!--#include file="../common/api/cls_coupon.asp"-->
<!--#include file="../common/api/cls_sms.asp"-->
<!--#include file="../common/api/cls_xml.asp"-->
<%
Dim url,result,id,rs,mobile,content
id = Dream3CLS.RSql("cid")
mobile = Dream3CLS.RSQL("mobile")
content = Dream3Coupon.GetSMSCoupon(id)

result = Dream3SMS.SendSMS(mobile,content)
If result = "success" Then
	Set rs = Server.CreateObject("Adodb.recordset")
	sql = "Select * From T_Coupon Where id='"&id&"'"
	rs.open Sql,conn,1,2
	If Not rs.EOF Then
		If IsNull(rs("sms")) Or rs("sms")="" Or rs("sms")=0 Then
			rs("sms") = 1
		Else
			rs("sms") = rs("sms") + 1
		End If
		rs.Update
	End If 
	rs.close
	Set rs = Nothing
	result = "0"
End If
response.Write(result)
%>
