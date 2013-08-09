<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_user.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
	
	Action = Request.QueryString("act")
	Select Case Action
		Case Else
			Call Main()
	End Select
	
	Sub DealRecord(op)
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_Invite Where id="&id
		
		Rs.open Sql,conn,1,2
		Rs("state")= op
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		gMsgFlag = "S"
		gMsgArr = "设置成功"
		Call Main()
	End Sub

	
	Sub Main()		

		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		sql = "select id,user_id,team_id,city_id,content,comment,create_time from T_Ask  where 1=1 "

		sqlCount = "SELECT Count([id]) FROM [T_Ask] where 1=1 "
	
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
			
	End Sub
	
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<div id="box">
<div class="clear mainwide" id="content">
        <div class="clear box">
            <div class="box-top"></div>
			<div class="box-content">
				<div class="head">
					<h2>我的问答</h2>
				</div>
				
				
				<div class="sect consult-list">
					<ul class="list">
					<%
					Dim bgColor
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
						
						days = DateDiff("d",arrU(6,i),now)
						If days = 0 Then
							daysStr = "今日"
						Else
							daysStr = days&"天前"
						End If
				
					%>	
					<li id="ask-entry-1" >
						<div class="item">
							<p class="user"><strong><%=session("_UserName")%></strong><span><%=daysStr%></span></p>
							<div class="clear"></div>
							<p class="text"><%=arrU(4,i)%></p>
							<p class="reply"><strong>回复：</strong><%=arrU(5,i)%></p>
						</div>
					</li>
					<%
						Next
					  End If
					  %>
					</ul>
					<ul class="paginator"><%= strPageInfo%></ul>				
					</div>
				
			</div>
			<div class="box-bottom"></div>

        </div>
	</div>
</div>
