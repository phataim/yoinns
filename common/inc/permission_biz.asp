<%
If Session("_PUserID") = "" Then
	Response.Redirect(VirtualPath &"/biz/login.asp")
End If
%>
