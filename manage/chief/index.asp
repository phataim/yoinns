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

<div id="box">
<div class="clear mainwide" id="content">
        <div class="clear box">
            
            <div class="box-content">
                <div class="head"><h2>官方首页（<%=DREAM3SLSTuanBuild%>）</h2></div> 
					
				<div class="sect">
					<div class="wholetip clear"><h3>今日数据</h3></div>
					<div style="margin: 0pt 50px;">
						<p>今日注册用户数：<%=todayRegUserCount%></p>
					</div>
					<div style="margin: 0pt 50px;">
						<p>总有效产品数量：<%=totalProductCount%></p>
					</div>
					<div style="margin: 0pt 50px;">
						<p>总付款订单数：<%=totalPayOrderCount%></p>
					</div>
					<div style="margin: 0pt 50px;">
						<p>今日付款订单数：<%=todayPayOrderCount%></p>
					</div>
				</div>
				
            </div>
            
        </div>
	</div>
</div>

<!--#include file="../../common/inc/footer_manage.asp"-->
