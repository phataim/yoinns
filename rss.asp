<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"--><%
Dim Rs,Sql
Dim searchStr
'结束时间大于等于明早0点'开始时间小于等于今天凌晨
		
		If IsSQLDataBase = 1 Then
			searchStr = searchStr&" and Datediff(s,GetDate(),end_time)>=0  and Datediff(s,GetDate(),start_time)<=0"
		Else
			searchStr = searchStr&" and Datediff('s',Now(),end_time)>=0  and Datediff('s',Now(),start_time)<=0"
		End If
		
		'当前团购，按seqno排序，按地区显示
		searchStr = searchStr &" and (state='success' or state='normal') "
		'得到城市的ID，如果找不到，则默认为全部
		If G_City_ID <> 0 Then
			searchStr = searchStr &" and (city_id ="&G_City_ID &" OR city_id=0)"
		End If
		
		Sql = "Select id,start_time,title,city_id,market_price,team_price,image,pre_number,min_number,seqno,summary,end_time,detail ,userreview,systemreview,partner_id,conduser,max_number,reach_time,partner_id from T_Team Where 1=1 "&searchStr
		Sql = Sql &" Order By [Seqno] Desc"
		
		Set Rs = Dream3CLS.Exec(Sql)

Response.contentType="application/xml"

%><?xml version="1.0" encoding="gb2312"?>
<rss version="2.0">
<channel>

	<title><%=SiteConfig("SiteName")%>今日团购</title>
	<description><%=SiteConfig("SiteName")%> <%=SiteConfig("SiteTitle")%></description>
	<link><%=GSiteURL%>index.asp</link>

	<image>
		<title><%=SiteConfig("SiteName")%></title> 
		<url><%=GSiteURL%>images/logo/logo.jpg</url>
		<link><%=GSiteURL%>index.asp</link>
	</image>

<%
	Do while Not Rs.Eof
		image = Rs("image")
		systemreview = Rs("systemreview")
%>
	<item>
		<title><![CDATA[<%=Rs("title")%>]]></title>
		<link><%=GSiteURL%>team.asp?id=<%=Rs("id")%></link> 
  		<description><![CDATA[<%=Rs("summary")%><br /><img src='<%=GSiteURL%><%=Dream3Team.FilterImage(image)%>'/><%=systemreview%>]]></description> 
  		<author><%=G_CITY_NAME%></author> 
		<pubDate><%=DateTimeToGMT(Rs("start_time"))%></pubDate>	
		<guid><%=GSiteURL%>team.asp?id=<%=Rs("id")%></guid>
	</item>
<%
		Rs.MoveNext
		Loop
	Set Rs = Nothing
%>
</channel>
</rss>

<%
function FormatTime(value)
	FormatTime=""&FormatDateTime(value, 2)&" "&FormatDateTime(value, 4)&""
	FormatTime=""&Year(value)&"-"&Add0(Month(value))&"-"&Add0(Day(value))&" "&FormatDateTime(value, 4)&":"&Add0(Second(value))&""

end function

function Add0(value)
	if Len(value)<2 then value="0"&value
	Add0=value
end function

Function DateTimeToGMT(sDate)
   Dim dWeek,dMonth
   Dim strZero,strZone
   strZero="00"
   strZone="+0800"
   dWeek=Array("Sun","Mon","Tue","Wes","Thu","Fri","Sat")
   dMonth=Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
   DateTimeToGMT = dWeek(WeekDay(sDate)-1)&", "&Right(strZero&Day(sDate),2)&" "&dMonth(Month(sDate)-1)&" "&Year(sDate)&" "&Right(strZero&Hour(sDate),2)&":"&Right(strZero&Minute(sDate),2)&":"&Right(strZero&Second(sDate),2)&" "&strZone
End Function
%>