<%
'Dim cookiesUserID

'�ж�IP�Ƿ�����
't(Dream3CLS.SiteConfig("IPLimit"))
If Dream3CLS.SiteConfig("IPLimit") = "1" Then
	If Not IsIPAllowed(Dream3CLS.SiteConfig("AllowIPs"),Request.ServerVariables("REMOTE_ADDR")) Then
		session.Abandon()
		gMsgArr = "����IP���޶����޷����ʣ�"
		Response.Redirect("../login.asp?gMsgArr="&gMsgArr&"&gMsgFlag=E")
	End If
End If

If Session("_IsManagerLogin") <> "Y" Then
	Response.Redirect("../login.asp")
End If

Public Function IsIPAllowed(f_ips,f_target_ip)
	If Instr(f_ips,f_target_ip) > 0 Then
		IsIPAllowed = true
	Else
		IsIPAllowed = false
	End If
End Function

%>
