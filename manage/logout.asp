<!--#include file="../conn.asp"-->
<%
	CleanCookies()
	session.Abandon()
	response.Redirect(VirtualPath &"/index.asp")
%>