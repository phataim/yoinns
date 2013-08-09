<!--#include file="../conn.asp"-->
<!--#include file="../common/inc/permission_manage.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_sms.asp"-->
<!--#include file="../common/api/cls_xml.asp"-->
<%
Dim smscontent,mobiles,mobile,msg
mobiles = Dream3CLS.RParam("mobile")
smscontent = Dream3CLS.RParam("smscontent")
smscontent = Dream3CLS.vbsUnEscape(smscontent)
mobileArray = split(mobiles,",")

msg = ""


For i = 0 to UBound(mobileArray)
	mobile =  mobileArray(i)
	If mobile <> "" Then
		If  Dream3CLS.validate(mobile,4) Then
			result = Dream3SMS.SendSMS(mobile,smscontent)
			
			If result <> "success" Then
				msg = msg & ","&mobile
			End If
		Else
			msg = msg & ","&mobile
		End If
	End If
	
Next
If Len(msg) > 0 Then
	response.Write(Mid(msg,2)&"这些号码发送失败")
Else
	response.Write("全部发送成功！")
End If

%>
