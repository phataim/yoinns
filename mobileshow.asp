<meta name="viewport" content="width=device-width, minimum-scale=1, maximum-scale=1">
<link rel="stylesheet" href="http://code.jquery.com/mobile/1.0a4.1/jquery.mobile-1.0a4.1.min.css">
<script src="http://code.jquery.com/jquery-1.5.min.js"></script>
<script src="http://code.jquery.com/mobile/1.0a4.1/jquery.mobile-1.0a4.1.min.js"></script>
<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount

Dim hid,h_hotelname,h_headname,h_citycode,h_address,h_img,h_discription,h_star,h_line,t_name,h_mapx,h_mapy,imgsum,show_id,typeid

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
Dim userule '使用规则
Dim expiredate  '有效期
Dim order_days '被预定的日期串

Dim dayrentprice,weekrentprice,monthrentprice

Dim  map_x,map_y

Dim img1,img2,img3,img4,img5,img6,img7,img8,img9,img10
Dim userid,detail_id
Dim userIdArr(0) ,userMap
Dim userface,mobile

Dim leftDays '展示剩余天数的房源
Dim vallege,vallegeCode '旅店所属的村落

Dim fromdate,todate,fromdate_str,todate_str

Set userMap = new AspMap

Action = Request.QueryString("act")
Select Case Action
	Case "saveMsg"
		Call SaveMsg()
	Case Else
		Call Main()
End Select

Sub Main()		
	
		'初始化日期
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
	
	'得到城市的ID，如果找不到，则默认为全部
		show_id = Dream3CLS.ChkNumeric(Request.QueryString("hid"))
		
		Sql = "Select * from T_hotel Where h_id="&show_id
		
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Dream3CLS.showMsg "您要查询的信息不存在！","S","error.asp"
			Response.End()
		End If
		
		Set cityMap = new AspMap
		Call Dream3Product.getCategoryMap("city",cityMap)
		
		hid= Rs("h_id")
		h_hotelname = Rs("h_hotelname")
		h_address = Rs("h_address")
		h_star= Rs("h_star")
		h_img= Rs("h_img")
		facilities = Rs("h_facility")
		facilities = ","&facilities&","
		h_discription= Rs("h_discription")
		h_line= Rs("h_line")
		vallegeCode= Rs("h_citycode")
		
		'userule = Rs("userule")
		'RoomDesc = Rs("RoomDesc")
		'lodgeType = Rs("lodgeType")
		'leaseType = Rs("leaseType")
		
		'guestnum = Rs("guestnum")
		
		'If roomsnum = 11 then roomsnum = "大于10"
		'bednum = Rs("bednum")
		'If bednum = 11 then bednum = "大于10"
		
		
		
		'toiletnum = Rs("toiletnum")
		'If toiletnum = 11 then toiletnum = "大于10"
		'checkouttime= Rs("checkouttime")
		'checkintime  = Rs("checkintime")
		'minday = Rs("minday")
		'maxday  = Rs("maxday")
		'if maxday = 0 then maxday = "无限制"
		'invoice = Rs("invoice")
		'address = Rs("address")
		
		
		
		'img1 = Rs("image")  
		'img2 = Rs("image1")  
		'img3 = Rs("image2")  
		'img4 = Rs("image3")  
		'img5 = Rs("image4")  
		'img6 = Rs("image5")  
		'img7 = Rs("image6")  
		'img8 = Rs("image7")  
		'img9 = Rs("image8")  
		'img10 = Rs("image9") 
		
		h_mapx = Rs("h_mapx") 
		h_mapy = Rs("h_mapy") 
		
		'===============================mike
		map_x=h_mapx 
		map_y=h_mapy 
		If IsNull(map_x) Or map_x = "" Then '如果为空就用默认位置
			map_x = "113.400961" '百度坐标 x 
			map_y = "23.057637" '百度坐标 y 
			is_empty_map=1 '没有坐标
		End If 
		'===============================mike

		'weekrentprice = Rs("weekrentprice") 
		'monthrentprice = Rs("monthrentprice") 
		'expiredate = Rs("expiredate")
		'order_days = Rs("order_days")
		
		'order_days = "," & order_days & ","
		
		userid = Rs("h_uid")
		
		Sql = "Select * from T_User Where id="&userid
		
		Set Rs = Dream3CLS.Exec(Sql)
		If not Rs.EOF Then
			mobile=Rs("mobile")
		end if
		
		
		userIdArr(0) = userid
		
		
		Call Dream3Product.getUserMap(userIdArr,userMap)
		
		userface = userMap.getv(CStr(userid))(3)
		If ( IsNull(userface) or userface = "") Then
			userface = VirtualPath & "/images/user_normal.jpg"
		End If
		'获取剩余1个月内的房源
		'leftDays = DateDiff("d",Now(),expiredate)
		
		'If leftDays > 30 Then leftDays = 30
		
		'重查旅店所属村落
		 Sql = "Select * from T_City Where citypostcode="&vallegeCode
		
		Set Rs = Dream3CLS.Exec(Sql)
		If not Rs.EOF Then
			vallege=Rs("cityname")
		end if
		
End Sub
	
	
%>

<script language="javascript" src="<%=VirtualPath%>/common/js/inad_duice.js"></script>
<script language="javascript" src="<%=VirtualPath%>/common/js/time.js"></script>


<!-- Start of first page -->
<div data-role="page" id="menu">
   <div data-role="header">
      <h1><%=h_hotelname%></h1>
   </div><!-- /header -->
	 <div data-role="content">
		<%=h_discription%>
		<section data-role="collapsible">
			<h3>交通路线</h3>
			<%=h_line%>
		</section>
		
		<section data-role="collapsible">
			<h3>房间类型</h3>
		</br>
		<ul data-role="listview">
<%
						Sql = "Select * from T_Product  Where state='normal'  and enabled='Y'  and online='Y' and  hid="&hid
						Set Rs = Dream3CLS.Exec(Sql)
						i=0
						do while not Rs.eof 
							i=i+1
							detail_id = Rs("id")
							housetitle = Rs("housetitle")
							area = Rs("area")
							roomsnum = Rs("roomsnum")
							bedtype = Rs("bedtype")
							bedtype = Dream3Static.GetBedType(bedtype)
							dayrentprice = Rs("dayrentprice") 
							guestnum = Rs("guestnum")
							weekrentprice = Rs("weekrentprice") 
							monthrentprice = Rs("monthrentprice")
							RoomDesc = Rs("RoomDesc")
							image = Rs("image")
							
						%>
				
						
						<li>
							<img src=<%=image%> width="100" height="80">
							<a href="mobiledetail.asp?pid=<%=detail_id%>&fromdate=<%=Dream3CLS.TimeFormateToTwoBits(fromDate)%>&todate=<%=Dream3CLS.TimeFormateToTwoBits(toDate)%> " >
								<h3><%=houseTitle%></h3>
								<p><%=bedtype%>  面积：<%=area%>平</p>
							</a>
							<span class="ui-li-count"><a>￥<%=dayrentprice%> 起</a></span>
						</li>
						
						
						<%
						Rs.movenext
						loop
						%>

						
			</ul>
		</section>
	 </div>
</div><!-- /page -->


