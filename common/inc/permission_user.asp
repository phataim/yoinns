<%
If Session("_UserID") = "" Then
	Response.Redirect(VirtualPath&"/user/account/login.asp")
End If
%>
