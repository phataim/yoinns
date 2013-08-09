<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->

<%

Dim outStr,product_id
Dim dateUpper, dateLower, sumPrice

product_id =  Dream3CLS.RParam("product_id")
dateUpper =  Dream3CLS.RParam("dateUpper")
dateLower = Dream3CLS.RParam("dateLower")

	sumPrice = 0
	
	'拼日期的查询条件 注意 这里的时间条件必须要有单引号 日期必须为 date > '2012-10-17' 这样的带引号格式	
	Sql  = "select * from T_SpecialPrice where product_id = "&product_id&" and  date> ='"&Cdate(dateLower)&"' and date< '"&Cdate(dateUpper)&"'" 

	Set Rs = Dream3CLS.Exec(Sql)
	Do While Not Rs.EOF
		sumPrice = sumPrice + Cint(Rs("price"))
		Rs.Movenext
	Loop
	Rs.close

'outStr="{'modifyResult':'true'}"
outStr="{""countResult"":"""+Cstr(sumPrice)+"""}"
response.Write(outStr)
%>
