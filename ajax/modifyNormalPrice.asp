<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/inc/permission_user.asp"-->
<!--#include file="../common/api/cls_map.asp"-->
<!--#include file="../common/api/cls_product.asp"-->
<%

Dim outStr,product_id,priceType,newPrice,dateDetect

product_id =  Dream3CLS.RParam("product_id")
priceType =  Dream3CLS.RParam("priceType")
newPrice = Dream3CLS.RParam("price")


		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_Product Where id="&product_id
		Rs.open Sql,conn,1,2
		if Cint(priceType) = 1 then
			Rs("dayrentprice") 	= Cint(newPrice)
		end if 
		if priceType = 2 then 
			Rs("weekrentprice") = Cint(newPrice)
		end if
			
		Rs.Update
		Rs.Close
		
		
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql  = "select * from T_SpecialPrice where product_id = "&product_id&"and  date> ='"&Cdate(date)&"' "
		Rs.open Sql,conn,1,2
		Do while Not Rs.EOF
			dateDetect = Cdate(Rs("date"))
			if  Cint(priceType)  = 1 then
				if not Weekday(dateDetect) = 6 and not Weekday(dateDetect) = 7 then
					Rs("price") = Cint(newPrice)
				end if 
			end if 
			
			if  Cint(priceType)  = 2 then
				if  Weekday(dateDetect) = 6 or  Weekday(dateDetect) = 7 then
					Rs("price") = Cint(newPrice)
				end if 
			end if 
			
			Rs.Update
			Rs.Movenext
		Loop			
		Rs.Close
		
	


'outStr="{'modifyResult':'true'}"
response.Write("ÐÞ¸Ä³É¹¦")

%>
