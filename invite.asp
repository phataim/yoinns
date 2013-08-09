<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_user.asp"-->
<%
	Dim userId 
	userId = Dream3CLS.ChkNumeric(Request.QueryString("code"))
	If userId <> 0 Then
		Response.Cookies(DREAM3C).Expires = Date + 7
		Response.Cookies(DREAM3C)("_InviteUserID") = userId
	End If
	
	't(request.Cookies(DREAM3C)("_InviteUserID"))
	Response.Redirect("index.asp")
%>
