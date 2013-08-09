<!--#include file="conn.asp"-->
<!--#include file="user/sms/m_codepublic.asp"-->
<%		

	order_id=session("order_id") 'order_id 
	order_no=session("order_no") 'order_no
	user_id_sms=session("user_id") '用户ID
	owner_id_sms=session("owner_id") '商家ID
	owner_mobile=session("owner_mobile") '商家手机号
	user_mobile=session("user_mobile") '用户手机号

	'owner_id_sms 
	'user_id_sms
	'owner_mobile '商家手机号
	'user_mobile  '用户手机号
	
	if owner_mobile<>"" and user_mobile<>"" then
response.write "<br>进入支付成功发短信环节"				
		sms_owner="尊敬的“有旅馆'商家,恭喜！订单编号"&order_no&"支付成功，如要查看详情，请登录有旅馆（yoinns.com)商家后台查看，谢谢！如有任何疑问，欢迎致电有旅馆客服电话020-34726441.【有旅馆】"
			
		sms_user="尊敬的“有旅馆”用户,恭喜！您的订单（订单编号："&order_no&"）支付成功！请您按时入住，如果整个过程中有任何疑问，欢迎致电有旅馆客服电话020-34726441。最后祝您入住愉快，您的十分满意，是我们的十分动力！【有旅馆】"
			
response.write "<br>准备进入短信环节"				
		'sms_save(电话,验证码1,验证码2,验证码3,类型id,类型名称,是否需要收用户回短信,当前位置) '保存
		if sms_open=0 then
			at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '给商家发短信
			at2=mt(user_mobile,sms_user,ext,stime,rrid) '给用户发短信
response.write "<br>进入短信环节"				
		end if
				
			'owner_mobile
		owner_r_no1=""
		owner_r_no2=""
		owner_r_no3=""
		owner_order_id=order_id
		owner_order_name="Pay_ok_T_Order_owner"
		owner_is_back=0
							
		'user_mobile
		user_r_no1=""
		user_r_no2=""
		user_r_no3=""
		user_order_id=order_id
		user_order_name="Pay_ok_T_Order_user"
		user_is_back=0
				
		call sms_save(owner_mobile,owner_r_no1,owner_r_no2,owner_r_no3,owner_order_id,owner_order_name,at1,owner_is_back,0) '商家保存
		call sms_save(user_mobile,user_r_no1,user_r_no2,user_r_no3,user_order_id,user_order_name,at2,user_is_back,0) '用户保存
response.write "<br>存储短信环节"				
		
		' 清空session
		session("order_id")="" 'order_id 
		session("order_no")="" 'order_no
		session("user_id")="" '用户ID
		session("owner_id")="" '商家ID
		session("owner_mobile")="" '商家手机号
		session("user_mobile")="" '用户手机号
		
	end if	
		
%>