<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<%
Response.Expires = -1
Response.ExpiresAbsolute = Now() - 1
Response.cachecontrol = "no-cache"

cityId = CInt(left(request("cityId"),4))


sql="select CityID, CityPostCode, CityName from T_City where "
sql=sql&" Left(CityPostCode,4)='"&cityId&"' and Right(CityPostCode, 2) <> '00' order by [CityID]"
set rs = Dream3CLS.Exec(sql)
			
while not rs.bof and not rs.eof
	outStr=outstr & rs("CityPostCode")&"-"&rs("CityName") & ","
	rs.movenext
wend
			

outStr=left(outStr, len(outStr)-1)	'remove the last ','
response.Write(outStr)
%>