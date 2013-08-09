<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<%
Dim Action
Dim Rs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim pid, username, email, cityid


	Action = Request.QueryString("act")
	Select Case Action
		   Case "setenabled"
		   		Call SetEnabled()
		   Case "delete"
		   		Call DeleteUser()
		   Case Else
				Call Main()
	End Select
	
	Sub SetEnabled()
		uid = Dream3CLS.ChkNumeric(Request("uid"))
		Set Rs = Server.CreateObject("Adodb.recordset")
		
		sql = "Select * From T_User Where id="&uid
		Rs.open Sql,conn,1,2
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到该用户！",0,"0")
			response.End()
		End If
		If Rs("enabled") = "Y" Then
			Rs("enabled") = "N"
		Else
			Rs("enabled") = "Y"
		End If
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		gMsgArr = "设置成功！"
		gMsgFlag = "S"
		Call Main()
	End Sub
	
	Sub DeleteUser()
		uid = Dream3CLS.ChkNumeric(Request("uid"))
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "Delete  From T_User Where id="&uid
		Dream3CLS.Exec(sql)
		gMsgArr = "删除成功！"
		gMsgFlag = "S"
		Call Main()
	End Sub
	

	
	Sub Main()		
	
		Dim searchStr
		
		username = Dream3CLS.RSQL("username")
		email = Dream3CLS.RSQL("email")
		cityId = Dream3CLS.ChkNumeric(Request("cityid"))
		
		If username <> "" Then
			searchStr = " and username like '%"&username&"%'"
		End If
		If email <> "" Then
			searchStr = searchStr&" and email like '%"&email&"%'"
		End If
		If cityid <> "" and cityid<>0 Then
			searchStr = searchStr&" and city_Id ="&cityid
		End If

		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl & "?username="&username&"&email="&email&"&cityid="&cityid
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		

		sql = "select id,email,username,money,zipcode,ip,create_time,mobile,state,enabled from T_User where 1=1 "&searchStr
		Sql = Sql & " Order By id Desc"
		sqlCount = "SELECT Count([id]) FROM [T_User] where 1=1 "&searchStr
		

	
			
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
	<div class="PageTitle">
        <span class="fl">用户列表</span>
        <span class="fr">
        	
        </span>
    </div>
    <div class="say">
        
			<form action="index.asp" method="post">
						用户名：<input type="text" name="username" class="h-input" value="<%=username%>" >&nbsp;
						邮件：<input type="text" name="email" class="h-input" value="<%=email%>" >&nbsp;
		
						<input type="submit" value="筛选" class="formbutton"  style="padding:1px 6px;"/>
						<form>
    </div>
</div>

<div id="box">

					
				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" id="orders-list" class="coupons-table">
					<tbody>
					
					<tr>
						<th nowrap="">ID</th>
					  <th nowrap="">Email</th>
					  <th nowrap="">用户名</th>
					  <th nowrap="">余额</th>
					  <th nowrap="">是否发布酒店</th>
					  <th nowrap="">IP</th>
					  <th nowrap="">电话</th>
					  <th nowrap="">用户类型</th>
						<th nowrap="">操作</th>
					</tr>
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
				
					%>			
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td><%=arrU(0,i)%></td>
						<td><%=arrU(1,i)%></td>
						<td><%=arrU(2,i)%></td>
						<td><%=Dream3CLS.FormatNumbersNil(arrU(3,i),2)%></td>
						<td><%=arrU(4,i)%></td>
						<td><%=arrU(5,i)%></td>
						<td><%=arrU(7,i)%></td>
						<td><%=arrU(8,i) %></td>
						<td align="center">
						<a class="ajaxlink" href="userDetail.asp?act=showEdit&pid=<%=arrU(0,i)%>" style="display:none ">充值</a>｜
						<%
						If arrU(9,i) = "Y" Then
							op = "禁用"
						Else
							op = "启用"
						End If
						%>
						<a class="ajaxlink" href="?act=setenabled&uid=<%=arrU(0,i)%>" onclick="return window.confirm('您确定要<%=op%>该用户?')" >
						<%=op%>
						</a>｜
						<a class="ajaxlink" href="userEdit.asp?act=showEdit&pid=<%=arrU(0,i)%>">编辑</a>｜
						<a class="ajaxlink" href="userWithdraw.asp?act=showEdit&pid=<%=arrU(0,i)%>" style="display:none ">提现</a>｜
						<a class="ajaxlink" href="?act=delete&uid=<%=arrU(0,i)%>" onclick="return window.confirm('您确定要删除该条记录?')">删除</a>
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
						  <td colspan="9" align="right">
						  
						  <%= strPageInfo%>
						  
						  </td>
					  </tr>
					  <%
					End If
					%>	
                    </tbody>
					
					</table>
				</div>
				

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->