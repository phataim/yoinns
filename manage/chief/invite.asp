<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
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
Dim pid,classifier,searchStr,stateStr
Dim teamIdArr(),userIdArr(),touserIdArr(),adminIdArr()
Dim c,username,tousername,id

Set teamMap = new AspMap
Set userMap = new AspMap
Set touserMap = new AspMap
Set adminMap = new AspMap
	
	Action = Request.QueryString("act")
	Select Case Action
		Case "agree"
			Call PayBonus()
		Case "cancel"
		   	Call DealRecord("C")
		Case Else
			Call Main()
	End Select
	
	Sub DealRecord(op)
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * From T_Invite Where state='R' and id="&id

		
		Rs.open Sql,conn,1,2
		If Not Rs.EOF Then
			Rs("state")= op
			Rs("admin_id") = Session("_UserID")
			Rs.Update
		End If
		Rs.Close
		Set Rs = Nothing
		
		'如果核准，则写入财务表
		
		gMsgFlag = "S"
		gMsgArr = "设置成功"
		Call Main()
	End Sub
	
	'更新邀请的状态
	Sub PayBonus()
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		Set f_rs = Server.CreateObject("adodb.recordset")			
		f_sql = "Select * From T_Invite Where state='R' and id ="&id 
		f_rs.open f_sql,conn,1,2
		If f_rs.EOF Then
			Exit Sub
		Else
			f_rs("state") = "Y"
			f_rs("admin_id") = Session("_UserID")
			
			user_id = f_rs("user_id")
			team_id = f_rs("team_id")
			credit = CDBL(f_rs("credit"))
		
			f_rs.Update
			f_rs.Close
			Set f_rs = Nothing
		End If
		
		'给对方账户充值
		If clng(SiteConfig("InviteBonus")) > 0 Then
			Dream3User.AddOrDeductUserMoney user_id,SiteConfig("InviteBonus")
			
			Dream3Team.WriteToFinRecord user_id,session("_UserID"),team_id,"income","invbonus",SiteConfig("InviteBonus")
		End If
		gMsgFlag = "S"
		gMsgArr = "设置成功"
		
	End Sub

	
	Sub Main()		

		classifier = Dream3CLS.RParam("c")
		username = Dream3CLS.RSQL("username")
		tousername = Dream3CLS.RSQL("tousername")
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl & "?c="&classifier&"&username="&username
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		Select Case classifier
		    Case "record"
		   		stateStr = "Y"
				searchStr = " and state='"&stateStr&"'"
			Case "cancel"
		   		stateStr = "C"
				searchStr = " and state='"&stateStr&"'"
		    Case Else
				searchStr = " and state='R'"
				classifier = "index"
		End Select
		
		
		If username <> "" Then
			searchStr = searchStr&" and user_id in (select id from T_User Where username like '%"&username&"%')"
		End If	
		If tousername <> "" Then
			searchStr = searchStr&" and other_user_id in (select id from T_User Where username like '%"&tousername&"%')"
		End If	
		
		sql = "select id,user_id,admin_id,team_id,other_user_id,buy_time,state,create_time from T_Invite  where 1=1 "&searchStr
		sql = sql &" order by buy_time Desc"
		sqlCount = "SELECT Count([id]) FROM [T_Invite] where 1=1 "&searchStr
	
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
					ReDim Preserve touserIdArr(i)
					ReDim Preserve adminIdArr(i)
					teamIdArr(i) = arrU(3,i)
					userIdArr(i) = arrU(1,i)
					touserIdArr(i) = arrU(4,i)
					adminIdArr(i) = arrU(2,i)
				Next
				
				Call Dream3Team.getTeamMap(teamIdArr,teamMap)
				Call Dream3Team.getUserMap(userIdArr,userMap)
				Call Dream3Team.getUserMap(touserIdArr,touserMap)
				Call Dream3Team.getUserMap(adminIdArr,adminMap)
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
					<h2>邀请记录</h2>
					<ul class="filter">
						<li>
						<form method="post" action="invite.asp">
						邀请人登录名：
						<input type="text" class="h-input" value="<%=username%>" name="username"/>&nbsp;
						被邀人登录名：
						<input type="text" class="h-input" value="<%=tousername%>" name="tousername"/>&nbsp;
						<input type="hidden" name="c" value="<%=classifier%>"/>
 						<input type="submit" style="padding: 1px 6px;" class="formbutton" value="筛选"/>
						</form>
						</li>
						<li <%If classifier="index" Then response.Write("class='current'")%>><a href="invite.asp?c=index">邀请记录</a></li>
						<li <%If classifier="record" Then response.Write("class='current'")%>><a href="invite.asp?c=record">返利记录</a></li>
						<li <%If classifier="cancel" Then response.Write("class='current'")%>><a href="invite.asp?c=cancel">违规记录</a></li>
					</ul>
				</div> 
					
				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" class="coupons-table" id="orders-list">
					<tbody>
					<tr>
					<th width="350">项目</th>
					<th width="150">主动用户</th>
					<th width="150">被邀用户</th>
					<th width="170">邀买时间</th>
					<th width="150">
					<%
					If classifier = "index" Then
					%>
					操作
					<%Else%>
					操作员
					<%
					End If
					%>
					
					</th>
					</tr>
					
					<%
					Dim bgColor
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
				
					%>		
					<tr>
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
							<td nowrap=""><%=teamMap.getv(CStr(arrU(3,i)))%></td>
							<td>
							<%=Dream3User.GetUserFromMap(userMap,arrU(1,i))%>
							</td>
							<td>
							<%=Dream3User.GetUserFromMap(touserMap,arrU(4,i))%>
							</td>
							<td>
							<%=Dream3CLS.Formatdate(arrU(7,i),1)%><br>
							<%
							If arrU(5,i) <> "" Then 
								Response.Write(Dream3CLS.Formatdate(arrU(5,i),1))
							End If
							%>
							</td>
							<td nowrap="" class="op">
							<%
							'邀请记录显示 核准和取消
							'返利记录和违规记录显示操作员
							If classifier = "index" Then
							%>
							<a href="invite.asp?act=agree&id=<%=arrU(0,i)%>" onclick="return window.confirm('您确定要核准该笔记录?')">核准</a>｜
							<a class="remove-record" href="invite.asp?act=cancel&id=<%=arrU(0,i)%>" onclick="return window.confirm('您确定要取消该笔记录?')">取消</a>
							<%
							End If
							%>
							<%
							If classifier = "record" or classifier = "cancel" Then
							%>
							<%=Dream3User.GetUserFromMap(adminMap,arrU(2,i))%>
							<%
							End If
							%>

							</td>
					</tr>
					 <%
						Next
					  End If
					  %>
					<%
					If IsArray(arrU) Then
					%>	
					<tr>
						  <td colspan="8" align="right">
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
