<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->

<%



	''''''ÿ�충������������
	orderSql = "Select * from T_Order Where user_id="&session("_UserID")&" and state = 'unconfirm'"&" and create_time > '"&date()&"' and create_time < '"&Dateadd("d",1,date())&"'"

	Set Rs = Server.CreateObject("Adodb.recordset")
	Rs.open orderSql,conn,1,2	
		If Rs.recordcount > 10 then
			response.write("Ԥ������ô��ң���Ϣһ�°�~")
		else
			response.write("legal")
		end if 
		
	Rs.Close
%>
