<%

session("order_id")=265 'order_id 
session("order_no")=12110316413306 'order_no
session("user_id")=45 '用户ID
session("owner_id")=36 '商家ID
session("owner_mobile")=13712935490 '商家手机号
session("user_mobile")=13267924046  '用户手机号
	

response.redirect "m_send_pay.asp"	
	%>