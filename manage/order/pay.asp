<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_team.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim pid,searchStr,email,team_id
Dim teamIdArr(),userIdArr()
Set teamMap = new AspMap
Set userMap = new AspMap

	Action = Request.QueryString("act")
	Select Case Action
		   Case Else
				Call Main()
	End Select
	
	
	Sub Main()	

		email = Dream3CLS.RSQL("email")
		team_id = Dream3CLS.RSQL("team_id")	

		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl &"?email="&email&"&team_id="&team_id
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		'当期订单，凡是在次时间范围内的都属于当期订单
		searchStr =  " and o.state='pay'"
		searchStr = searchStr&" and t.id = o.team_id "
		If email <> "" Then
			searchStr = searchStr & " and o.user_id in(select id from T_User Where email like '%"&email&"%')"
		End If
		If team_id <> "" Then
			searchStr = searchStr & " and o.team_id ="& Dream3CLS.ChkNumeric(team_id)
		End If
		
		sql = "select o.id , o.team_id,o.user_id,o.quantity,o.price,o.money,o.origin,o.credit,o.card,o.fare,o.state,o.express,o.create_time,o.pay_time from T_Order o, T_Team t where 1=1  "&searchStr
		Sql = Sql &" Order By create_time Desc"
		'
		sqlCount = "SELECT Count(o.id) FROM [T_Order] o,T_Team t where 1=1"&searchStr
	
			
			Set clsRecordInfo = New Cls_PageView
				clsRecordInfo.intRecordCount = 2816
				clsRecordInfo.strSqlCount = sqlCount
				clsRecordInfo.strSql = sql
				clsRecordInfo.intPageSize = intPageSize
				clsRecordInfo.intPageNow = intPageNow
				clsRecordInfo.strPageUrl = strLocalUrl
				clsRecordInfo.strPageVar = "page"
			clsRecordInfo.objConn = Conn		
			arrU = clsRecordInfo.arrRecordInfo
			strPageInfo = clsRecordInfo.strPageInfo
			Set clsRecordInfo = nothing
			
			
			'循环数组，搜寻id并存入数组
			If IsArray(arrU) Then
				For i = 0 to UBound(arrU, 2)
					ReDim Preserve teamIdArr(i)
					ReDim Preserve userIdArr(i)
					teamIdArr(i) = arrU(1,i)
					userIdArr(i) = arrU(2,i)
				Next
				
				Call Dream3Team.getTeamMap(teamIdArr,teamMap)
				Call Dream3Team.getUserMap(userIdArr,userMap)
				
			End If
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<div id="box">
<div class="clear mainwide" id="content">
        <div class="clear box">
            
            <div class="box-content">
                <div class="head">				
					<h2>付款订单</h2>
					<ul class="filter"><li>
					<form method="post" action="pay.asp">
					用户Email：<input type="text" value="<%=email%>" class="h-input" name="email">&nbsp;
					项目编号：<input type="text" value="<%=team_id%>" class="h-input number" name="team_id">&nbsp;
					<input type="submit" style="padding: 1px 6px;" class="formbutton" value="筛选">
					</form></li></ul>
				</div> 
					
				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" class="coupons-table" id="orders-list">
					<tbody>
					<tr>
					<th width="40">ID</th>
					<th width="280">项目</th>
					<th width="140">用户</th>
					<th nowrap="" width="40">数量</th>
					<th nowrap="" width="50">总款</th>
					<th nowrap="" width="50">余额<br>支付</th>
					<th nowrap="" width="50">支付</th>
					<th nowrap="" width="50">递送</th>
					<th nowrap="" width="120">订单/支付时间</th>
					<th nowrap="" width="40">操作</th>
					</tr>
					
					
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
				
					%>		
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td><%=arrU(0,i)%></td>
						<td><%=arru(1,i)%>&nbsp;(<a target="_blank" href="../../team.asp?id=<%=arrU(1,i)%>" class="deal-title"><%=teamMap.getv(CStr(arru(1,i)))%></a>)</td>
						<td>
						<a class="ajaxlink" href="#">
						<%=Dream3User.GetUserFromMap(userMap,arrU(2,i))%>
						</a>
						</td>
						<td><%=arrU(3,i)%></td>
						<td><span class="money"><%=SiteConfig("CNYSymbol")%></span><%=arrU(6,i)%></td>
						<td><span class="money"><%=SiteConfig("CNYSymbol")%></span><%=arrU(7,i)%></td>
						<td><span class="money"><%=SiteConfig("CNYSymbol")%></span><%=arrU(5,i)%></td>
						<td>
						<%
						If arrU(11,i) = "Y" Then
							response.Write("快递")
						Else
							response.Write("优惠券")
						End if
						%>
						</td>
						<td>定:<%=arrU(12,i)%><br>付:<%=arrU(13,i)%></td>
						<td nowrap="" class="op"><a class="ajaxlink" href="orderDetail.asp?id=<%=arrU(0,i)%>">详情</a></td>
					</tr>
					  <%
						Next
					  End If
					  %>
					<%
					If IsArray(arrU) Then
					%>	
					<tr>
						  <td colspan="10" align="right">
						  <%= strPageInfo%>
						  </td>
					  </tr>
					 <%End If%>
                    </tbody></table>
				</div>
				
            </div>
            
        </div>
	</div>
</div>

<!--#include file="../../common/inc/footer_manage.asp"-->