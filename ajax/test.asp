<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<%
Response.Expires = -1
Response.ExpiresAbsolute = Now() - 1
Response.cachecontrol = "no-cache"
id = CInt(trim(request("id")))
Sql = "Select * from T_Product Where id="&id
set rs = Dream3CLS.Exec(sql)
roomsnum = rs("roomsnum") 
if not rs.eof then			
response.Write(roomsnum)
else
response.Write(0)
end if
			

%>