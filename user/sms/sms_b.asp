<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="m_codepublic.asp"-->
<%
args=ConvertHTML(request("args"))
'response.write "0"
'response.write args
response.write "<br><br><br>"

'65356862,132710,15388650501,%b2%e2%ca%d4%b6%cc%d0%c51,2012-5-23 11:38:46;65356862,132710,15321858155,%b2%e2%ca%d4%b6%cc%d0%c52,2012-5-23 11:38:49

if (Instr(args,",")>0) then '如果内容有逗号

	call mdb_name(user_mdb)

	if Instr(args,";")>0 then ' 如果有多组数据
		data_t=Split(args,";") '分解数据
		For i = 0 To Ubound(data_t) '作用：读取最大序号
			sql="select * from sms_back"
			ps.open sql,comm,1,3
			ps.addnew
			data_a=Split(data_t(i),",") '分解数据
			if Ubound(data_a)<> 4 then call js_jump("格式不对， 逗号少于4个","")
				ps("no1")=data_a(0) '
				ps("no2")=data_a(1) '
				ps("t_no")=data_a(2) '手机号
				ps("t_text")=data_a(3) '回复内容
				ps("t_time")=data_a(4) '回复时间
			ps.update
			ps.close
			

			sql="select * from [sms] where (t_no='"&data_a(2)&"' and is_back=1) order by id desc" '先排序该手机号与接收一致, 并需要回复的手机号
			ps.open sql,comm,1,3
			 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			do while not ps.eof

				if data_a(3)=ps("r_no1") then ' 验证码相同时 确认回复
					if ps("sort_name")="T_Order" then '属于订单回复
						'==================================================================================================================================================
						' 确定订单操作
						sql = "select * from T_Order where id = " & ps("sort_id") & " "
						
						Set Rs = Dream3CLS.Exec(Sql)
						If Rs.EOF Then
							Call Dream3CLS.MsgBox2("无法找到该订单！",0,"0")
							response.End()
						End If
						
						If (Rs("state") <> "unconfirm")  Then
							Call Dream3CLS.MsgBox2("无法取消该订单！",0,"0")
							response.End()
						End If
						
						f_order_no = Rs("order_no") '订单号
						user_mobile = Rs("mobile") '用户手机号
						owner_mobile=data_a(2) '商家手机号
						product_id=Rs("product_id") '记录product_id
						rs.close
						
						Sql = "Update  T_Order set state = 'unpay' Where id="&ps("sort_id")&" "
						
						Dream3CLS.Exec(Sql)

						Sql = "Select hid  from T_Product Where id="&product_id
						Rs.open Sql,conn,1,2
							hhid=rs("hid")
						Rs.Close
						Sql = "Select h_hotelname from T_hotel Where h_id="&hhid
						Rs.open Sql,conn,1,2
							hh_hotelname=rs("h_hotelname") '商家旅店名称
						Rs.Close

						'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
						' 操作完回复短信给商家和用户 
					
						'owner_id_sms '商家ID
						'user_id_sms '用户ID						
						'owner_mobile '商家手机号
						'user_mobile '用户手机号
						sms_owner="尊敬的“有旅馆”商家, 订单确认"&f_order_no&" 成功! 现等住户付款中, 请确保房间留出,谢谢!【有旅馆】" '短信内容
						sms_user="尊敬的用户，商家"&hh_hotelname&"已确认了订单，订单编号为"&f_order_no&"，请尽快登陆“有旅馆”（yoinns.com)支付, 确保到店有房，谢谢！【有旅馆】"

						if sms_open=0 then
							at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '给商家发短信
							at2=mt(user_mobile,sms_user,ext,stime,rrid) '给用户发短信
							
							'call sms_save(owner_mobile,"","","",product_id,"ok_back_T_Order_owner",at1,0,4) '商家保存
							'call sms_save(user_mobile,"","","",product_id,"ok_back_T_Order_user",at2,0,4) '用户保存
						end if
							'owner_mobile
							owner_r_no1=""
							owner_r_no2=""
							owner_r_no3=""
							owner_order_id=product_id
							owner_order_name="ok_back_T_Order_owner"
							owner_is_back=0
							
							'user_mobile
							user_r_no1=""
							user_r_no2=""
							user_r_no3=""
							user_order_id=product_id
							user_order_name="ok_back_T_Order_user"
							user_is_back=0
						'==================================================================================================================================================
						'操作完成
					
					end if
					
					ps("is_back")=2 '标记已回复
					ps.update
					is_run=1 '标记进来过
					exit do
				elseif data_a(3)=ps("r_no2") then '取消回复
					if ps("sort_name")="T_Order" then '属于订单回复
						'==================================================================================================================================================
						' 确定订单操作
	
						sql = "select * from T_Order where id = " & ps("sort_id") & " "
						
						Set Rs = Dream3CLS.Exec(Sql)
							If Rs.EOF Then
								Call Dream3CLS.MsgBox2("无法找到该订单！",0,"0")
								response.End()
							End If
							
							If (Rs("state") <> "unconfirm" and  Rs("state") <> "unpay")  Then
								Call Dream3CLS.MsgBox2("无法取消该订单！",0,"0")
								response.End()
							End If
							
							f_order_no = Rs("order_no") '订单号
							user_mobile = Rs("mobile") '用户手机号
							owner_mobile=data_a(2) '商家手机号
							product_id=Rs("product_id") '记录product_id
						Rs.Close
													
						Sql = "Update  T_Order set state = 'ownercancel' Where id = " & ps("sort_id")
						Dream3CLS.Exec(Sql)
						

						'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
						' 操作完回复短信给商家和用户 
					
						'owner_id_sms '商家ID
						'user_id_sms '用户ID						
						'owner_mobile '商家手机号
						'user_mobile '用户手机号
						sms_owner="尊敬的“有旅馆”商家, 订单确认"&f_order_no&" 已取消! 请保持网站信息准确性会带来更多的生意, 请留意,谢谢!【有旅馆】" '短信内容
						sms_user="尊敬的用户,非常抱歉! 商家"&hh_hotelname&"里的, 订单编号为"&f_order_no&", 房间已订完, 该订单已取消，带来不便敬请原谅, 请尽快登陆 yoinns.com 选其它房间,谢谢!【有旅馆】"

						if sms_open=0 then
							at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '给商家发短信
							at2=mt(user_mobile,sms_user,ext,stime,rrid) '给用户发短信
							
							'call sms_save(owner_mobile,"","","",product_id,"ng_back_T_Order_owner",at1,0,4) '商家保存
							'call sms_save(user_mobile,"","","",product_id,"ng_back_T_Order_user",at2,0,4) '用户保存
						end if
							'owner_mobile
							owner_r_no1=""
							owner_r_no2=""
							owner_r_no3=""
							owner_order_id=product_id
							owner_order_name="ng_back_T_Order_owner"
							owner_is_back=0
							
							'user_mobile
							user_r_no1=""
							user_r_no2=""
							user_r_no3=""
							user_order_id=product_id
							user_order_name="ng_back_T_Order_user"
							user_is_back=0
						'==================================================================================================================================================
						'操作完成
					end if
					ps("is_back")=2 '标记已回复
					ps.update
					is_run=1 '标记进来过
					exit do
				end if
			
			ps.movenext 
			loop 
			''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			ps.close
			if is_run<>1 then '如果回复的短信数据库里没找到相应记录时
				response.Write " 没有找到发送记录"
			else

				call sms_save(owner_mobile,owner_r_no1,owner_r_no2,owner_r_no3,owner_order_id,owner_order_name,at1,owner_is_back,4) '商家保存
				call sms_save(user_mobile,user_r_no1,user_r_no2,user_r_no3,user_order_id,user_order_name,at2,user_is_back,4) '用户保存
				response.Write "已发送成功!"
			
				
			end if
	
			
				
		next
	else '只有单组数据
		sql="select * from sms_back"
		ps.open sql,comm,1,3
		ps.addnew
		data_a=Split(args,",") '分解数据
		if Ubound(data_a)<> 4 then call js_jump("格式不对， 逗号少于4个","")
			ps("no1")=data_a(0)
			ps("no2")=data_a(1)
			ps("t_no")=data_a(2)
			ps("t_text")=data_a(3)
			ps("t_time")=data_a(4)
		ps.update
		ps.close
		
		
'''''''''''''''''''''''''''''		
			sql="select * from [sms] where (t_no='"&data_a(2)&"' and is_back=1) order by id desc" '先排序该手机号与接收一致, 并需要回复的手机号
			ps.open sql,comm,1,3
			 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			do while not ps.eof

				if data_a(3)=ps("r_no1") then ' 验证码相同时 确认回复
					if ps("sort_name")="T_Order" then '属于订单回复
						'==================================================================================================================================================
						' 确定订单操作
						sql = "select * from T_Order where id = " & ps("sort_id") & " "
						
						Set Rs = Dream3CLS.Exec(Sql)
						If Rs.EOF Then
							Call Dream3CLS.MsgBox2("无法找到该订单！",0,"0")
							response.End()
						End If
						
						If (Rs("state") <> "unconfirm")  Then
							Call Dream3CLS.MsgBox2("无法取消该订单！",0,"0")
							response.End()
						End If
						
						f_order_no = Rs("order_no") '订单号
						user_mobile = Rs("mobile") '用户手机号
						owner_mobile=data_a(2) '商家手机号
						product_id=Rs("product_id") '记录product_id
						rs.close
						
						Sql = "Update  T_Order set state = 'unpay' Where id="&ps("sort_id")&" "
						
						Dream3CLS.Exec(Sql)

						Sql = "Select hid  from T_Product Where id="&product_id
						Rs.open Sql,conn,1,2
							hhid=rs("hid")
						Rs.Close
						Sql = "Select h_hotelname from T_hotel Where h_id="&hhid
						Rs.open Sql,conn,1,2
							hh_hotelname=rs("h_hotelname") '商家旅店名称
						Rs.Close

						'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
						' 操作完回复短信给商家和用户 
					
						'owner_id_sms '商家ID
						'user_id_sms '用户ID						
						'owner_mobile '商家手机号
						'user_mobile '用户手机号
						sms_owner="尊敬的“有旅馆”商家, 订单确认"&f_order_no&" 成功! 现等住户付款中, 请确保房间留出,谢谢!【有旅馆】" '短信内容
						sms_user="尊敬的用户，商家"&hh_hotelname&"已确认了订单，订单编号为"&f_order_no&"，请尽快登陆“有旅馆”（yoinns.com)支付, 确保到店有房，谢谢！【有旅馆】"

						if sms_open=0 then
							at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '给商家发短信
							at2=mt(user_mobile,sms_user,ext,stime,rrid) '给用户发短信
							
							'call sms_save(owner_mobile,"","","",product_id,"ok_back_T_Order_owner",at1,0,4) '商家保存
							'call sms_save(user_mobile,"","","",product_id,"ok_back_T_Order_user",at2,0,4) '用户保存
						end if
							'owner_mobile
							owner_r_no1=""
							owner_r_no2=""
							owner_r_no3=""
							owner_order_id=product_id
							owner_order_name="ok_back_T_Order_owner"
							owner_is_back=0
							
							'user_mobile
							user_r_no1=""
							user_r_no2=""
							user_r_no3=""
							user_order_id=product_id
							user_order_name="ok_back_T_Order_user"
							user_is_back=0
						'==================================================================================================================================================
						'操作完成
					
					end if
					
					ps("is_back")=2 '标记已回复
					ps.update
					is_run=1 '标记进来过
					exit do
				elseif data_a(3)=ps("r_no2") then '取消回复
					if ps("sort_name")="T_Order" then '属于订单回复
						'==================================================================================================================================================
						' 确定订单操作
	
						sql = "select * from T_Order where id = " & ps("sort_id") & " "
						
						Set Rs = Dream3CLS.Exec(Sql)
							If Rs.EOF Then
								Call Dream3CLS.MsgBox2("无法找到该订单！",0,"0")
								response.End()
							End If
							
							If (Rs("state") <> "unconfirm" and  Rs("state") <> "unpay")  Then
								Call Dream3CLS.MsgBox2("无法取消该订单！",0,"0")
								response.End()
							End If
							
							f_order_no = Rs("order_no") '订单号
							user_mobile = Rs("mobile") '用户手机号
							owner_mobile=data_a(2) '商家手机号
							product_id=Rs("product_id") '记录product_id
						Rs.Close
													
						Sql = "Update  T_Order set state = 'ownercancel' Where id = " & ps("sort_id")
						Dream3CLS.Exec(Sql)
						

						'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
						' 操作完回复短信给商家和用户 
					
						'owner_id_sms '商家ID
						'user_id_sms '用户ID						
						'owner_mobile '商家手机号
						'user_mobile '用户手机号
						sms_owner="尊敬的“有旅馆”商家, 订单确认"&f_order_no&" 已取消! 请保持网站信息准确性会带来更多的生意, 请留意,谢谢!【有旅馆】" '短信内容
						sms_user="尊敬的用户,非常抱歉! 商家"&hh_hotelname&"里的, 订单编号为"&f_order_no&", 房间已订完, 该订单已取消，带来不便敬请原谅, 请尽快登陆 yoinns.com 选其它房间,谢谢!【有旅馆】"

						if sms_open=0 then
							at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '给商家发短信
							at2=mt(user_mobile,sms_user,ext,stime,rrid) '给用户发短信
							
							'call sms_save(owner_mobile,"","","",product_id,"ng_back_T_Order_owner",at1,0,4) '商家保存
							'call sms_save(user_mobile,"","","",product_id,"ng_back_T_Order_user",at2,0,4) '用户保存
						end if
							'owner_mobile
							owner_r_no1=""
							owner_r_no2=""
							owner_r_no3=""
							owner_order_id=product_id
							owner_order_name="ng_back_T_Order_owner"
							owner_is_back=0
							
							'user_mobile
							user_r_no1=""
							user_r_no2=""
							user_r_no3=""
							user_order_id=product_id
							user_order_name="ng_back_T_Order_user"
							user_is_back=0
						'==================================================================================================================================================
						'操作完成
					end if
					ps("is_back")=2 '标记已回复
					ps.update
					is_run=1 '标记进来过
					exit do
				end if
			
			ps.movenext 
			loop 
			''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			ps.close
			if is_run<>1 then '如果回复的短信数据库里没找到相应记录时
				response.Write " 没有找到发送记录"
			else

				call sms_save(owner_mobile,owner_r_no1,owner_r_no2,owner_r_no3,owner_order_id,owner_order_name,at1,owner_is_back,4) '商家保存
				call sms_save(user_mobile,user_r_no1,user_r_no2,user_r_no3,user_order_id,user_order_name,at2,user_is_back,4) '用户保存
				response.Write "已发送成功!"
			
				
			end if
'''''''''''''''''''''''''''''		
	
	end if
	response.Write "0"
else
	response.Write "1"
end if






















































%>