<%
Class  Dream3_Product

  	Private Sub Class_Initialize()
 		
	End Sub
	
	'------------------------------------
	'获取定金额度,小数取整
	Public function GetReserve(f_total_price)
		
		GetReserve =  f_total_price * Dream3CLS.SiteConfig("ReserveRate") / 100
		s_tmp = instr(GetReserve,".")
		If s_tmp > 0 Then
			If left(GetReserve,1) = "." then GetReserve = "0"&GetReserve
			
			GetReserve = CDBL(Left(GetReserve,instr(GetReserve,".") -1))

		End if
	End Function
	
	Public function GetCityAdd(f_city_id)
		Dim s_city_str
		s_province_code = mid(cstr(f_city_id),1,2) & "0000"
	    s_city_code = mid(cstr(f_city_id),1,4) & "00"
	
		Set s_rs = Server.CreateObject("adodb.recordset")			
		s_sql = "select cityName,citypostcode from T_City Where citypostcode in('"&s_province_code&"','"&s_city_code&"','"&f_city_id&"') order by citypostcode "
		't(s_sql)
		s_rs.open s_sql,conn,1,2
		s_i = 0
		Do While Not s_rs.EOF 
			if s_i = 0 Then
				s_city_str = s_city_str &s_rs("cityname")
		'	Else
		'		s_city_str = s_city_str &","&s_rs("cityname")
			End If
			s_rs.Movenext
			s_i = s_i + 1
		Loop
		GetCityAdd = s_city_str 
	End Function
	
	
	'-------------------end-------------------
	
	Public Sub GetCategory(classifier,selected)
		Dim isSelected
		Set categoryRs = Server.CreateObject("adodb.recordset")			
		Sql = "select id,cname from T_Category Where classifier='"&classifier&"' and enabled='Y' order by seqno desc"
		categoryRs.open Sql,conn,1,2
		Do While Not categoryRs.EOF 
			If CStr(categoryRs("id")) = CStr(selected) Then
				isSelected = "selected"
			Else
				isSelected = ""
			End If
			response.Write("<option "&isSelected&" value='"&categoryRs("id")&"'>"&categoryRs("cname")&"</option>")
			categoryRs.Movenext
		Loop
	End Sub
	
	
	Public Function GetCityCombo(selected)
		Dim isSelected
		Dim s_str
		Set categoryRs = Server.CreateObject("adodb.recordset")			
		Sql = "select * from T_City Where (depth=2 or zxs = 1) and enabled=1 order by cityname "
		categoryRs.open Sql,conn,1,2
		Do While Not categoryRs.EOF 
			If CStr(categoryRs("citypostcode")) = CStr(selected) Then
				isSelected = "selected"
			Else
				isSelected = ""
			End If
			s_str = s_str & "<option "&isSelected&" value='"&categoryRs("citypostcode")&"'>"&categoryRs("cityname")&"</option>"
			categoryRs.Movenext
		Loop
		GetCityCombo = s_str
		
	End Function
	
	Public sub getCategoryMap(classifier,cityMap)
		Set categoryRs = Server.CreateObject("adodb.recordset")			
		Sql = "select id,cname from T_Category Where classifier='"&classifier&"' and enabled='Y' order by seqno desc"
		categoryRs.open Sql,conn,1,2
		Do While Not categoryRs.EOF 
			cityMap.putv CStr(categoryRs("id")),categoryRs("cname")
			categoryRs.Movenext
		Loop
	End sub
	
	Public Sub getPartner(selected)
		Dim isSelected
		Set Rs = Server.CreateObject("adodb.recordset")			
		Sql = "select id,title from T_Partner Order By username"
		Rs.open Sql,conn,1,2
		Do While Not Rs.EOF 
			If CStr(Rs("id")) = CStr(selected) Then
				isSelected = "selected"
			Else
				isSelected = ""
			End If
			response.Write("<option "&isSelected&" value='"&Rs("id")&"'>"&Rs("title")&"</option>")
			Rs.Movenext
		Loop
	End Sub
	
	'得到团购的标题
	Public sub getTeamMap(teamIdArr,teamMap)
		If IsArray(teamIdArr) Then
			Dim teamInStr
			teamInStr = "("
			For i = 0 to UBound(teamIdArr)
				If i = UBound(teamIdArr) Then
					teamInStr = teamInStr & teamIdArr(i) 
				Else
					teamInStr = teamInStr & teamIdArr(i) &","
				End If
				
			Next
			teamInStr = teamInStr& ")"
		End If
		
		Set functionRs = Server.CreateObject("adodb.recordset")			
		Sql = "select id,title from T_Team Where id in "&teamInStr
		functionRs.open Sql,conn,1,2

		Do While Not functionRs.EOF 
			teamMap.putv CStr(functionRs("id")),functionRs("title")
			functionRs.Movenext
		Loop
	
	End sub
	
	'得到短租项目的数组
	Public sub getProductItemMap(productIdArr,productMap)
		If IsArray(arrU) Then
			Dim productInStr
			productInStr = "("
			For i = 0 to UBound(productIdArr)
				If i = UBound(productIdArr) Then
					productInStr = productInStr & productIdArr(i) 
				Else
					productInStr = productInStr & productIdArr(i) &","
				End If
				
			Next
			productInStr = productInStr& ")"
		End If
		
		Set functionRs = Server.CreateObject("adodb.recordset")			
		tSql = "select id,housetitle from T_Product Where id in "&productInStr
		functionRs.open tSql,conn,1,2
		Dim fArray(2)
		Do While Not functionRs.EOF 
			fArray(0) = functionRs("housetitle")
			'fArray(1) = functionRs("end_time")
			productMap.putv CStr(functionRs("id")),fArray
			functionRs.Movenext
		Loop
	
	End sub
	
	'得到用户的标题
	Public sub getUserMap(userIdArr,userMap)
		If IsArray(userIdArr) Then
			Dim userInStr
			
			userInStr = "("
			For i = 0 to UBound(userIdArr)
				If i = UBound(userIdArr) Then
					userInStr = userInStr & userIdArr(i) 
				Else
					userInStr = userInStr & userIdArr(i) &","
				End If
				
			Next
			userInStr = userInStr& ")"
		End If
		
		Set functionRs = Server.CreateObject("adodb.recordset")			
		Sql = "select id,username,email,mobile,face from T_User Where id in "&userInStr
		
		functionRs.open Sql,conn,1,2
		Dim fArray(4)
		Do While Not functionRs.EOF 
			fArray(0) = functionRs("username")
			fArray(1) = functionRs("email")
			fArray(2) = functionRs("mobile")
			fArray(3) = functionRs("face")
			userMap.putv CStr(functionRs("id")),fArray
			functionRs.Movenext
		Loop
	
	End sub
	
	'得到城市
	Public sub getCityMap(cityIdArr,cityMap)
		If IsArray(cityIdArr) Then
			Dim cityInStr
			cityInStr = "("
			For i = 0 to UBound(cityIdArr)
				If i = UBound(cityIdArr) Then
					cityInStr = cityInStr & "'"&cityIdArr(i)&"'" 
				Else
					cityInStr = cityInStr &"'" & cityIdArr(i) &"',"
				End If
				
			Next
			cityInStr = cityInStr& ")"
		End If
		
		Set functionRs = Server.CreateObject("adodb.recordset")			
		Sql = "select * from T_City Where citypostcode in "&cityInStr
		functionRs.open Sql,conn,1,2
		Dim fArray(2)
		Do While Not functionRs.EOF 
			fArray(0) = functionRs("cityname")
			
			cityMap.putv CStr(functionRs("citypostcode")),fArray
			functionRs.Movenext
		Loop
	
	End sub
	
	Public Function GetUserById(f_userid)
		f_sql = "select * from T_User where id="&f_userid
		Set getUserById = Dream3CLS.Exec(f_sql)
		If getUserById.EOF Then
			Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			response.End()
		End If
    End Function
	
	
	Public Function GetProductById(f_teamid)
		f_sql = "select * from T_Product where id="&f_teamid
		Set GetProductById = Dream3CLS.Exec(f_sql)
		If GetProductById.EOF Then
			Call Dream3CLS.MsgBox2("无法找到该短租信息！",0,"0")
			response.End()
		End If
    End Function
	
	Public Function GetOrderByOrderNo(f_order_no)
		If Len(Cstr(f_order_no)) > 12 Then
			f_sql = "Select * from T_Order Where order_no='"&f_order_no&"'"
		Else
			f_sql = "Select * from T_Order Where  id="&cint(f_order_no)
		End If
	
		Set GetOrderByOrderNo = Dream3CLS.Exec(f_sql)
    End Function
	
	Public Function GetPartnerById(f_partnerid)
		f_sql = "select * from T_Partner where id="&f_partnerid
		Set GetPartnerById = Dream3CLS.Exec(f_sql)
		If GetPartnerById.EOF Then
			Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			response.End()
		End If
    End Function
	
	
	'插入数据到财务记录表
	Public sub WriteToFinRecord(f_user_id,f_admin_id,f_detail_id,f_orderNo,f_direction,f_action,f_money)
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_Fin_Record "
		
		Rs.open Sql,conn,1,2
		Rs.AddNew
		Rs("user_id") 	= f_user_id
		Rs("admin_id") 	= f_admin_id
		Rs("detail_id") 	= f_detail_id
		Rs("order_no") 	= f_orderNo
		Rs("direction") 	= f_direction
		Rs("action") 	= f_action
		Rs("money") 	= f_money
		Rs("create_time")= Now()
		Rs.Update
		Rs.Close
		Set Rs = Nothing
	End sub
	
	
	
	'插入Email到T_Subscribe表
	Public Sub WriteToSubscribe(f_email,f_city_id,f_enabled)
		Set f_Rs = Server.CreateObject("Adodb.recordset")
		f_Sql = "Select * From T_Subscribe where email='"&f_email&"'"
		
		f_Rs.open f_sql,conn,1,2
		If f_Rs.EOF Then
			f_Rs.AddNew
			f_Rs("email") = f_email
			f_Rs("enabled") = f_enabled
			f_Rs("secret") 	= Dream3CLS.GetRandomize(32)
		End If
		
		f_Rs("city_id") 	= f_city_id

		f_Rs.Update
		f_Rs.Close
		Set f_Rs = Nothing
	End sub
	
	'过滤图片地址
	Public Function FilterImage(f_image)
		FilterImage = Replace(f_image,"../","")
    End Function
	
	'过滤图片地址
	Public Function FilterContentImage(s_content)
		FilterContentImage = Replace(s_content,"../../UploadFile","UploadFile")
    End Function
	
	'得到公告，参数city_id
	Public Function getBulletin(f_city_id)
		f_sql = "select * from T_Bulletin where city_id="&f_city_id
		Set f_rs = Dream3CLS.Exec(f_sql)
		If f_rs.EOF Then
			getBulletin = ""
		Else 
			getBulletin = f_rs("content")
			getBulletin = FilterContentImage(getBulletin)
		End If
    End Function
	
	Public Function getCityName(f_city_id,f_default_empty_cityname)
		If f_city_id = 0 Then
			getCityName = f_default_empty_cityname
		Else
			Set f_Rs = Server.CreateObject("adodb.recordset")			
			Sql = "select id,cname from T_Category Where classifier='city' and id="&f_city_id
			f_Rs.open Sql,conn,1,2
			getCityName = f_Rs("cname")
		End If
	End Function
	
	Public Function GetMailList(f_city_id)
		Set f_Rs = Server.CreateObject("adodb.recordset")	
		Sql = "select email from T_Subscribe Where enabled='Y'"		
		If cstr(f_city_id) <> "0" Then
			Sql = sql &" and (city_id="&f_city_id &" or city_id=0)"
		End If
		f_Rs.open Sql,conn,1,1
		if   not   (f_Rs.eof   or   f_Rs.bof)   then 
			GetMailList = f_Rs.getrows(-1)
		else
			GetMailList = ""
		end   if
		
	End Function
	
	
	Public Function GetSMSList(f_city_id)
		Set f_Rs = Server.CreateObject("adodb.recordset")		
		Sql = "select mobile from T_SMSSubscribe Where enabled='Y'"		
		If cstr(f_city_id) <> "0" Then
			Sql = sql &" and (city_id="&f_city_id &" or city_id=0)"
		End If	
		f_Rs.open Sql,conn,1,1
		if   not   (f_Rs.eof   or   f_Rs.bof)   then 
			GetSMSList = f_Rs.getrows(-1)
		else
			GetSMSList = ""
		end   if
		
	End Function
	
	'得到所有手机号
	Public Function GetAllSMSList()
		Set f_Rs = Server.CreateObject("adodb.recordset")		
		Sql = "select mobile from T_User Where enabled='Y' and mobile <> ''"		
		f_Rs.open Sql,conn,1,1
		If   not   (f_Rs.eof   or   f_Rs.bof)   then 
			GetAllSMSList = f_Rs.getrows(-1)
		Else
			GetAllSMSList = ""
		End   if
		
	End Function
	
	'判断用户是否还有订单
	Public Function IsUserOrder(f_user_id)
		f_sql = "Select Count(o.id) From T_Order o,T_Product t Where o.state='unpay' and o.user_id="&f_user_id &" and o.product_id=t.id "
	
		If IsSQLDataBase = 1 Then
			'f_sql = f_sql&" and Datediff(s,GetDate(),t.end_time)>=0 "
		Else
			'f_sql = f_sql&" and Datediff('s',Now(),t.end_time)>=0 "
		End If
		Set f_rs = Dream3CLS.Exec(f_sql)
		If f_rs(0) > 0 Then
			IsUserOrder = true
		Else
			IsUserOrder = false
		End If
		
	End Function
	
	'随机生成订单号
	Function GetOrderNumber()
		Dim Tempddh,ddhBool,ON_rs
		ddhBool=true
		randomize
		Tempddh=right(year(now()),2)&right("0"&month(now()),2)&right("0"&day(now()),2)&right("0"&hour(now()),2)&right("0"&Minute(now()),2)&right("0"&Second(now()),2)&right("00"&Trim(int(Rnd()*10)),2)
		do while ddhBool
			set ON_rs=Dream3CLS.Exec("select order_no from T_Order where order_no='"&Tempddh&"'")
			if ON_rs.eof and ON_rs.bof then
				ddhBool=false
				Tempddh=right(year(now()),2)&right("0"&month(now()),2)&right("0"&day(now()),2)&right("0"&hour(now()),2)&right("0"&Minute(now()),2)&right("0"&Second(now()),2)&right("00"&Trim(int(Rnd()*10)),2)
			end if
			set ON_rs=nothing
		loop
		GetOrderNumber=Tempddh
	End Function
	
	'更新邀请的状态
	Public Sub UpdateInviteInfo(f_to_user_id,f_team_id,f_state)
		Set f_rs = Server.CreateObject("adodb.recordset")			
		f_sql = "Select * From T_Invite Where other_user_id ="&f_to_user_id 
		f_rs.open f_sql,conn,1,2
		If f_rs.EOF Then
			Exit Sub
		Else
			f_rs("team_id") = f_team_id
			f_rs("state") = f_state
			f_rs("buy_time") = Now()
			f_rs("credit") = SiteConfig("InviteBonus")
			f_rs.Update
			f_rs.Close
			Set f_rs = Nothing
		End If
	End Sub
	
	'团购成功后，进行返利
	Sub UpdateBonus(s_user_id,s_team_id,s_bonus)
		'给自己返利，返积分
		'1.给自己账户增加奖金
		s_bonus = CDBL(s_bonus)
		If s_bonus > 0 Then
			Dream3User.AddOrDeductUserMoney s_user_id,s_bonus
			'WriteToFinRecord bonus 代表奖金
			Dream3Team.WriteToFinRecord s_user_id,0,s_team_id,"income","bonus",s_bonus
		End If
		
	End Sub
	
	'订单成功，发送短信给用户
	Sub SendOrderSuccessSMS(s_order_id)
		On error resume next
		Dim s_content,s_result
		If Cint(Dream3CLS.SiteConfig("OrderOKSMS")) = 0 Then Exit Sub
		
		s_sql = "select * From T_Order Where id="&s_order_id
		Set s_rs = Dream3CLS.Exec(s_sql)
		s_express = s_rs("express")
		s_product_id = s_rs("product_id")
		s_user_id = s_rs("user_id")
		s_mobile = s_rs("mobile")
		s_sql = "select * From T_Product Where id="&s_team_id
		Set s_rs = Dream3CLS.Exec(s_sql)
		s_title = s_rs("title")
		s_product = s_rs("product")
		

		s_content = GetSMSOrderSuccessContent(s_product,s_express,s_CouponCode,s_CouponSecret)

		s_result = Dream3SMS.SendSMS(s_mobile,s_content)

		
	End Sub
	
	Function GetSMSOrderSuccessContent(s_product,s_express,s_CouponCode,s_CouponSecret)
		
		Dim HtmlSMS,s_tpl_name
		If s_express = "N" then
			s_tpl_name = "sms_coupon_content"
		Else
			s_tpl_name = "sms_express_content"
		End If
		HtmlSMS = Dream3Tpl.LoadTemplate(s_tpl_name)
		HtmlSMS = Replace(HtmlSMS, "{$SiteName}",SiteConfig("SiteName"))
		HtmlSMS = Replace(HtmlSMS, "{$TeamTitle}",s_product)
		HtmlSMS = Replace(HtmlSMS, "{$CouponCode}",s_CouponCode)
		HtmlSMS = Replace(HtmlSMS, "{$CouponSecret}",s_CouponSecret)
		GetSMSOrderSuccessContent = HtmlSMS
	End Function
	
	'得到团购API的RS
	Public Sub GetRsForAPI(s_rs)
		Dim s_searchStr
'结束时间大于等于明早0点'开始时间小于等于今天凌晨
		
		If IsSQLDataBase = 1 Then
			s_searchStr = s_searchStr&" and Datediff(s,GetDate(),end_time)>=0  and Datediff(s,GetDate(),start_time)<=0"
		Else
			s_searchStr = s_searchStr&" and Datediff('s',Now(),end_time)>=0  and Datediff('s',Now(),start_time)<=0"
		End If
		
		'当前团购，按seqno排序，按地区显示
		s_searchStr = s_searchStr &" and (state='success' or state='normal') "
		
		s_Sql = "Select id,start_time,title,city_id,market_price,team_price,image,pre_number,min_number,seqno,summary,end_time,detail ,userreview,systemreview,partner_id,conduser,max_number,reach_time,partner_id from T_Team Where 1=1 "&s_searchStr
		s_Sql = s_Sql &" Order By city_id,[Seqno] Desc"
		
		Set s_rs = Dream3CLS.Exec(s_Sql)
	End Sub 
	
	
	'----------------------------new-------------------------------------
	'房源修改后，将相关订单失效
	Public sub setInvalidOrderWhenReedit(f_product_id, f_op_user_id, f_ismanager)
		 
		Set f_rs = Server.CreateObject("adodb.recordset")			
		Sql = "select * from T_Order Where state in ('unconfirm','unpay','lodgercancel','ownercancel') and product_id="&f_product_id
		f_rs.open Sql,conn,1,2
		
		Do While Not f_rs.EOF 
			'成功的标准：预设值+订单值大于最小的值
			f_order_id = f_rs("id")
			f_order_no = f_rs("order_no")
			f_product_id = f_rs("product_id")
			f_order_status = f_rs("state")
			f_comment = ""
			
			f_set_order_status = "failed"
			
			Set oRs = Server.CreateObject("Adodb.recordset")
			o_sql = "Select * From T_Order  Where id="&f_order_id
			oRs.open o_sql,conn,1,2
			oRs("state") = f_set_order_status
			oRs.Update
			oRs.Close	
			Set oRs = nothing		
			
			Set f_product_rs = GetProductById(f_product_id)
			f_user_id = f_product_rs("user_id")
			If  f_op_user_id <> f_user_id Then
				f_user_type = "manager"
			Else
				f_user_type = "owner"
			End If
			
						
			WriteToOrderTrans "reedit", f_op_user_id, f_user_type, f_order_id, f_set_order_status ,f_comment
				
			
			f_rs.Movenext
		Loop
	
	End sub
	
	'插入数据到订单记录表
	Public sub WriteToOrderTrans(f_action, f_user_id, f_user_type, f_order_id, f_order_status ,f_comment)
		Set otransRs = Server.CreateObject("Adodb.recordset")
		f_sql = "Select * From T_Trans  Where order_id="&f_order_id
		otransRs.open f_sql,conn,1,2
		otransRs.AddNew()
		
		otransRs("order_status") = f_order_status
		otransRs("order_id") = f_order_id
		otransRs("create_time") = Now()
		otransRs("user_type") = f_user_type
		otransRs("comment") = f_comment
		otransRs("action") = f_action
		otransRs("user_id") = f_user_id
		
		otransRs.Update
		otransRs.Close	
		Set otransRs = nothing	
	End sub
	
	' 发送房东确认短信
	Sub SendOwnerConfirmSMS(f_result, f_mobile, f_order_no)
	
		If Cint(Dream3CLS.SiteConfig("OrderOKSMS")) <> 1  Then Exit Sub
		If IsNull(f_mobile) Or Len(f_mobile) <=0 Then Exit Sub
		f_content = GetOwnerConfirmSMSContent(f_order_no)

		f_result = Dream3SMS.SendSMS(f_mobile,f_content)

	End Sub
	
	' 发送房东取消短信
	Sub SendOwnerCancelSMS(f_result, f_mobile, f_order_no)

		If Cint(Dream3CLS.SiteConfig("OrderOKSMS")) <> 1  Then Exit Sub
		If IsNull(f_mobile) Or Len(f_mobile) <=0 Then Exit Sub
		f_content = GetOwnerCancelSMSContent(f_order_no)

		f_result = Dream3SMS.SendSMS(f_mobile,f_content)

	End Sub
	
	Function GetOwnerConfirmSMSContent(f_order_no)
		Dim HtmlSMS
		HtmlSMS = Dream3Tpl.LoadTemplate("sms_ownerconfirm_content")
		HtmlSMS = Replace(HtmlSMS, "{$SiteName}",Dream3CLS.SiteConfig("SiteName"))
		HtmlSMS = Replace(HtmlSMS, "{$OrderNo}",f_order_no)
		GetOwnerConfirmSMSContent = HtmlSMS
	End Function
	
	Function GetOwnerCancelSMSContent(f_order_no)
		Dim HtmlSMS
		HtmlSMS = Dream3Tpl.LoadTemplate("sms_ownercancel_content")
		HtmlSMS = Replace(HtmlSMS, "{$SiteName}",Dream3CLS.SiteConfig("SiteName"))
		HtmlSMS = Replace(HtmlSMS, "{$OrderNo}",f_order_no)
		GetOwnerCancelSMSContent = HtmlSMS
	End Function
	
	'获取订单总价
	Function GetTotalPrice(f_checkintype, f_checkindays, f_checkinRoomNum, f_dayrentprice , f_weekrentprice,f_monthrentprice)
		If f_checkintype = "perDay" Then
			f_singlePrice = f_dayrentprice
			f_totalPrice = f_checkindays * f_singlePrice * f_checkinRoomNum
		Elseif f_checkintype = "perWeek"  Then
			f_singlePrice = Dream3CLS.FormatNumbersNil(f_weekrentprice / 7 , 0)
			f_moddays = f_checkindays mod 7
			f_totalPrice = ((f_checkindays - f_moddays) / 7 * f_weekrentprice + (f_moddays * f_singlePrice )) * f_checkinRoomNum
		Elseif f_checkintype = "perMonth"  Then
			f_singlePrice = Dream3CLS.FormatNumbersNil(f_monthrentprice / 30, 0)
			f_moddays = f_checkindays mod 30
			f_totalPrice = ((f_checkindays - f_moddays) / 30 * f_monthrentprice + (f_moddays * f_singlePrice )) * f_checkinRoomNum
		End If
		GetTotalPrice = f_totalPrice
	End Function
	
	'获取订单总价
	Function GetSinglePrice(f_checkintype, f_checkindays, f_dayrentprice , f_weekrentprice,f_monthrentprice)
		If f_checkintype = "perDay" Then
			f_singlePrice = f_dayrentprice
		Elseif f_checkintype = "perWeek"  Then
			f_singlePrice = Dream3CLS.FormatNumbersNil(f_weekrentprice / 7 , 0)
			
		Elseif f_checkintype = "perMonth"  Then
			f_singlePrice = Dream3CLS.FormatNumbersNil(f_monthrentprice / 30, 0)
			
		End If
		GetSinglePrice = f_singlePrice
	End Function
	
	'获取支付类型
	Function GetCheckinType(f_checkindays, f_dayrentprice , f_weekrentprice,f_monthrentprice)
		If f_checkindays > 6 and f_checkindays < 30 and f_weekrentprice > 0 Then
			f_checkintype = "perWeek"
		Elseif checkindays >= 30 and f_monthrentprice > 0 Then
			f_checkintype = "perMonth"
		Elseif checkindays >= 30 and f_monthrentprice = 0 and f_weekrentprice > 0 Then
			f_checkintype = "perWeek"
		Else
			f_checkintype = "perDay"
		End If
		GetCheckinType = f_checkintype
	End Function
	'新增加内容，获取房间所属酒店名称
	Public function GetHotelname(h_hid)
		Dim s_hotel_str
		Set s_rs = Server.CreateObject("adodb.recordset")			
		s_sql = "select h_hotelname from T_hotel Where h_id ="&h_hid
		't(s_sql)
		s_rs.open s_sql,conn,1,2
		s_hotel_str = s_rs("h_hotelname")
			
		GetHotelname = s_hotel_str 
	End Function
	'获取酒店所有房间名称
	Public function GetRoomname(h_hid)
		Set categoryRs = Server.CreateObject("adodb.recordset")			
		Sql = "select * from T_Product Where hid='"&h_hid&"' and enabled='Y'  and online='Y' and  state='normal' order by id desc"
		categoryRs.open Sql,conn,1,2
		Do While Not categoryRs.EOF 
			response.Write("<option  value='"&categoryRs("id")&"'>"&categoryRs("houseTitle")&"</option>")
			categoryRs.Movenext
		Loop
	End Function
	'获取酒店所有图片
	Public function GetHotelimg(h_hid,h_img)
		Dim s_hotel_img,s_img
		Set s_rs = Server.CreateObject("adodb.recordset")		
		s_sql = "Select * from T_Product Where hid="&h_hid&" and online='Y'"
		't(s_sql)
		s_rs.open s_sql,conn,1,2
		if h_img<>"" then
			s_hotel_img=h_img&","
		end if
		Do While Not s_rs.EOF 
			if s_rs("image")<>"" then
				s_hotel_img=s_hotel_img&s_rs("image")&","
			end if
			if s_rs("image1")<>"" then
				s_hotel_img=s_hotel_img&s_rs("image1")&","
			end if
			if s_rs("image2")<>"" then
				s_hotel_img=s_hotel_img&s_rs("image2")&","
			end if
			if s_rs("image3")<>"" then
				s_hotel_img=s_hotel_img&s_rs("image3")&","
			end if
			if s_rs("image4")<>"" then
				s_hotel_img=s_hotel_img&s_rs("image4")&","
			end if
			if s_rs("image5")<>"" then
				s_hotel_img=s_hotel_img&s_rs("image5")&","
			end if
			if s_rs("image6")<>"" then
				s_hotel_img=s_hotel_img&s_rs("image6")&","
			end if
			if s_rs("image7")<>"" then
				s_hotel_img=s_hotel_img&s_rs("image7")&","
			end if
			if s_rs("image8")<>"" then
				s_hotel_img=s_hotel_img&s_rs("image8")&","
			end if
			if s_rs("image9")<>"" then
				s_hotel_img=s_hotel_img&s_rs("image9")&","
			end if
			s_rs.Movenext
		Loop
		if right(s_hotel_img,1)="," then 
			s_hotel_img=left(s_hotel_img,len(s_hotel_img)-1) 
		end if 
		s_img=Split(s_hotel_img,",")
		GetHotelimg = s_img 
	End Function
	'获取相关推荐酒店
	Public function GetAboutHotel(h_hid)
		Dim h_citycode,searchStr,num,h_img,citycod,h_hotelname,h_id,h_star
		num=10
		Set Rss = Server.CreateObject("adodb.recordset")			
		Sql = "select * from T_hotel where h_id="&h_hid
		Rss.open Sql,conn,1,2
		h_citycode=Rss("h_citycode")
		if not Rss.EOF then
			If Right(h_citycode,4) = "0000" Then
				searchStr =" and h_citycode like '"&Left(h_citycode,2)&"%'"
			Else
				searchStr = " and h_citycode like '"&Left(h_citycode,4)&"%'"
			End If
		end if
		Set Rs = Server.CreateObject("adodb.recordset")	
		Sql = "select top "&num&"* from T_hotel where 1=1"&searchStr
		Rs.open Sql,conn,1,2
		Do While Not Rs.EOF 
			if Rs("h_img")="" then
				h_img="images/noimage.gif"
			else
				h_img=Rs("h_img")
			end if
			h_id=Rs("h_id")
			h_hotelname=Rs("h_hotelname")
			citycod=Rs("h_citycode")
			h_star=Rs("h_star")
			response.Write("<li><img src="&h_img&" alt="&h_hotelname&"><span>"&Dream3Product.GetCityAdd(citycod)&"——<a href=show.asp?hid="&h_id&">"&h_hotelname&"</a><br />星级："&h_star&"</span></li>")
			Rs.Movenext
		Loop
	End Function	
	'
End Class

Dim Dream3Product
Set Dream3Product = New Dream3_Product

%>