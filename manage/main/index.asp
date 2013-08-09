<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<%
Dim Sql,Rs
Dim todayRegUserCount,regUserCount
Dim subscribeCount , totalProductCount
Dim totalPayOrderCount, todayPayOrderCount
Dim tomorrowStart,todayStart
tomorrowStart = Dream3CLS.GetStartTime(dateadd("d",1,now()))
todayStart = Dream3CLS.Formatdate(Dream3CLS.GetStartTime(Now()),1)

't(tomorrowStart)

Sql = "Select Count(id) From T_User Where 1=1 "
If IsSQLDataBase = 1 Then
	Sql = Sql &"and Datediff(s,create_time,'"&tomorrowStart&"') > 0 and Datediff(s,create_time,'"&todayStart&"') <= 0"
Else
	Sql = Sql &"and Datediff('s',create_time,'"&tomorrowStart&"') > 0 and Datediff('s',create_time,'"&todayStart&"') <= 0"
End If
Set Rs = Dream3CLS.Exec(Sql)
todayRegUserCount = Rs(0)

Sql = "Select Count(id) From T_User "
Set Rs = Dream3CLS.Exec(Sql)
regUserCount = Rs(0)

Sql = "Select Count(id) From T_Subscribe "
Set Rs = Dream3CLS.Exec(Sql)
subscribeCount = Rs(0)

Sql = "Select Count(id) From T_Product Where State = 'normal' "
Set Rs = Dream3CLS.Exec(Sql)
totalProductCount = Rs(0)

Sql = "Select Count(id) From T_Order Where state='pay' "
Set Rs = Dream3CLS.Exec(Sql)
totalPayOrderCount = Rs(0)

Sql = "Select Count(id) From T_Order Where 1=1 " 
If IsSQLDataBase = 1 Then
	Sql = Sql &"and Datediff(s,pay_time,'"&tomorrowStart&"') > 0 and Datediff(s,pay_time,'"&todayStart&"') <= 0"
Else
	Sql = Sql &"and Datediff('s',pay_time,'"&tomorrowStart&"') > 0 and Datediff('s',pay_time,'"&todayStart&"') <= 0"
End If

Set Rs = Dream3CLS.Exec(Sql)
todayPayOrderCount = Rs(0)
%>

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">有旅馆管理程序（<%=DREAM3SLSTuanBuild%>）</span><span class="fr">&nbsp;</span></div>
    <div class="say">
    有旅馆管理程序是一款具有强大的功能的基于ASP+MSSQL构架的房屋出租管理系统。官方网址:<a href="Http://yoinns.com" target="_blank">http://yoinns.com</a></div>
</div>

<div id="box">
	<div class="sect">
        <div class="wholetip clear"><h3>今日数据</h3></div>
			
			<p>今日注册用户数：<%=todayRegUserCount%></p>
			<p>总有效产品数量：<%=totalProductCount%></p>
			<p>总付款订单数：<%=totalPayOrderCount%></p>
			<p>今日付款订单数：<%=todayPayOrderCount%></p>
		
       
    </div>
</div>

<!--#include file="../../common/inc/footer_manage.asp"-->