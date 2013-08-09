<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/inc/permission_user.asp"-->
<!--#include file="../common/api/cls_map.asp"-->
<!--#include file="../common/api/cls_product.asp"-->
<%

Dim outStr,product_id,modifyDate,newPrice,imfomation

product_id =  Dream3CLS.RParam("product_id")
modifyDate =  Dream3CLS.RParam("date")
newPrice = Dream3CLS.RParam("price")
imfomation =  Dream3CLS.RParam("description")

'response.write( "product_id="&product_id) 
'response.write( " modifyDate="&modifyDate) 
'response.write( " price="&newPrice) 


	Set Rs = Server.CreateObject("Adodb.recordset")
	'拼日期的查询条件 注意 这里的时间条件必须要有单引号 日期必须为 date > '2012-10-17' 这样的带引号格式	
	Sql  = "select * from T_SpecialPrice where product_id = "&product_id&" and  date> = '"&Cdate(modifyDate)&"' and date< '"&DateAdd("d", 1, Cdate(modifyDate))&"'" 


	'Sql = "select * from T_Product where ID = "&product_id


	Rs.open Sql,conn,1,2

	'If new_price <> "" Then
		
	Rs("price") 	= Cint(newPrice)
	'End If

	'Rs("imfomation") 	= imfomation

	Rs.Update
	outStr = Cstr(Rs("price"))
	Rs.Close


'outStr="{'modifyResult':'true'}"
response.Write("修改成功")
%>
