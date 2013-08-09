<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<%
Dim Action
Dim Rs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim pid, username, email, cityId

	Action = Request.QueryString("act")
	Select Case Action
		   Case "delete"
		   		Call DeleteRecord()
		   Case Else
				Call Main()
	End Select
	
	Sub DeleteRecord()
		linkId = Dream3CLS.ChkNumeric(Request("pid"))
		Sql = "Delete From T_User Where id="&linkId
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		Call Main()
	End Sub
	

	
	Sub Main()		
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		
		
		
		sql = "select id,email,username,create_time,mobile from T_User where manager='Y' "
		sqlCount = "SELECT Count([id]) FROM [T_User] where manager='Y' "
	
			
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
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">管理员列表</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">
					
				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" id="orders-list" class="coupons-table">
					<tbody>
					
					<tr>
						<th nowrap="" width="40">ID</th>
						<th nowrap="" width="150">Email</th>
						<th nowrap="" width="200">用户名</th>
						<th nowrap="" width="40%">注册时间</th>
						<th nowrap="" width="60">手机号码</th>
						<th nowrap="" width="120">操作</th>
					</tr>
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
				
					%>			
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td><%=arrU(0,i)%></td>
						<td><%=arrU(1,i)%></td>
						<td><%=arrU(2,i)%></td>
						<td><%=arrU(3,i)%></td>
						<td><%=arrU(4,i)%></td>
						<td align="center">
						<a class="ajaxlink" href="userEdit.asp?act=showEdit&pid=<%=arrU(0,i)%>">编辑</a>
						</td>
					  </tr>
					  <%
						Next
					  End If
					  %>
					  <tr>
						  <td colspan="8" align="right">
						  <%= strPageInfo%>
						  </td>
					  </tr>
                    </tbody>
					
					</table>
				</div>
				
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->