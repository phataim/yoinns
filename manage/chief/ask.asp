<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
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
Dim id,title,searchStr
Dim teamIdArr(),userIdArr()

Set teamMap = new AspMap
Set userMap = new AspMap

	Action = Request.QueryString("act")
	Select Case Action
		   Case "delete"
		   		Call DeleteRecord()
		   Case Else
				Call Main()
	End Select
	
	Sub DeleteRecord()
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		Sql = "Delete From T_Ask Where id="&id
		
		Dream3CLS.Exec(Sql)
		gMsgArr = "删除成功！"
		gMsgFlag = "S"
		Call Main()
	End Sub
	

	
	Sub Main()		
		title = Dream3CLS.RSQL("title")
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl&"?title="&title
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		If title <> "" Then
			searchStr = " and team_id in(select id from T_Team Where title like '%"&title&"%')"
		End If
		
		
		sql = "select id,user_id,team_id,city_id,content,comment,p_comment from T_Ask where 1=1"&searchStr
		sqlCount = "SELECT Count([id]) FROM [T_Ask] where 1=1"&searchStr
	
			
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
					teamIdArr(i) = arrU(2,i)
					userIdArr(i) = arrU(1,i)
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
				
					<h2>团购咨询</h2>
					<ul class="filter">
						<li>
						<form method="post" action="ask.asp">
						项目：
						<input type="text" value="<%=title%>" name="title" class="h-input">&nbsp;
						<input type="submit" style="padding: 1px 6px;" class="formbutton" value="筛选">
						</form>
						</li>
					</ul>
				</div> 
					
				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" id="orders-list" class="coupons-table" style="table-layout:fixed;word-break:break-all;">
						<tr>
							<th width="200">团购项目</th>
							<th width="60">咨询人</th>
							<th width="190">内容</th>
							<th width="130">管理员答复</th>
							<th width="130">商家答复</th>
							<th width="80">操作</th>
						</tr>
						
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
				
					%>		
						<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
							<td>
							<a href="#" class="deal-title"><%=teamMap.getv(CStr(arrU(2,i)))%></a>
							</td>
							<td nowrap="">
							<%
							If IsArray(userMap.getv(CStr(arrU(1,i)))) Then
								Response.Write(userMap.getv(CStr(arrU(1,i)))(0))
							End If
							%>
							</td>
							<td><%=Dream3CLS.GetStrValue(arrU(4,i),10)%></td>
							<td><%=Dream3CLS.GetStrValue(arrU(5,i),10)%></td>
							<td><%=Dream3CLS.GetStrValue(arrU(6,i),10)%></td>
							<td nowrap="" class="op">
							<a href="reply.asp?id=<%=arrU(0,i)%>">答复</a>｜
							<a class="remove-record" href="ask.asp?act=delete&id=<%=arrU(0,i)%>" onclick="return window.confirm('您确定要删除该笔记录?')">删除</a></td>
						</tr>
					  <%
						Next
					  End If
					  %>
						
					
					<%
					If IsArray(arrU) Then
					%>
						<tr>
						  <td colspan="6" align="right">
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
