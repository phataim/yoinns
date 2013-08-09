<!--#include file="../conn.asp"-->
<!--#include file="../common/inc/permission_manage.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_email.asp"-->
<%
Dim mailcontent,email,mailtitle,msg
email = Dream3CLS.RParam("email")
mailtitle = Dream3CLS.vbsUnEscape(Dream3CLS.RParam("mailtitle"))
mailcontent = Dream3CLS.vbsUnEscape(Dream3CLS.RParam("mailcontent"))
emailArray = split(email,",")

mailtitle = Dream3CLS.GetMailTitle(mailtitle)

msg = ""

For i = 0 to UBound(emailArray)
	If emailArray(i) <> "" Then
		If  Dream3CLS.IsValidEmail(emailArray(i)) Then
			cmEmail.SendMail emailArray(i),mailtitle,mailcontent
			If cmEmail.Count>0 Then
			'发送成功
			Else
				msg = msg & ","&emailArray(i)
			End If
		Else
			msg = msg & ","&emailArray(i)
		End If
	End If
	
Next
If Len(msg) > 0 Then
	response.Write(Mid(msg,2)&"这些Email发送失败")
Else
	response.Write("全部发送成功！")
End If

%>
