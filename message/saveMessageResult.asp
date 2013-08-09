<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<%
Dim content

'If Session("_UserID") = "" Then
	'Response.Write("请先登录系统!")
	'Response.End()
'End If

content = Dream3CLS.RParam("content")
content = Dream3CLS.VbsUnEscape(content)

If Len(Content) =0 or Len(Content) > 500 Then
	Response.Write("留言内容不能为空，且不要超过500！")
	Response.End()
End If


Sql = "Select * From T_Message "

Rs.open Sql,conn,1,2
Rs.AddNew
Rs("user_id") = Dream3CLS.ChkNumeric(Session("_UserID"))
Rs("content") = Dream3CLS.HTMLEncode(content)
Rs("create_time") = Now()
Rs.Update
Rs.Close
Set Rs = Nothing
Response.Write("success")
%>


