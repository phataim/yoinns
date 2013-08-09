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
<!--#include file="common/inc/city_common.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo,strTotalRecord
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim sitename,group_id,enabled,to_group_id,city_id
Dim starttime,sitetitle
Dim groupComboItem,cityComboItem

Dim fromDate,toDate,fromdate_str,todate_str
Dim citycode ,cityname,keyword
Dim orderby
Dim leaseType ,lodgeType,district

Dim p  ' 价格
Dim l ' 房屋类型


Dim userIdArr()

'首页猎头者软件新加内容
Dim searchname,price,service,facilities ,searchp,listSearchName

'新加内容结束

Set groupMap = new AspMap
Set cityMap = new AspMap
Set userMap = new AspMap


	Action = Request.QueryString("act")
	Select Case Action
		Case Else
			Call Main()
	End Select
	
	
	
	Sub Main()		

		' 搜索
		l = Dream3CLS.RSQL("l")
		
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
		
		'新增内容
		searchname=Dream3CLS.RParam("searchname")'搜索旅店名称
		listSearchName = Dream3CLS.RParam("listSearchName")
		keyword = Dream3CLS.RParam("keyword")'    index里面没声明的
		orderby  = Dream3CLS.RParam("orderby")'    index里面没声明的
		leaseType  = Dream3CLS.RParam("leaseType")'    index里面没声明的
		lodgeType  = Dream3CLS.RParam("lodgeType")'    index里面没声明的
		district =  Dream3CLS.RParam("district")'
		cityname=Dream3CLS.RParam("cityname")'    index里面没声明的
		citycode = Dream3CLS.RParam("city")'此处citycode为空 index里面没声明的
		price= Dream3CLS.RParam("price")'    index里面没声明的
		service=Dream3CLS.RParam("service")'    index里面没声明的
		if price="" then
		   price=0
		  
		else
			price=cint(price)
		end if
		'新内容
		Select Case price
			Case 0
			
				searchp = ""
			Case 40
				searchp = " and dayrentprice<50"
			Case 80
				searchp = " and (dayrentprice<100 and dayrentprice>=50)"
			Case 120
				searchp = " and (dayrentprice<150 and dayrentprice>=100)"
			Case 160
				searchp = " and (dayrentprice<200 and dayrentprice>=150)"
			Case 230
				searchp = " and (dayrentprice<250 and dayrentprice>=200)"
			Case 280
				searchp = " and (dayrentprice<300 and dayrentprice>=250)"
			Case 320
				searchp = " and dayrentprice>=300"
			Case else
				Call Dream3CLS.MsgBox2("参数错误！",0,"0")
		End Select
		
		'If (fromDate <> "yyyy-mm-dd") and (toDate <> "yyyy-mm-dd") then
		 	'if DateDiff("d",fromDate,toDate)<1 then
				'Call Dream3CLS.MsgBox2("退房日期要大于入住日期",0,"0")
			
			'end if
		'end if
		
		If fromDate <> "yyyy-mm-dd" Then
		
			If IsSQLDataBase = 1 Then
				searchp = searchp &" and Datediff(s,startDate,'"&fromDate&"') >= 0 "
			Else
				searchp = searchp &" and Datediff('s',startDate,'"&fromDate&"') >= 0 "
			End If

		End If

		If toDate <> "yyyy-mm-dd" Then
		
			endTimeTomrrow = Dream3CLS.GetStartTime(dateadd("d",1,CDate(toDate)))
			
			If IsSQLDataBase = 1 Then
				searchp = searchp &"and Datediff(s,expireDate,'"&endTimeTomrrow&"') <= 0 "
			Else
				searchp = searchp &"and Datediff('s',expireDate,'"&endTimeTomrrow&"') <= 0 "
			End If
			
		End If

		Sqlp = "Select distinct hid,facilities from T_Product Where  1=1 and state='normal' "
		sqlp = sqlp & searchp 
		
		Set pRs = Dream3CLS.Exec(Sqlp)
		Do While Not pRs.EOF
		facilities = ","&pRs("facilities")&","
		if service<>"" then
			If instr(facilities,","&service&",") Then
				prid = prid&pRs("hid")&","
			End If
		else
			prid = prid&pRs("hid")&","
		end if
		pRs.Movenext
		Loop
		if right(prid,1)="," then 
			prid=left(prid,len(prid)-1) 
		end if 
		if prid<>"" then
			searchStr=" and h_id in ("&prid&")"
		else
			searchStr=" and h_id in (-1)"
		end if
		
		'新内容结束
		If cityname <> "" Then
			Sql = "Select cityname,citypostcode from T_City Where 1=1 and (depth = 2 or zxs = 1) and cityname like '%"&cityname&"%' "
			Set Rs = Dream3CLS.Exec(sql)
			If Rs.EOF Then
				Call Dream3CLS.MsgBox2("请选择已开通的城市！",0,"0")
				Response.End()
			End If
			citycode = Rs("citypostcode")
			G_City_NAME=cityname
		End If
		if citycode <> "" Then
			'设置全局citycode为citycode
			'全局城市ID
			G_City_ID = citycode
			G_City_NAME = cityname
			Response.Cookies(DREAM3C).Expires = Date + 365
			Response.Cookies(DREAM3C)("_UserCityID") = citycode
			Call GetCityName()
		End if
		If district = "" Then
			If citycode <> "" Then
				If Right(citycode,4) = "0000" Then
						searchStr =searchStr&" and h_citycode like '"&Left(citycode,2)&"%'"
					Else
						searchStr = searchStr&" and h_citycode like '"&Left(citycode,4)&"%'"
					End If
				
			End If
		Else
			searchStr = searchStr& " and h_citycode =  '"&district&"'"
		End If
		
		If searchname = "旅店名称" or searchname = "输入酒店名称" Then
			searchname = ""
		End If
		
		If searchname <> "" Then
			searchStr = searchStr &" and h_hotelname like '%"&searchname&"%' "
		End If
		
		If listSearchName <> "" Then
			searchStr = searchStr &" and h_hotelname like '%"&listSearchName&"%' "
		End If
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl & "?city="&citycode&"&fromDate="&Dream3CLS.TimeFormateToTwoBits(fromDate)&"&toDate="&Dream3CLS.TimeFormateToTwoBits(toDate)&"&orderby="&orderby&"&leaseType="&leaseType&"&lodgeType="&lodgeType&"&price="&price&"&service="&service
		
		intPageNow = request.QueryString("page")

		intPageSize = 6
		
		Select Case orderby
			'Case "default"
				'sqlOrder = "order by id desc"
			'Case "price_low2high"
				'sqlOrder = " order by dayrentprice asc"
			'Case "price_high2low"
				'sqlOrder = " order by dayrentprice desc"
			Case else
				sqlOrder = " order by h_ordertime desc"
		End Select
		
		sql = "select * from T_hotel Where 1=1 "
		sql = sql & searchStr &sqlOrder
		't(sql)
		'response.write sql

		sqlCount = "SELECT Count([h_id]) FROM [T_hotel] where 1=1"&searchStr
		
	
		Set clsRecordInfo = New Cls_PageView
			clsRecordInfo.intRecordCount = 2816
			clsRecordInfo.strSqlCount = sqlCount
			clsRecordInfo.strSql = sql
			clsRecordInfo.intPageSize = intPageSize
			clsRecordInfo.intPageNow = intPageNow
			clsRecordInfo.strPageUrl = strLocalUrl
			clsRecordInfo.strPageVar = "page"
		clsRecordInfo.objConn = Conn		
		'arrU = clsRecordInfo.arrRecordInfo
		strPageInfo = clsRecordInfo.strPageInfo
		strTotalRecord  = clsRecordInfo.strTotalRecord
		Set clsRecordInfo = nothing
	
	
	Set rs = Server.CreateObject("Adodb.RecordSet")
	rs.open sql, Conn, 1, 1
		if not rs.eof then
		arrU = rs.getrows
		end if
	End Sub
	
	
%>


<div data-role="page" >
   <div data-role="header">
      <h1>旅店列表</h1>
   </div><!-- /header -->
   <nav data-role="navbar">
	<ul>
	<li><a href="mobile.asp?city=120101" rel="external">贝岗</a></li>
	<li><a href="mobile.asp?city=140101" rel="external">北亭</a></li>
	<li><a href="mobile.asp?city=150101" rel="external">穗石</a></li>
	<li><a href="mobile.asp?city=130101" rel="external">南亭</a></li>
	</ul>
   </nav>
    <form id="listSearchNameForm" date-role="none"  action="mobile.asp" method="post" >
		<input type="search" name="listSearchName" id="listSearchName" value="搜索旅店名称" 
			onfocus="listSubmitSearchOnFocus();" onblur="listSubmitSearchOnBlur();"/>
	
	</form>
   
	<ul data-role="listview">
   	<%
					'seq = 1
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
							s_id = arrU(0,i)
							h_hotelname = arrU(1,i)
							h_img = arrU(6,i)
							If h_img <> "" Then 
								image = "../../"&h_img
							Else
								image = "/images/noimage.gif"
							End If
							h_citycode=arrU(4,i)
							h_address=arrU(5,i)
							h_line=arrU(9,i)
					%>
					
				<li>
				
				<img alt="<%=h_hotelname%>" src="<%If IsNull(image) or image="" Then response.Write("images/noimage.gif") else response.Write(image)%>" width="100" height="100">
				<a href="mobileshow.asp?hid=<%=s_id%>&fromdate=<%=Dream3CLS.TimeFormateToTwoBits(fromDate)%>&todate=<%=Dream3CLS.TimeFormateToTwoBits(toDate)%>" >
					<h3><%=h_hotelname%></h3>
						<p>区域：<%=Dream3Product.GetCityAdd(h_citycode)%></p>
						<p>地址：<%=h_address%></p>
				</a>
				
				</li>
		<%
			Next
			Else 
				if searchname <> "" then
				%>
				<li>不好意思没有找到 "<%=searchname%>"</li>
				<%else %>
				<li>不好意思没有找到 "<%=listSearchName%>"</li>
				<%
				end if
			End If
		 %>
</ul>

<script>

//对中文进行编码再提交
function listSubmitSearchOnFocus(){
	document.getElementsByName("listSearchName")[0].value="";	
}
function listSubmitSearchOnBlur(){
	if(document.getElementsByName("listSearchName")[0].value!=""&&
				document.getElementsByName("listSearchName")[0].value!="搜索旅店名称"){
		listSearchNameForm.submit();
	}
}

</script>
</div><!-- /page -->
