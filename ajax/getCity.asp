<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<%
Response.Expires = -1
Response.ExpiresAbsolute = Now() - 1
Response.cachecontrol = "no-cache"

provinceId = CInt(left(request("provinceId"),2))


sql="select CityID, CityPostCode, CityName from T_City where Right(CityPostCode, 2) = '00'"
sql=sql&" and Left(CityPostCode,2)='"&provinceId&"' and Right(CityPostCode, 4) <> '0000' order by [CityID]"
set rs = Dream3CLS.Exec(sql)
			
while not rs.bof and not rs.eof
	outStr=outstr & rs("CityPostCode") & "-" & rs("CityName") & ","
	rs.movenext
wend
			

outStr=left(outStr, len(outStr)-1)	'remove the last ','
response.Write(outStr)
%>