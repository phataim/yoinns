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
		
		'���ڶ����������ڴ�ʱ�䷶Χ�ڵĶ����ڵ��ڶ���
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
			
			
			'ѭ�����飬��Ѱid����������
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
					<h2>�����</h2>
					<ul class="filter"><li>
					<form method="post" action="pay.asp">
					�û�Email��<input type="text" value="<%=email%>" class="h-input" name="email">&nbsp;
					��Ŀ��ţ�<input type="text" value="<%=team_id%>" class="h-input number" name="team_id">&nbsp;
					<input type="submit" style="padding: 1px 6px;" class="formbutton" value="ɸѡ">
					</form></li></ul>
				</div> 
					
				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" class="coupons-table" id="orders-list">
					<tbody>
					<tr>
					<th width="40">ID</th>
					<th width="280">��Ŀ</th>
					<th width="140">�û�</th>
					<th nowrap="" width="40">����</th>
					<th nowrap="" width="50">�ܿ�</th>
					<th nowrap="" width="50">���<br>֧��</th>
					<th nowrap="" width="50">֧��</th>
					<th nowrap="" width="50">����</th>
					<th nowrap="" width="120">����/֧��ʱ��</th>
					<th nowrap="" width="40">����</th>
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
							response.Write("���")
						Else
							response.Write("�Ż�ȯ")
						End if
						%>
						</td>
						<td>��:<%=arrU(12,i)%><br>��:<%=arrU(13,i)%></td>
						<td nowrap="" class="op"><a class="ajaxlink" href="orderDetail.asp?id=<%=arrU(0,i)%>">����</a></td>
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