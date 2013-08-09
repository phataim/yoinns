<!--#include file="../../conn.asp"-->
<%
If SiteConfig("RegType") = "1" Then
	response.Redirect("sms.asp")
Else
	response.Redirect("normal.asp")
End If

%>