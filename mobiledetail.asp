<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->
<!--#include file="SqlFilter.asp"-->

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
Dim userule 'ʹ�ù���
Dim expiredate  '��Ч��
Dim order_days '��Ԥ�������ڴ�
Dim h_discriptio '�Ƶ�����
Dim h_line '��ͨ·��
Dim dayrentprice,weekrentprice,monthrentprice

Dim  map_x,map_y

Dim img1,img2,img3,img4,img5,img6,img7,img8,img9,img10,h_img,imageArray(10)
Dim userid,detail_id
Dim userIdArr(0) ,userMap
Dim userface

Dim leftDays 'չʾʣ�������ķ�Դ
Dim vallege,vallegeCode '�õ������Ĵ���

Dim fromdate,todate,fromdate_str,todate_str

Set userMap = new AspMap
dim fangdong
dim ismanager
Action = Request.QueryString("act")
Select Case Action
	Case "saveMsg"
		Call SaveMsg()
	Case Else
		Call Main()
End Select

Sub Main()		
	
		'��ʼ������
		fromdate_str=Dream3CLS.RParam("fromDate")
		todate_str =Dream3CLS.RParam("toDate")
		if fromdate_str = "" Then
			fromDate=date()
		else
			fromDate=CDate(fromdate_str)
		end if
		
		if (todate_str = ""  or fromdate_str>=todate_str) Then
			toDate=fromDate+1
		else
			toDate=CDate(todate_str)
		end if
		
	'�õ����е�ID������Ҳ�������Ĭ��Ϊȫ��
		detail_id = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
		
		Sql = "Select * from T_Product Where id="&detail_id&" and state='normal'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Dream3CLS.showMsg "��Ҫ��ѯ����Ϣ�����ڣ�","S","error.asp"
			Response.End()
		End If
		
		Set cityMap = new AspMap
		Call Dream3Product.getCategoryMap("city",cityMap)
		
		userule = Rs("userule")
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
		
		
		'orange��������
		hid=Rs("hid")
		sql2="select * from T_hotel where h_id="&hid
		Set Rs2 = Dream3CLS.Exec(Sql2)
		If Rs2.EOF Then
			Dream3CLS.showMsg "��Ҫ��ѯ����Ϣ�����ڣ�","S","error.asp"
			Response.End()
		End If
		
		address=Rs2("h_address")
		h_line= Rs2("h_line")
		h_discription= Rs2("h_discription")
		h_img= Rs2("h_img")
		vallegeCode= Rs2("h_citycode")
		
		
		
		'made by chengguan
		h_uid=Rs2("h_uid")
		Set Rs3 = Dream3CLS.Exec("select username from T_User where id='"&h_uid&"'")
		If Rs3.EOF Then
			Dream3CLS.showMsg "��Ҫ��ѯ����Ϣ�����ڣ�","S","error.asp"
			Response.End()
		End If
		fangdong=Rs3(0)
		if Session("_UserID")<>"" then
		Set Rs4 = Dream3CLS.Exec("select state from T_User where id='"&Session("_UserID")&"'")
		If Rs4.EOF Then
			Dream3CLS.showMsg "��Ҫ��ѯ����Ϣ�����ڣ�","S","error.asp"
			Response.End()
		End If
		ismanager=Rs4(0)
		end if
		
		
		
		
		toiletnum = Rs("toiletnum")
		If toiletnum = 11 then toiletnum = "����10"
		checkouttime= Rs("checkouttime")
		checkintime  = Rs("checkintime")
		minday = Rs("minday")
		maxday  = Rs("maxday")
		if maxday = 0 then maxday = "������"
		invoice = Rs("invoice")
		'address = Rs("address")
		housetitle = Rs("housetitle")
		facilities = Rs("facilities")
		facilities = ","&facilities&","
		
		imageArray(0) = Rs("image")  
		imageArray(1) = Rs("image1")  
		imageArray(2) = Rs("image2")  
		imageArray(3) = Rs("image3")  
		imageArray(4) = Rs("image4")  
		imageArray(5) = Rs("image5")  
		imageArray(6) = Rs("image6")  
		imageArray(7) = Rs("image7")  
		imageArray(8) = Rs("image8")  
		imageArray(9) = Rs("image9") 
		
		map_x = Rs("map_x") 
		map_y = Rs("map_y") 
		
		dayrentprice = Rs("dayrentprice") 
		weekrentprice = Rs("weekrentprice") 
		monthrentprice = Rs("monthrentprice") 
		expiredate = Rs("expiredate")
		order_days = Rs("order_days")
		
		order_days = "," & order_days & ","
		
		userid = Rs("user_id")

		userIdArr(0) = userid
		
		
		Call Dream3Product.getUserMap(userIdArr,userMap)
		
		userface = userMap.getv(CStr(userid))(3)
		If ( IsNull(userface) or userface = "") Then
			userface = VirtualPath & "/images/user_normal.jpg"
		End If
		
		'��ȡʣ��1�����ڵķ�Դ
		leftDays = DateDiff("d",Now(),expiredate)
		
		If leftDays > 30 Then leftDays = 30
		
		'�ز��õ���������
		 Sql = "Select * from T_City Where citypostcode="&vallegeCode
		
		Set Rs = Dream3CLS.Exec(Sql)
		If not Rs.EOF Then
			vallege=Rs("cityname")
		end if
	
		
End Sub
	
	
%>


		
<%

''''''''''�۸������������
Dim yearDetect,monthDetect
		if month(now)=12 then		
		yearDetect = cstr(year(now)+1)
		monthDetect = cstr(1)
		Else
		yearDetect = cstr(year(now))
		monthDetect = cstr(month(now)+1)
		End if
		'response.write( " <script   language=vbscript> msgbox("&monthDetect&")</script> ") 

		Sql = "Select * from T_SpecialPrice Where product_id="+cstr(detail_id)
		Sql = Sql&" and  date< '"&Dateadd("d",62,date())&"' and date> = '"&date()&"'"
		
		
		Set priceRs = Dream3CLS.Exec(Sql)
		
		
		Sub dislplayCalender(monthIndex)	
			Dim dateCount ,priceString,firstDatePosition,dateString
			Dim monthDay, dt1, dt2,dt3
			
			monthIndex=cint(monthIndex)
			if monthIndex = 0 then
			''���µ����ݴ���
				dateString = year(now)&"-"&month(now)&"-1"	
				priceFirstDatePosition = day(now)
				'��ñ�������
				dt1 = Date
				dt1 = CDate(Year(dt1) & "-" & Month(dt1) & "-1") ' �õ����µ�һ��
				dt2 = DateAdd("m", 1, dt1) ' �õ��¸��µ�һ��
				monthDay = DateDiff("d", dt1, dt2) ' �õ������µĲ�
				
			else if monthIndex = 1 then
			''���µ����ݴ���
				dateString = yearDetect&"-"&monthDetect&"-1"
				priceFirstDatePosition = 0
				'�����������
				dt1 = Date
				dt1 = CDate(Year(dt1) & "-" & Month(dt1) & "-1") ' �õ����µ�һ��
				dt2 = DateAdd("m", 1, dt1) ' �õ��¸��µ�һ��
				dt3 = DateAdd("m", 2, dt1) ' �õ����¸��µ�һ��
				monthDay = DateDiff("d", dt2, dt3) ' �õ������µĲ�
				
				end if
			end if
		
			monthFirstDatePosition = Weekday(CDate(dateString))-1
			
			dateCount = 0			
			For K = 0 To monthFirstDatePosition - 1
				response.write"<td ><span class=dom></span></td>"
			Next
				
						
			
			Do While dateCount < monthDay
				
				If CLng(monthFirstDatePosition+dateCount) mod 7 =0 Then
					response.write("</tr ><tr style='background-color:#B8B8B8'>")
				End If
				
		
				If dateCount < priceFirstDatePosition - 1 Then
					response.write"<td class=in_the_past><span style='color:#484848'>"	
				Else
					'��ĩ��ʾ��ͬ��ɫ
					if  CLng(monthFirstDatePosition+dateCount) mod 7 =5 or  CLng(monthFirstDatePosition+dateCount) mod 7 = 6 then
					response.write"<td class=available_weekend><span style='color:#484848'>"
					else
					response.write"<td class=available><span style='color:#484848'>"
					end if
				End If		
				
				response.write(dateCount+1)
				
				If dateCount < priceFirstDatePosition - 1 Then
					response.write"</span></td>"
				Else
					If Not priceRs.EOF then
					
					priceString = Cstr( priceRs("price"))	
					priceRs.Movenext
					end if
				
					response.write"</span>  ��"+priceString+"</td>"
				End If
				
				dateCount = dateCount + 1
			Loop
			
		End Sub
		
		
		
%>

<%
'�������۵�
pagestrLocalUrl = request.ServerVariables("SCRIPT_NAME")&"?pid="&detail_id
pagesql="select id,username,userface,hotelname,houseTitle,contents,state,createtime,owner,callback,callbacktime from T_Comments where  roomid='"&detail_id&"'"


pagesql=pagesql&" order by createtime desc"
 
 
	   Set clsRecordInfo = New Cls_PageView
			clsRecordInfo.intRecordCount = 2816
			
			clsRecordInfo.strSql = pagesql
			clsRecordInfo.intPageSize = 3
			clsRecordInfo.intPageNow = pageintPageNow
			clsRecordInfo.strPageUrl = pagestrLocalUrl
			clsRecordInfo.strPageVar = "page"
		 clsRecordInfo.objConn = Conn		
		 pagearrU = clsRecordInfo.arrRecordInfo
		 pagestrPageInfo = clsRecordInfo.strPageInfo
		 pagestrTotalRecord  = clsRecordInfo.strTotalRecord
		Set clsRecordInfo = nothing
%>
		
		
		
<meta name="viewport" content="width=device-width, minimum-scale=1, maximum-scale=1">
<link rel="stylesheet" href="http://code.jquery.com/mobile/1.0a4.1/jquery.mobile-1.0a4.1.min.css">
<script src="http://code.jquery.com/jquery-1.5.min.js"></script>
<script src="http://code.jquery.com/mobile/1.0a4.1/jquery.mobile-1.0a4.1.min.js"></script>
    
<div data-role="page" >
   <div data-role="header">
      <h1><%=housetitle%></h1>
   </div><!-- /header -->
   <div data-role="content">  
	   <strong><p><%=housetitle %></p></strong>
	  
	   <p><%=RoomDesc%></p>
	   
		 <!--����ͼƬ��ʾ -->	
	 <section data-role="collapsible">
			<h3>ͼƬչʾ</h3>
		  <%
			For i = 0 To 9
				if imageArray(i) <> "" then
		  %>
							
				<img src="<%=imageArray(i)%>" alt="<%=housetitle %>" width="98%"> 
							<%
							end if
							Next
							%>
			
		</section>
		
	 	 <section data-role="collapsible">
			<h3>�۸�����</h3>
			
			<div data-role="controlgroup" data-type="horizontal" >
			
			<!--	<input type="radio" name="MonthBtn" id="preMonthBtn" value="any" checked="checked" />  
				<label for="preMonthBtn"><%=month(now)%>��</label>  
						 
				<input type="radio" name="MonthBtn" id="postMonthBtn" value="anycall" />  
				<label for="postMonthBtn"><%=monthDetect%>��</label> 
			-->
			 <div style="text-align:center">
				<img src="./calender/leftArr.png" id="preMonthBtn" width="30px" height="30px">
				<a id="preMonthSelect"><%=year(now)%>��<%=month(now)%>��</a>
				<a id="postMonthSelect" style="display:none"><%=yearDetect%>��<%=monthDetect%>��</a>
				<img src="./calender/rightArr.png" id="postMonthBtn" width="30px" height="30px">
			</div>
				
		   </div>  
			
			<div class="ri_com_ripic" name = "preMonth" id = "preMonth">
			<table width="98%" >
			  <tr style="border:3px solid #98bf21;background-color:#707070">
				<th>��һ</th>
				<th>�ܶ�</th>
				<th>����</th>
				<th>����</th>
				<th>����</th>
				<th>����</th>
				<th>����</th>	
			  </tr>
			 <tr style="background-color:#B8B8B8">
				<%
				dislplayCalender(0)	
				%>
			 </tr>			 
	 
			 </table>
			 </div>

			<div class="ri_com_ripic" name = "postMonth" id = "postMonth" style="display:none">
			<table width="98%" >
			  <tr style="border:3px solid #98bf21;background-color:#707070">
				<th>��һ</th>
				<th>�ܶ�</th>
				<th>����</th>
				<th>����</th>
				<th>����</th>
				<th>����</th>
				<th>����</th>	
			  </tr>
			 <tr style="background-color:#B8B8B8">
				<%
				dislplayCalender(1)	
				%>
			 </tr>			 
	 
			 </table>
			 </div>
					
		 </section>
	 
		<section data-role="collapsible">
		<h3>������ʩ</h3>
		
		   <div class="yym-detail">
                           <%
							Set f_Rs = Server.CreateObject("adodb.recordset")	
							Sql = "select id,cname from T_Facility Where enabled='Y' order by seqno desc"		
							f_Rs.open Sql,conn,1,1
							
							Do While Not f_rs.EOF
								If instr(facilities,","&f_Rs("id")&",") Then
									facilitySelect = true
								Else
									facilitySelect = false
								End If
							%>
							<%If  facilitySelect Then%>
							<span class="no"><%=f_rs("cname")%></span>+
							<%End If%>
							<%
								f_rs.Movenext
							Loop
							%>
			</div>                 
		</section>
	 
	
		
		 <section data-role="collapsible">
			<h3>�鿴����</h3>
			 </br>

	<ul data-role="listview">
		 <%
	if isArray(pagearrU) then
  
 
	for i=0 to ubound(pagearrU,2)
	    
	 
	  commentid=pagearrU(0,i)
	  pageusername=pagearrU(1,i)
	  userface=pagearrU(2,i)
	  hotelname=pagearrU(3,i)
	  housetitle=pagearrU(4,i)
	  contenttext=pagearrU(5,i)
	  pagestate=pagearrU(6,i)
	  textcreatime=pagearrU(7,i)	 
	  ownername =pagearrU(8,i)	 	 
	  callback=pagearrU(9,i)	
	  callbacktime=pagearrU(10,i)	
  %>
		<!--
		<div >
			<div class="father1" style="background-color:green;display:inline-block;width:30%;height:100"></div>
			<div class="father2" style="background-color:blue;display:inline-block;width:60%">
				<div class="son1" style="background-color:red;height:50px"></div>
				<div class="son2" style="background-color:yellow;height:50px"></div>
			</div>
		</div>
		--><li>
		<div >
			<div  style="display:inline-block;width:30%">
             <img width="60" height="60" title=<%=pageusername%> src=<%=userface%>>
			 </br>
			 <a><%=pageusername%></a>
			</div>
				
            <div style="display:inline-block;width:60%">
				<%=contenttext%>
				</br>
				����ʱ��:
				</br>
				<%=textcreatime%>               
            </div>
		</div>
		</br></li>
      <% next%>
</ul>


		<%else%>
		<div > �������ۻ�������δ���</div>
		
		<%end if%>
			 
		 </section>
	   
   </div><!-- /content -->

   <script>
 function preMonth(){
	//alert('preMonth: ');
	document.getElementById("postMonth").style.display = "none";
	document.getElementById("preMonth").style.display = "";
	document.getElementById("postMonthSelect").style.display = "none";
	document.getElementById("preMonthSelect").style.display = "";
}
function postMonth(){
	//alert('postMonth: ');
	document.getElementById("preMonth").style.display = "none";
	document.getElementById("postMonth").style.display = "";
		document.getElementById("postMonthSelect").style.display = "";
	document.getElementById("preMonthSelect").style.display = "none";
}


jQuery(document).ready(function() { 
		
		$("#preMonthBtn").bind("tap",function (e) { 
		//alert('preMonthBtn: ');
		preMonth();
		});
		
		$("#postMonthBtn").bind("tap",function (e) { 
		//alert('postMonthBtn: ');
		postMonth();
		});
		
    });
</script>
   
</div><!-- /page -->




