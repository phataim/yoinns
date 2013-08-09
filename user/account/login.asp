<!--#include file="../../conn.asp"-->
<%
'If SiteConfig("RegType") = "1" Then
	'response.Redirect("smslogin.asp")
'Else
	response.Redirect("normallogin.asp")
'End If

%>