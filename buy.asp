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

Dim RoomDesc '��������
Dim lodgeType '��������
Dim leaseType '��������
Dim area '���
Dim guestnum '��ס����
Dim roomsnum '������ 
Dim bednum '��λ��
Dim bedtype '���� 
Dim toiletnum  '��������
Dim checkouttime '�˷�ʱ��
Dim checkintime '��סʱ��
Dim minday  '��������
Dim maxday '�������
Dim invoice ' ��Ʊ
Dim facilities '��ʩ
Dim address ' ��ַ
Dim housetitle ' ���ݱ���
Dim dayrentprice,weekrentprice,monthrentprice

Dim img1,img2,img3,img4,img5,img6,img7,img8,img9,img10
Dim userid,pid,detail_id
Dim userIdArr(0) ,userMap

Dim mobile ,username ,realname, zipcode,email,remark


Dim checkinRoomNum,startdate,enddate,checkintype
Dim checkindays, singlePrice ,totalPrice 
Dim onlinepayamount '����֧�����
Dim offlinepayamount '����֧�����

'�˴�������ת����½ע����ҳ��
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
	'�ж�����,�����ʼ���������ڲ��ڷ��䷶Χ�ڣ����޷�Ԥ��
	'If DateDiff("s",tRs("expireDate"),CDate(endDate)) > 0 Then
		'gMsgArr = "����Ԥ���������ڿ�Ԥ�����������("&maxday&")�죡"
		'gMsgFlag = "E"
		'Call Main()
		'Exit Sub
	'End If
	
	If tRs("state") <> "normal" Then
		gMsgArr = "�Ƿ�����������Ԥ���ķ��䣡"
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
		Call Dream3CLS.MsgBox2("����Ԥ������С�ڿ�Ԥ������С����("&minday&")�죡",0,"0")
		Response.End()
	End If
	
	If (maxday > 0 and checkindays > maxday) Then
		Call Dream3CLS.MsgBox2("����Ԥ���������ڿ�Ԥ�����������("&maxday&")�죡",0,"0")
		Response.End()
	End If
	
	'�Ƿ񳬹�30��
	If (checkindays > 30) Then
		Call Dream3CLS.MsgBox2("Ŀǰ��ֻ��Ԥ��һ�����ڵķ��䣡",0,"0")
		Response.End()
	End If
	
	
	
	
	
	
'''''''''''''''''''''''''''''''''''''''''''''''''�������ݱ�D�Ը�ע�͵�'''''''''''''''''''''''''''''''''''''''''''''
'	'�ⷿ�����Ƿ��Ѿ���Ԥ�� 
'	For i = 0 To checkindays - 1
'		fDays = Dream3CLS.Formatdate(DateAdd("d", i, startdate) , 2)
'		If instr(order_days , ","&fDays&",") > 0  Then
'			Call Dream3CLS.MsgBox2("����Ԥ���ķ�����"&fDays&"�ѱ�Ԥ����",0,"0")
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
'			gMsgArr = "��ҪԤ���Ĳ�Ʒ�Ѿ���������ȷ�ϣ��뵽'�ҵĶ���'���и��"
'			gMsgFlag = "E"
'			Call Main()
'			Exit Sub
'		End If
'	End If
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



''''''''''''''''''''''''''''''''''''''''''''�������ݱ�D�Ը���д''''''''''''''''''''''''''''''''''''''''''''''''''''''

'	'�ⷿ�����Ƿ��Ѿ���Ԥ�� 
'	For i = 0 To checkindays - 1
'		fDays = Dream3CLS.Formatdate(DateAdd("d", i, startdate) , 2)
'		If instr(order_days , ","&fDays&",") > 0  Then
'			Call Dream3CLS.MsgBox2("����Ԥ���ķ�����"&fDays&"�ѱ�Ԥ����",0,"0")
'			Response.End()
'		End If
'	Next
	
	Sql = "Select Top 1 * from T_Order Where user_id="&session("_UserID") &" And product_id="&pid
	Rs.open Sql,conn,1,2
'	If Rs.EOF Then
		Rs.AddNew
		order_no_sms= Dream3Product.GetOrderNumber() '���涩���� mike
		Rs("order_no") = order_no_sms '���涩���� mike
 	    Rs("owner_id") = tRs("user_id")
		owner_id_sms = tRs("user_id") '�����̼�id mike
		houseTitle = tRs("houseTitle") '���������� mike

'	'Else
'		If  Rs("state") = "unpay" Then
'			gMsgArr = "��ҪԤ���Ĳ�Ʒ�Ѿ���������ȷ�ϣ��뵽'�ҵĶ���'���и��"
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
		user_id_sms = Session("_UserID") ' ��¼���û�ID Mike
	Rs("admin_id") 	= 0
	Rs("product_id") 	= pid
	Rs("state") 	= "unconfirm" '��ȷ��
	Rs("realname") 	= realname
	Rs("mobile") 	= mobile
		user_mobile = mobile '�û��ֻ��� mike
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
	
	'add by xiaoyaohang �µ����������ʼ�
	 serviceEmailXht = "123619503@qq.com"
	 serviceEmailLzp = "dk@yoinns.com"
	 serviceEmailXyh = "15920544859@139.com"
		
		topic = "�ж�������������"
		mailbody = "�ж���,��"+startdate+" �� "+enddate+",������"+order_no_sms
		
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
		hh_hotelname=rs("h_hotelname") '�̼��õ�����
	Rs.Close
	
	Sql = "Select mobile from T_User Where id="&owner_id_sms
	Rs.open Sql,conn,1,2
		owner_mobile=rs("mobile") '�̼��ֻ���
	Rs.Close
	
	Sql = "Select id from T_Order Where order_no="&order_no_sms
	Rs.open Sql,conn,1,2
		order_id=rs("id") '����id
	Rs.Close
	
	Set Rs = Nothing

	'owner_id_sms '�̼�ID
	'user_id_sms '�û�ID
	
	'owner_mobile '�̼��ֻ���
	'user_mobile '�û��ֻ���

	r_no1=Rnd_no(6) '��Ҫ4λ�����
	r_no2=Rnd_no(6) '��Ҫ4λ�����
	sms_owner="�𾴵ġ����ùݡ��̼�,�û�"&realname&"Ԥ������'"&hh_hotelname&"'�õ��µ�'"&houseTitle&"'����("&startdate&"~"&enddate&",��"&datediff("d",startdate,enddate)&" ��,��"&totalPrice&"Ԫ),ȷ�϶�����ظ�"&r_no1&" ,ȡ��������ظ�"&r_no2&" .лл!�����ùݡ�" '��������
	
	sms_user="�𾴵ġ����ùݡ��û�,���ǻᾡ�촦��������,��л����Ԥ���������ùݡ�" '��������
	
	'sms_save(�绰,��֤��1,��֤��2,��֤��3,����id,��������,�Ƿ���Ҫ���û��ض���,��ǰλ��) '����
	if sms_open=0 then
		at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '���̼ҷ�����
		at2=mt(user_mobile,sms_user,ext,stime,rrid) '���û�������
		
	end if
		call sms_save(owner_mobile,r_no1,r_no2,"",order_id,"T_Order",at1,1,0) '�̼ұ���
		call sms_save(user_mobile,"","","",order_id,"T_Order",at2,0,0) '�û�����
	
	

	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''mike

	response.Write "OK?"
	'response.End()
	
	Dream3CLS.showMsg "���Ķ����Ѵ����������ύ��������ȷ�ϣ������ĵȴ���лл��","S", VirtualPath &"/user/lodger/order.asp"
	
	
	
	
End Sub

Sub Main()		
	
	'�õ����е�ID������Ҳ�������Ĭ��Ϊȫ��
		pid = Dream3CLS.ChkNumeric(Request("pid"))
		detail_id= Dream3CLS.ChkNumeric(Request("detail_id"))
		checkinRoomNum = Dream3CLS.ChkNumeric(Request("checkinRoomNum"))
		checkintype = Dream3CLS.RParam("checkintype")
		startdate = Dream3ClS.RParam("startdate")
		enddate = Dream3ClS.RParam("enddate")

		'������Ҫ����1
		If checkinRoomNum < 1 Then
			Call Dream3CLS.MsgBox2("Ҫѡ�񷿼�����",0,"0")
			Response.End()
		End If
		
		'�����жϽ�������Ҫ���ڵ��ڿ�ʼ����
		If not  isdate(startdate) Then
			Call Dream3CLS.MsgBox2("��ʼ���ڸ�ʽ����ȷ��",0,"0")
			Response.End()
		End If
		If not  isdate(enddate) Then
			Call Dream3CLS.MsgBox2("�������ڸ�ʽ����ȷ��",0,"0")
			Response.End()
		End If
		
		'�����ʼ����С�ڽ���
		If DateDiff("d",startDate,Now()) > 0 Then
			Call Dream3CLS.MsgBox2("��ʼ���ڲ���С�ڽ��죡",0,"0")
			Response.End()
		End If
		
		'�����ⷿʱ��
		checkindays = datediff("d",startdate,enddate)
		
		If checkindays < 1 Then
			Call Dream3CLS.MsgBox2("�������ڲ���С����ʼ���ڣ�",0,"0")
			Response.End()
		End If
		
		
		
		
		Sql = "Select * from T_Product Where id="&detail_id&" and hid="&pid
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Rs.EOF Then
			Dream3CLS.showMsg "��Ҫ��ѯ�Ķ�����Ϣ�����ڣ�","S","error.asp"
			Response.End()
		End If
		
		minday = Rs("minday")
		maxday  = Rs("maxday")
		order_days = Rs("order_days")
		'if maxday = 0 then maxday = "������"
		If IsNull(order_days) Then order_days = ""
		order_days = ","&order_days&","
		
		'�����ⷿʱ��
		checkindays = datediff("d",startdate,enddate)
		
		If checkindays < minday Then
			Call Dream3CLS.MsgBox2("����Ԥ������С�ڿ�Ԥ������С����("&minday&")�죡",0,"0")
			Response.End()
		End If
		
		If (maxday > 0 and checkindays > maxday) Then
			Call Dream3CLS.MsgBox2("����Ԥ���������ڿ�Ԥ�����������("&maxday&")�죡",0,"0")
			Response.End()
		End If
		
		'�Ƿ񳬹�30��
		If (checkindays > 30) Then
			Call Dream3CLS.MsgBox2("Ŀǰ��ֻ��Ԥ��һ�����ڵķ��䣡",0,"0")
			Response.End()
		End If
		
		
		
		
''''''''''''''''''''''''''''''''''''''''''''''''�������ݱ�D�Ը�ע�͵�'''''''''''''''''''''''''''''''''''''''''''''		
'		'�ⷿ�����Ƿ��Ѿ���Ԥ�� 
'	'	For i = 0 To checkindays - 1
'			fDays = Dream3CLS.Formatdate(DateAdd("d", i, startdate) , 2)
'			If instr(order_days , ","&fDays&",") > 0  Then
'				Call Dream3CLS.MsgBox2("����Ԥ���ķ�����"&fDays&"�ѱ�Ԥ����",0,"0")
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
		If roomsnum = 11 then roomsnum = "����10"
		bednum = Rs("bednum")
		If bednum = 11 then bednum = "����10"
		bedtype = Rs("bedtype")
		bedtype = Dream3Static.GetBedType(bedtype)
		
		
		toiletnum = Rs("toiletnum")
		If toiletnum = 11 then toiletnum = "����10"
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
		
		'�жϷ���֧����ʽ
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
		
		'����۸�
		'totalPrice = checkindays * singlePrice * checkinRoomNum
		
		
		
		
		userid = Rs("user_id")

		userIdArr(0) = userid
		
		
		Call Dream3Product.getUserMap(userIdArr,userMap)
		
		' ��ȡ�û�����
		Set tRs = Dream3Product.getUserById(session("_UserID"))
		mobile = tRs("mobile")
		username = Session("_UserName")
		realname = tRs("realname")
		   if (realname="") then
                      realname="ȷ��������ȷ"
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
		'ƴ���ڵĲ�ѯ���� ע�� �����ʱ����������Ҫ�е����� ���ڱ���Ϊ date > '2012-10-17' �����Ĵ����Ÿ�ʽ	
	    Sql  = "select * from T_SpecialPrice where product_id = "&pid&"and  date>= '"&Cdate(startdate)&"' and date< '"&Cdate(enddate)&"'" 
	Case Else
		'ƴ���ڵĲ�ѯ���� ע�� �����ʱ����������Ҫ�е����� ���ڱ���Ϊ date > '2012-10-17' �����Ĵ����Ÿ�ʽ	
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
G_Title_Content = "Ԥ������"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="content_wrapper">
	
    <div class="yuding_box">
        
        <div class="part1_bg">
            <ul>
                <li class="num_01"><h2>�ͷ�Ԥ��</h2></li>
                <li class="num_02"><h3>֧������</h3></li>
                <li class="num_03"><h3>���</h3></li>
            </ul>
        </div>
        
        <div class="line_one"></div>
        
        <div class="part1_cc">
            ���������Ķ�����Ϣ����ȷ�Ϻ��ύ��ע�⣺<br>
            1. ���ύǰ��ȷ��������ס��Ϣ���ύ�󷿶������յ�����Ԥ������<br>
            2. ����ϸ�Ķ���<a href="help/index.asp?c=pay"target="_blank">���׹���</a>������֤������˽�<%=Dream3CLS.SiteConfig("SiteShortName")%>�������̼����ݡ�<br />
            3. ���������24Сʱ�ڽ��ܻ�ܾ����Ķ����������ǽ����ö��ź��ʼ��ķ�ʽ��֪ͨ����<br>
            4. �������ȡ��Ԥ�������¼����"�û�����"ҳ����ȡ��������<br>
            5. ��������������ʣ��벦�����ǿͷ��绰��<%=Dream3CLS.SiteConfig("ServicePhone")%>��<%=Dream3CLS.SiteConfig("ServiceTime")%>��
        </div>
        
        <div class="part2_cc">
        	<div class="part2_cct"></div>
            <div class="part2_ccm">
                <span class="pic_tu"><img src="<%=img1%>" width="325" height="245"></span>
                <ul class="part2_c">
                <span class="title_c"><h3><%=Dream3Product.GetHotelname(pid)%></h3><h4><%=housetitle%></h4></span>
                <h5 class="title_c2"></h5>
                    <ol class="cont_cc">
                    <li><h3>��סʱ�䣺</h3><h4><%=startdate%>  <%=checkintime%></h4></li>
                    <li><h3>�˷�ʱ�䣺</h3><h4><%=enddate%>  <%=checkouttime%></h4></li>
                    <li><h3>��ס������</h3><h4><%=checkindays%></h4></li>
                    <li><h3>����������</h3><h4><%=checkinRoomNum%></h4></li>
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
                        <th>���</th>
                        <!--<th>����</th>-->
                        <th>����</th>
                        <th>����</th>
                        <th>�ܼ�</th>
                        <th>����Ӧ������<%=Dream3CLS.SiteConfig("ReserveRate")%>%��</th>
                        <th>����֧������</th>                        
                    </tr>
                    <tr class="tr">
                        <td>
						<%If checkintype = "perWeek" Then%>
						���ܼ���
						<%Elseif checkintype = "perMonth" Then%>
						���¼���
						<%Else%>
						�������
						<%End If%>
						</td>
                        <!--<td>
						<%If checkintype = "perWeek" Then%>
						ÿ�ܣ�<%=weekrentprice%><br>
						���ܼ����ۺϵ���
						<%Elseif checkintype = "perMonth" Then%>
						ÿ�£�<%=monthrentprice%><br>
						���¼����ۺϵ���
						<%Else%>
						ÿ�죤<%=dayrentprice%><br>
						������㵥��
						<%End If%>
						��<%=singlePrice%>
						</td>-->
                        <td><%=checkinRoomNum%></td>
                        <td><%=checkindays%></td>
                        <td  class="jq">��<%=totalPrice%></td>
                        <td  class="jq">��<%=onlinepayamount%></td>
                        <td  class="jq">��<%=offlinepayamount%></td>                        
                    </tr>
                </tbody>
                </table>
                <div class="sm">*�����������涨����֧���������<%=Dream3CLS.SiteConfig("ReserveRate")%>%��֮�󷿶�Ϊ��Ԥ��������֤����������ס��  </div>
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
                    <h3>����д������ϵ��Ϣ</h3>
                    <ol>
                        <li><h4>��&#12288;����</h4>
                        <h5><input type="text" id="realname" class="input_bg" name="realname" value="<%=realname%>"onblur="if(this.value==''){this.value='ȷ��������ȷ';this.style.color='#ff0000'}" onfocus="if(this.value=='ȷ��������ȷ'){this.value='';this.style.color='#333'}" value="ȷ��������ȷ" autocomplete="off" style="color: rgb(153, 153, 153); ">
                        <span id="tip_username" style="font-size:18px; color:#ee0000">&nbsp;*</span></h5>
                        </li>
                        <li><h4>��&#12288;����</h4><h5>
                        <input type="text" maxlength="11" id="mobile" class="input_bg" name="mobile" value="<%=mobile%>">
                        <span id="tip_phone" style="font-size:18px; color:#ee0000">&nbsp;*</span></h5></li>
                        
                        <!--
                        <li><h4>��&#12288;�䣺</h4><h5><input type="text" id="email" class="input_bg" name="email" value="<%=email%>">
                        <span id="tip_email"></span></h5></li>
                        -->
                    </ol>
                </ul>
                
            </div>
            <div class="part2_ccb"></div>            
        </div>
        
        <div class="part1_cc" style="display:none ">
            <strong>���׹���</strong><br>
            1.����ȷ�Ϻ󣬷���������Ԥ��658Ԫ���ܷ����100%����Ϊ���� ��<br>
            2.������2012-03-21�յ�14:00֮ǰȡ����Ԥ������ȫ���˻����͡�<br>
            3.������2012-03-21�յ�14:00֮��2012-03-22�յ�14:00֮ǰȡ���������۳�658Ԫ��<br>
            4.������ס����ǰ�˷���<%=Dream3CLS.SiteConfig("SiteShortName")%>�뷿�����ֱ��ʣ�������Ķ�������¸����п۳�100% ��<br>
            5.������ȡ��ʱ����<%=Dream3CLS.SiteConfig("SiteShortName")%>ϵͳ�м�¼�Ķ���ȡ��ʱ��Ϊ׼��<br>
            6.����ķ�����ú�Ѻ�𲻰������ܷ����ڣ��ɷ���������ȡ��<br>
            7.����κ�һ��Ͷ�ߣ���������ס24Сʱ��֪ͨ<%=Dream3CLS.SiteConfig("SiteShortName")%>��<br>
            8.���б�Ҫ��<%=Dream3CLS.SiteConfig("SiteShortName")%>������е��⣬�������������˵����վ���Ȩ��<br>
        </div>
        
        <div class="line_one"></div>
        
        <!--�ύǰ���������js����ү�׷�------------------>
        <script type="text/javascript">
        	
            function check_and_submit(){
            	if (document.getElementById("realname").value=="ȷ��������ȷ")
            	{
            		//alert("��д����������(��v��)");
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
        	<p style="cursor:pointer;" id="book" class="yuding_bg" onclick="check_and_submit();">����Ԥ��</p>
        </div>
		</form>
        
    </div>
    
</div>
<%
if request("key")="go" then

  startdate=request("startdate")
  enddate=request("enddate")

if IsDate(date1)=false or IsDate(date2)=false then
  response.write "ʱ������������!"
  response.end
end if
  response.write getallprice(startdate,enddate)

end if

'date1=#2012-7-16#
'date2=#2012-8-8#
function getallprice(date1,date2)
s=0
d_temp=abs(DateDiff("d",date1,date2)) '����������������
'response.write "��"&date1&"~"&date2&"��������������<br><br>"
if d_temp<62 then '�������С��62��ʱ
  n_data=date1
  for i=1 to d_temp
    w_temp=Weekday(n_data,2) '��ȡdate1 ������ֵ
    if ( w_temp=5 or w_temp=6 ) and ( n_data<date2 )then '�����������ʱ

      'response.write n_data '��ʾ������
      'response.write "<br>"
      s=s+weekrentprice'ֻҪ�������ۼ������յļ۸�Ϳ�����
      else
      s=s+dayrentprice
    end if
    n_data=DateAdd("d", 1, n_data) '��һ��
  next
else
  response.write "�������ڳ���2������!"
end if
getallprice=s
end function
%>
<!--#include file="common/inc/footer_user.asp"-->