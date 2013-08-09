<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->
<!--#include file="user/sms/m_codepublic.asp"-->


<!--#include file="common/api/cls_email.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount

Dim RoomDesc '房间描述
Dim lodgeType '房屋类型
Dim leaseType '出租类型
Dim area '面积
Dim guestnum '可住人数
Dim roomsnum '房间数 
Dim bednum '床位数
Dim bedtype '床型 
Dim toiletnum  '卫生间数
Dim checkouttime '退房时间
Dim checkintime '入住时间
Dim minday  '最少天数
Dim maxday '最多天数
Dim invoice ' 发票
Dim facilities '设施
Dim address ' 地址
Dim housetitle ' 房屋标题
Dim dayrentprice,weekrentprice,monthrentprice

Dim img1,img2,img3,img4,img5,img6,img7,img8,img9,img10
Dim userid,pid,detail_id
Dim userIdArr(0) ,userMap

Dim mobile ,username ,realname, zipcode,email,remark


Dim checkinRoomNum,startdate,enddate,checkintype
Dim checkindays, singlePrice ,totalPrice 
Dim onlinepayamount '在线支付金额
Dim offlinepayamount '线下支付金额

'此处特殊跳转到登陆注册混合页面
If Session("_UserID") = "" Then
	Response.Redirect(VirtualPath&"/user/account/fromlistlogin.asp")
End If


Set userMap = new AspMap

Action = Request.QueryString("act")
Select Case Action
	Case "saveorder"
		Call SaveOrder()
	Case "normal"
		Call normal()
	Case Else
		Call Main()
End Select

       
Sub SaveOrder()


	

	pid = Dream3CLS.ChkNumeric(Request.Form("pid"))
	
	checkinRoomNum = Dream3CLS.ChkNumeric(Request.Form("checkinRoomNum"))
	checkintype = Dream3CLS.RSQL("checkintype")
	startdate = Dream3ClS.RSQL("startdate")
	enddate = Dream3ClS.RSQL("enddate")
	
	mobile = Dream3ClS.RSQL("mobile")
	realname = Dream3ClS.RSQL("realname")
	email = Dream3ClS.RSQL("email")
	remark = Dream3ClS.RSQL("remark")
	

	Set tRs = Dream3Product.getProductById(pid)
	'判断日期,如果开始，结束日期不在房间范围内，则无法预定
	'If DateDiff("s",tRs("expireDate"),CDate(endDate)) > 0 Then
		'gMsgArr = "您的预定天数大于可预定的最多天数("&maxday&")天！"
		'gMsgFlag = "E"
		'Call Main()
		'Exit Sub
	'End If
	
	If tRs("state") <> "normal" Then
		gMsgArr = "非法操作，不可预定的房间！"
		gMsgFlag = "E"
		Call Main()
		Exit Sub
	End If
	
	dayrentprice = tRs("dayrentprice") 
	weekrentprice = tRs("weekrentprice") 
	monthrentprice = tRs("monthrentprice") 
	order_days = tRs("order_days")
	order_days = "," &order_days&","
	
	checkindays = datediff("d",startdate,enddate)
	
	If checkindays < minday Then
		Call Dream3CLS.MsgBox2("您的预定天数小于可预定的最小天数("&minday&")天！",0,"0")
		Response.End()
	End If
	
	If (maxday > 0 and checkindays > maxday) Then
		Call Dream3CLS.MsgBox2("您的预定天数大于可预定的最多天数("&maxday&")天！",0,"0")
		Response.End()
	End If
	
	'是否超过30天
	If (checkindays > 30) Then
		Call Dream3CLS.MsgBox2("目前您只能预定一个月内的房间！",0,"0")
		Response.End()
	End If
	
	
	
	
	
	
'''''''''''''''''''''''''''''''''''''''''''''''''以下内容被D霸哥注释掉'''''''''''''''''''''''''''''''''''''''''''''
'	'租房日期是否已经被预定 
'	For i = 0 To checkindays - 1
'		fDays = Dream3CLS.Formatdate(DateAdd("d", i, startdate) , 2)
'		If instr(order_days , ","&fDays&",") > 0  Then
'			Call Dream3CLS.MsgBox2("您所预定的房间在"&fDays&"已被预定！",0,"0")
'			Response.End()
'		End If
'	Next
'	
'	Sql = "Select Top 1 * from T_Order Where user_id="&session("_UserID") &" And product_id="&pid
'	Rs.open Sql,conn,1,2
'	If Rs.EOF Then
'		Rs.AddNew
'		Rs("order_no") = Dream3Product.GetOrderNumber()
''		Rs("owner_id") = tRs("user_id")
'	Else
'		If  Rs("state") = "unpay" Then
'			gMsgArr = "您要预定的产品已经经过房东确认，请到'我的订单'进行付款！"
'			gMsgFlag = "E"
'			Call Main()
'			Exit Sub
'		End If
'	End If
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



''''''''''''''''''''''''''''''''''''''''''''以下内容被D霸哥重写''''''''''''''''''''''''''''''''''''''''''''''''''''''

'	'租房日期是否已经被预定 
'	For i = 0 To checkindays - 1
'		fDays = Dream3CLS.Formatdate(DateAdd("d", i, startdate) , 2)
'		If instr(order_days , ","&fDays&",") > 0  Then
'			Call Dream3CLS.MsgBox2("您所预定的房间在"&fDays&"已被预定！",0,"0")
'			Response.End()
'		End If
'	Next
	
	Sql = "Select Top 1 * from T_Order Where user_id="&session("_UserID") &" And product_id="&pid
	Rs.open Sql,conn,1,2
'	If Rs.EOF Then
		Rs.AddNew
		order_no_sms= Dream3Product.GetOrderNumber() '保存订单号 mike
		Rs("order_no") = order_no_sms '保存订单号 mike
 	    Rs("owner_id") = tRs("user_id")
		owner_id_sms = tRs("user_id") '保留商家id mike
		houseTitle = tRs("houseTitle") '保留房间名 mike

'	'Else
'		If  Rs("state") = "unpay" Then
'			gMsgArr = "您要预定的产品已经经过房东确认，请到'我的订单'进行付款！"
'			gMsgFlag = "E"
'			Call Main()
'			Exit Sub
'		End If
'	End If
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	
	checkintype = Dream3Product.GetCheckinType(checkindays, dayrentprice, weekrentprice, monthrentprice )
		
	singlePrice = Dream3Product.GetSinglePrice(checkintype, checkindays, dayrentprice, weekrentprice, monthrentprice )
		
	totalPrice = countTotalPrice()



	Rs("user_id") 	= Session("_UserID")
		user_id_sms = Session("_UserID") ' 记录下用户ID Mike
	Rs("admin_id") 	= 0
	Rs("product_id") 	= pid
	Rs("state") 	= "unconfirm" '待确认
	Rs("realname") 	= realname
	Rs("mobile") 	= mobile
		user_mobile = mobile '用户手机号 mike
	Rs("zipcode") 	= zipcode
	Rs("address") 	= address
	Rs("email") 	= email
	Rs("remark") = remark
	Rs("start_date")= startdate
	Rs("end_date")= enddate
	Rs("create_time")= Now()
	
	
	Rs("checkindays") = checkindays
	Rs("checkintype")= checkintype  'perday,perweek,permonth
	Rs("roomnum")= checkinRoomNum
	
	
	
	Rs("city_code") = tRs("city_code")
	
	'add by xiaoyaohang 下单后发送提醒邮件
	 serviceEmailXht = "123619503@qq.com"
	 serviceEmailLzp = "dk@yoinns.com"
	 serviceEmailXyh = "15920544859@139.com"
		
		topic = "有订单啦哈哈哈哈"
		mailbody = "有订单,从"+startdate+" 到 "+enddate+",订单号"+order_no_sms
		
		cmEmail.SendMail serviceEmailXht,topic,mailbody
		cmEmail.SendMail serviceEmailLzp,topic,mailbody
		cmEmail.SendMail serviceEmailXyh,topic,mailbody
	
	If checkintype = "perDay" Then
		Rs("singleprice")= tRs("dayrentprice")
	Elseif checkintype = "perWeek" Then
		Rs("singleprice")= tRs("weekrentprice")
	Elseif checkintype = "perMonth" Then
		Rs("singleprice")= tRs("monthrentprice")
	End If
	
	

	Rs("reserve")= Dream3Product.GetReserve(totalPrice)
	Rs("totalmoney")= totalPrice
	
	Rs.Update
	order_id = Rs("id")
	Rs.Close
	
	'Call Main()
	'Response.Redirect(VirtualPath &"/user/lodger/order.asp")
	
	
	
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''mike
	Sql = "Select hid  from T_Product Where id="&pid
	Rs.open Sql,conn,1,2
		hhid=rs("hid")
	Rs.Close
	
	Sql = "Select h_hotelname from T_hotel Where h_id="&hhid
	Rs.open Sql,conn,1,2
		hh_hotelname=rs("h_hotelname") '商家旅店名称
	Rs.Close
	
	Sql = "Select mobile from T_User Where id="&owner_id_sms
	Rs.open Sql,conn,1,2
		owner_mobile=rs("mobile") '商家手机号
	Rs.Close
	
	Sql = "Select id from T_Order Where order_no="&order_no_sms
	Rs.open Sql,conn,1,2
		order_id=rs("id") '订单id
	Rs.Close
	
	Set Rs = Nothing

	'owner_id_sms '商家ID
	'user_id_sms '用户ID
	
	'owner_mobile '商家手机号
	'user_mobile '用户手机号

	r_no1=Rnd_no(6) '需要4位随机码
	r_no2=Rnd_no(6) '需要4位随机码
	sms_owner="尊敬的“有旅馆”商家,用户"&realname&"预定了您'"&hh_hotelname&"'旅店下的'"&houseTitle&"'房间("&startdate&"~"&enddate&",共"&datediff("d",startdate,enddate)&" 天,共"&totalPrice&"元),确认订单请回复"&r_no1&" ,取消订单请回复"&r_no2&" .谢谢!【有旅馆】" '短信内容
	
	sms_user="尊敬的“有旅馆”用户,我们会尽快处理您订单,感谢您的预定！【有旅馆】" '短信内容
	
	'sms_save(电话,验证码1,验证码2,验证码3,类型id,类型名称,是否需要收用户回短信,当前位置) '保存
	if sms_open=0 then
		at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '给商家发短信
		at2=mt(user_mobile,sms_user,ext,stime,rrid) '给用户发短信
		
	end if
		call sms_save(owner_mobile,r_no1,r_no2,"",order_id,"T_Order",at1,1,0) '商家保存
		call sms_save(user_mobile,"","","",order_id,"T_Order",at2,0,0) '用户保存
	
	

	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''mike

	response.Write "OK?"
	'response.End()
	
	Dream3CLS.showMsg "您的订单已创建，正在提交房东进行确认，请耐心等待，谢谢！","S", VirtualPath &"/user/lodger/order.asp"
	
	
	
	
End Sub

Sub Main()		
	
	'得到城市的ID，如果找不到，则默认为全部
		pid = Dream3CLS.ChkNumeric(Request("pid"))
		detail_id= Dream3CLS.ChkNumeric(Request("detail_id"))
		checkinRoomNum = Dream3CLS.ChkNumeric(Request("checkinRoomNum"))
		checkintype = Dream3CLS.RParam("checkintype")
		startdate = Dream3ClS.RParam("startdate")
		enddate = Dream3ClS.RParam("enddate")

		'房间数要大于1
		If checkinRoomNum < 1 Then
			Call Dream3CLS.MsgBox2("要选择房间数！",0,"0")
			Response.End()
		End If
		
		'首先判断结束日期要大于等于开始日期
		If not  isdate(startdate) Then
			Call Dream3CLS.MsgBox2("起始日期格式不正确！",0,"0")
			Response.End()
		End If
		If not  isdate(enddate) Then
			Call Dream3CLS.MsgBox2("结束日期格式不正确！",0,"0")
			Response.End()
		End If
		
		'如果开始日期小于今天
		If DateDiff("d",startDate,Now()) > 0 Then
			Call Dream3CLS.MsgBox2("起始日期不能小于今天！",0,"0")
			Response.End()
		End If
		
		'计算租房时间
		checkindays = datediff("d",startdate,enddate)
		
		If checkindays < 1 Then
			Call Dream3CLS.MsgBox2("结束日期不能小于起始日期！",0,"0")
			Response.End()
		End If
		
		
		
		
		Sql = "Select * from T_Product Where id="&detail_id&" and hid="&pid
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Rs.EOF Then
			Dream3CLS.showMsg "您要查询的短租信息不存在！","S","error.asp"
			Response.End()
		End If
		
		minday = Rs("minday")
		maxday  = Rs("maxday")
		order_days = Rs("order_days")
		'if maxday = 0 then maxday = "无限制"
		If IsNull(order_days) Then order_days = ""
		order_days = ","&order_days&","
		
		'计算租房时间
		checkindays = datediff("d",startdate,enddate)
		
		If checkindays < minday Then
			Call Dream3CLS.MsgBox2("您的预定天数小于可预定的最小天数("&minday&")天！",0,"0")
			Response.End()
		End If
		
		If (maxday > 0 and checkindays > maxday) Then
			Call Dream3CLS.MsgBox2("您的预定天数大于可预定的最多天数("&maxday&")天！",0,"0")
			Response.End()
		End If
		
		'是否超过30天
		If (checkindays > 30) Then
			Call Dream3CLS.MsgBox2("目前您只能预定一个月内的房间！",0,"0")
			Response.End()
		End If
		
		
		
		
''''''''''''''''''''''''''''''''''''''''''''''''以下内容被D霸哥注释掉'''''''''''''''''''''''''''''''''''''''''''''		
'		'租房日期是否已经被预定 
'	'	For i = 0 To checkindays - 1
'			fDays = Dream3CLS.Formatdate(DateAdd("d", i, startdate) , 2)
'			If instr(order_days , ","&fDays&",") > 0  Then
'				Call Dream3CLS.MsgBox2("您所预定的房间在"&fDays&"已被预定！",0,"0")
'				Response.End()
'			End If
'		Next
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''		



		RoomDesc = Rs("RoomDesc")
		lodgeType = Rs("lodgeType")
		leaseType = Rs("leaseType")
		area = Rs("area")
		guestnum = Rs("guestnum")
		roomsnum = Rs("roomsnum")
		If roomsnum = 11 then roomsnum = "大于10"
		bednum = Rs("bednum")
		If bednum = 11 then bednum = "大于10"
		bedtype = Rs("bedtype")
		bedtype = Dream3Static.GetBedType(bedtype)
		
		
		toiletnum = Rs("toiletnum")
		If toiletnum = 11 then toiletnum = "大于10"
		checkouttime= Rs("checkouttime")
		checkintime  = Rs("checkintime")
		
		invoice = Rs("invoice")
		address = Rs("address")
		housetitle = Rs("housetitle")
		facilities = Rs("facilities")
		facilities = ","&facilities&","
		
		img1 = Rs("image")  
		img2 = Rs("image1")  
		img3 = Rs("image2")  
		img4 = Rs("image3")  
		img5 = Rs("image4")  
		img6 = Rs("image5")  
		img7 = Rs("image6")  
		img8 = Rs("image7")  
		img9 = Rs("image8")  
		img10 = Rs("image9") 
		
		dayrentprice = Rs("dayrentprice") 
		weekrentprice = Rs("weekrentprice") 
		monthrentprice = Rs("monthrentprice") 
		
		'判断房间支付方式
		'If checkindays > 6 and checkindays < 30 and weekrentprice > 0 Then
			'checkintype = "perWeek"
		'Elseif checkindays >= 30 and monthrentprice > 0 Then
			'checkintype = "perMonth"
		'Elseif checkindays >= 30 and monthrentprice = 0 and weekrentprice > 0 Then
			'checkintype = "perWeek"
		'Else
			'checkintype = "perDay"
		'End If
		checkintype = Dream3Product.GetCheckinType(checkindays, dayrentprice, weekrentprice, monthrentprice )
		
		singlePrice = Dream3Product.GetSinglePrice(checkintype, checkindays, dayrentprice, weekrentprice, monthrentprice )
		
		totalPrice = countTotalPrice()
		
		'If checkintype = "perDay" Then
			'singlePrice = dayrentprice
			'totalPrice = checkindays * singlePrice * checkinRoomNum
		'Elseif checkintype = "perWeek"  Then
			'singlePrice = Dream3CLS.FormatNumbersNil(weekrentprice / 7 , 0)
			'moddays = checkindays mod 7
			'totalPrice = ((checkindays - moddays) / 7 * weekrentprice + (moddays * singlePrice )) * checkinRoomNum
		'Elseif checkintype = "perMonth"  Then
			'singlePrice = Dream3CLS.FormatNumbersNil(monthrentprice / 30, 0)
			'moddays = checkindays mod 30
			'totalPrice = ((checkindays - moddays) / 30 * monthrentprice + (moddays * singlePrice )) * checkinRoomNum
		'End If
		
		'计算价格
		'totalPrice = checkindays * singlePrice * checkinRoomNum
		
		
		
		
		userid = Rs("user_id")

		userIdArr(0) = userid
		
		
		Call Dream3Product.getUserMap(userIdArr,userMap)
		
		' 获取用户资料
		Set tRs = Dream3Product.getUserById(session("_UserID"))
		mobile = tRs("mobile")
		username = Session("_UserName")
		realname = tRs("realname")
		   if (realname="") then
                      realname="确保姓名正确"
       End If
		address = tRs("address")
		zipcode = tRs("zipcode")
		email = tRs("email")
End Sub
	
function countTotalPrice()
	
	Dim sumPrice
	sumPrice = 0
	
	Select Case Action
	Case "saveorder"
		'拼日期的查询条件 注意 这里的时间条件必须要有单引号 日期必须为 date > '2012-10-17' 这样的带引号格式	
	    Sql  = "select * from T_SpecialPrice where product_id = "&pid&"and  date>= '"&Cdate(startdate)&"' and date< '"&Cdate(enddate)&"'" 
	Case Else
		'拼日期的查询条件 注意 这里的时间条件必须要有单引号 日期必须为 date > '2012-10-17' 这样的带引号格式	
	    Sql  = "select * from T_SpecialPrice where product_id = "&detail_id&"and  date>= '"&Cdate(startdate)&"' and date< '"&Cdate(enddate)&"'" 
End Select
	
	
	
	Set pRs = Dream3CLS.Exec(Sql)
	Do While Not pRs.EOF
		sumPrice = sumPrice + Cint(pRs("price"))
		pRs.Movenext
	Loop
	pRs.close
	countTotalPrice = sumPrice
end function	
%>
<%
G_Title_Content = "预定房间"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="content_wrapper">
	
    <div class="yuding_box">
        
        <div class="part1_bg">
            <ul>
                <li class="num_01"><h2>客房预订</h2></li>
                <li class="num_02"><h3>支付定金</h3></li>
                <li class="num_03"><h3>完成</h3></li>
            </ul>
        </div>
        
        <div class="line_one"></div>
        
        <div class="part1_cc">
            如下是您的订单信息，请确认后提交。注意：<br>
            1. 在提交前请确认您的入住信息，提交后房东将会收到您的预订请求。<br>
            2. 请仔细阅读“<a href="help/index.asp?c=pay"target="_blank">交易规则</a>”，保证您清楚了解<%=Dream3CLS.SiteConfig("SiteShortName")%>交易流程及内容。<br />
            3. 如果房东在24小时内接受或拒绝您的订房请求，我们将会用短信和邮件的方式来通知您。<br>
            4. 如果您想取消预订，请登录，在"用户中心"页面点击取消订单。<br>
            5. 如果您有其他疑问，请拨打我们客服电话：<%=Dream3CLS.SiteConfig("ServicePhone")%>（<%=Dream3CLS.SiteConfig("ServiceTime")%>）
        </div>
        
        <div class="part2_cc">
        	<div class="part2_cct"></div>
            <div class="part2_ccm">
                <span class="pic_tu"><img src="<%=img1%>" width="325" height="245"></span>
                <ul class="part2_c">
                <span class="title_c"><h3><%=Dream3Product.GetHotelname(pid)%></h3><h4><%=housetitle%></h4></span>
                <h5 class="title_c2"></h5>
                    <ol class="cont_cc">
                    <li><h3>入住时间：</h3><h4><%=startdate%>  <%=checkintime%></h4></li>
                    <li><h3>退房时间：</h3><h4><%=enddate%>  <%=checkouttime%></h4></li>
                    <li><h3>入住天数：</h3><h4><%=checkindays%></h4></li>
                    <li><h3>房间数量：</h3><h4><%=checkinRoomNum%></h4></li>
                    </ol>
                </ul>
            </div>
        	<div class="part2_ccb"></div>
        </div>
          <% 
             
             asd=Request.form("startdate") 
             fgh=Request.form("enddate")
             tian= getallprice(startdate,enddate)
             onlinepayamount = Dream3Product.GetReserve(totalPrice)
		offlinepayamount = totalPrice - onlinepayamount
             %>
        <div class="part2_cc">
        	<div class="part2_cct"></div>
            <div class="part2_ccm">
                <table cellspacing="0" cellpadding="0" border="0" width="100%" class="house-adr">
                <tbody>
                    <tr>
                        <th>类别</th>
                        <!--<th>单价</th>-->
                        <th>房间</th>
                        <th>天数</th>
                        <th>总价</th>
                        <th>在线应付订金（<%=Dream3CLS.SiteConfig("ReserveRate")%>%）</th>
                        <th>线下支付房东</th>                        
                    </tr>
                    <tr class="tr">
                        <td>
						<%If checkintype = "perWeek" Then%>
						按周计算
						<%Elseif checkintype = "perMonth" Then%>
						按月计算
						<%Else%>
						按天计算
						<%End If%>
						</td>
                        <!--<td>
						<%If checkintype = "perWeek" Then%>
						每周￥<%=weekrentprice%><br>
						按周计算折合单价
						<%Elseif checkintype = "perMonth" Then%>
						每月￥<%=monthrentprice%><br>
						按月计算折合单价
						<%Else%>
						每天￥<%=dayrentprice%><br>
						按天计算单价
						<%End If%>
						￥<%=singlePrice%>
						</td>-->
                        <td><%=checkinRoomNum%></td>
                        <td><%=checkindays%></td>
                        <td  class="jq">￥<%=totalPrice%></td>
                        <td  class="jq">￥<%=onlinepayamount%></td>
                        <td  class="jq">￥<%=offlinepayamount%></td>                        
                    </tr>
                </tbody>
                </table>
                <div class="sm">*房东付款规则规定在线支付订金比例<%=Dream3CLS.SiteConfig("ReserveRate")%>%，之后房东为您预留房，保证您的正常入住。  </div>
            </div>
            <div class="part2_ccb"></div>            
        </div>
        
		<form method="post" name="orderForm" action="buy.asp?act=saveorder">
		<input type="hidden" name="pid" value="<%=detail_id%>"/>
		<input type="hidden" name="checkinRoomNum" value="<%=checkinRoomNum%>"/>
		<input type="hidden" name="startdate" value="<%=startdate%>"/>
		<input type="hidden" name="enddate" value="<%=enddate%>"/>
		<input type="hidden" name="checkintype" value="<%=checkintype%>"/>
        <div class="part2_cc">
        	<div class="part2_cct"></div>
            <div class="part2_ccm">
            	
                <ul class="zltx_left zltx_left_noimage">
                    <h3>请填写您的联系信息</h3>
                    <ol>
                        <li><h4>姓&#12288;名：</h4>
                        <h5><input type="text" id="realname" class="input_bg" name="realname" value="<%=realname%>"onblur="if(this.value==''){this.value='确保姓名正确';this.style.color='#ff0000'}" onfocus="if(this.value=='确保姓名正确'){this.value='';this.style.color='#333'}" value="确保姓名正确" autocomplete="off" style="color: rgb(153, 153, 153); ">
                        <span id="tip_username" style="font-size:18px; color:#ee0000">&nbsp;*</span></h5>
                        </li>
                        <li><h4>手&#12288;机：</h4><h5>
                        <input type="text" maxlength="11" id="mobile" class="input_bg" name="mobile" value="<%=mobile%>">
                        <span id="tip_phone" style="font-size:18px; color:#ee0000">&nbsp;*</span></h5></li>
                        
                        <!--
                        <li><h4>邮&#12288;箱：</h4><h5><input type="text" id="email" class="input_bg" name="email" value="<%=email%>">
                        <span id="tip_email"></span></h5></li>
                        -->
                    </ol>
                </ul>
                
            </div>
            <div class="part2_ccb"></div>            
        </div>
        
        <div class="part1_cc" style="display:none ">
            <strong>交易规则</strong><br>
            1.订单确认后，房客需在线预付658元（总房租的100%）作为订金 。<br>
            2.房客在2012-03-21日的14:00之前取消，预付订金全额退还房客。<br>
            3.房客在2012-03-21日的14:00之后，2012-03-22日的14:00之前取消订单，扣除658元。<br>
            4.房客入住后提前退房，<%=Dream3CLS.SiteConfig("SiteShortName")%>与房东将分别从剩余天数的订金和线下付款中扣除100% 。<br>
            5.订单的取消时间以<%=Dream3CLS.SiteConfig("SiteShortName")%>系统中记录的订单取消时间为准。<br>
            6.额外的服务费用和押金不包含在总房租内，由房东线下收取。<br>
            7.如果任何一方投诉，必须在入住24小时内通知<%=Dream3CLS.SiteConfig("SiteShortName")%>。<br>
            8.如有必要，<%=Dream3CLS.SiteConfig("SiteShortName")%>将会进行调解，并具有所有争端的最终决定权。<br>
        </div>
        
        <div class="line_one"></div>
        
        <!--提交前检查姓名的js，霸爷首发------------------>
        <script type="text/javascript">
        	
            function check_and_submit(){
            	if (document.getElementById("realname").value=="确保姓名正确")
            	{
            		//alert("填写姓名啊，亲(⊙v⊙)");
            		document.getElementById("realname").value="";
            		document.orderForm.submit();
            	}
            	else
            	{
            		document.orderForm.submit();
            	}
            }
        </script>
        
        
        <div class="part4_cc">
        	<p style="cursor:pointer;" id="book" class="yuding_bg" onclick="check_and_submit();">立即预订</p>
        </div>
		</form>
        
    </div>
    
</div>
<%
if request("key")="go" then

  startdate=request("startdate")
  enddate=request("enddate")

if IsDate(date1)=false or IsDate(date2)=false then
  response.write "时间类型有问题!"
  response.end
end if
  response.write getallprice(startdate,enddate)

end if

'date1=#2012-7-16#
'date2=#2012-8-8#
function getallprice(date1,date2)
s=0
d_temp=abs(DateDiff("d",date1,date2)) '两个日期相差的天数
'response.write "在"&date1&"~"&date2&"里有以下周六日<br><br>"
if d_temp<62 then '相差日期小于62天时
  n_data=date1
  for i=1 to d_temp
    w_temp=Weekday(n_data,2) '读取date1 的星期值
    if ( w_temp=5 or w_temp=6 ) and ( n_data<date2 )then '如果是周六日时

      'response.write n_data '显示周六日
      'response.write "<br>"
      s=s+weekrentprice'只要在这里累加周六日的价格就可以了
      else
      s=s+dayrentprice
    end if
    n_data=DateAdd("d", 1, n_data) '加一天
  next
else
  response.write "两个日期超出2个月了!"
end if
getallprice=s
end function
%>
<!--#include file="common/inc/footer_user.asp"-->