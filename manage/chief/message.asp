<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
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
Dim content

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
		Sql = "Delete From T_Message Where id="&id
		
		Dream3CLS.Exec(Sql)
		gMsgArr = "删除成功！"
		gMsgFlag = "S"
		Call Main()
	End Sub
	

	
	Sub Main()		
		content = Dream3CLS.RSQL("content")
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl&"?content="&content
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		If content <> "" Then
			searchStr = " and content like '%"&content&"%'"
		End If
		
		sql = "select id,user_id, [content],[comment],create_time,comment_time from T_Message where 1=1"&searchStr
		sql = sql & " order by create_time desc" 
		sqlCount = "SELECT Count([id]) FROM [T_Message] where 1=1"&searchStr
	
			
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
					ReDim Preserve userIdArr(i)
					userIdArr(i) = arrU(1,i)
				Next
				
				Call Dream3Product.getUserMap(userIdArr,userMap)

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
				
					<h2>留言板管理</h2>
					<ul class="filter">
						<li>
						<form method="post" action="message.asp">
						内容：
						<input type="text" value="<%=content%>" name="content" class="h-input">&nbsp;
						<input type="submit" style="padding: 1px 6px;" class="formbutton" value="筛选">
						</form>
						</li>
					</ul>
				</div> 
					
				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" id="orders-list" class="coupons-table" style="table-layout:fixed;word-break:break-all;">
						<tr>
							<th width="100">留言人</th>
							<th width="320">内容</th>
							<th width="320">管理员答复</th>
							<th width="80">操作</th>
						</tr>
						
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
							s_username = ""
							s_user_id = CStr(arrU(1,i))
							If CStr(arrU(1,i)) <> "0" Then
								If IsArray(userMap.getv(s_user_id)) Then
									s_username = userMap.getv(s_user_id)(0)
								End If
							End If
							If s_username = "" Then 
								s_username = "游客"
							End If
							
							
							s_create_time = arrU(4,i)
							s_content = arrU(2,i)
							s_comment = arrU(3,i)
					%>		
						<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
							<td><%=s_username%></td>
							<td><%=s_content%></td>
							<td><%=s_comment%></td>
							<td nowrap="" class="op">
							<a href="messageReply.asp?id=<%=arrU(0,i)%>">答复</a>｜
							<a class="remove-record" href="?act=delete&id=<%=arrU(0,i)%>" onclick="return window.confirm('您确定要删除该笔记录?')">删除</a></td>
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
