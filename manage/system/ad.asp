<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim id

	Action = Request.QueryString("act")
	Select Case Action
		   Case "delete"
		   		Call DeleteRecord()
		   Case Else
				Call Main()
	End Select
	
	Sub DeleteRecord()
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		Sql = "Delete From T_AD Where id="&Id
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		Call Main()
	End Sub
	

	
	Sub Main()		

		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		
		sql = "select id,title,url,enabled,seqno,create_time from T_AD order by seqno desc "
		sqlCount = "SELECT Count([id]) FROM [T_AD]"
	
			
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
        <span class="fl">广告管理</span>
        <span class="fr">
        	<a class="ajaxlink" href="adEdit.asp?act=showAdd">添加广告图片</a>
        </span>
    </div>
    <div class="say">
        
    </div>
</div>


<div id="box">
					
				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" id="orders-list" class="coupons-table">
					<tbody>
					
					<tr>
						<th nowrap="" width="40">ID</th>
						<th nowrap="" width="150">标题</th>
						<th nowrap="" width="300">链接地址</th>
						<th nowrap="" width="80">状态</th>
						<th nowrap="" width="60">排序</th>
						<th nowrap="" width="120">操作</th>
					</tr>
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
							s_id = arrU(0,i)
							s_title = arrU(1,i)
							s_url = arrU(2,i)
							s_enabled = arrU(3,i)
							If s_enabled = "Y" Then
								s_enabled = "可用"
							Else
								s_enabled = "禁用"
							End If
							s_seqno = arrU(4,i)
							s_create_time = arrU(5,i)
				
					%>			
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td><%=s_id%></td>
						<td><%=s_title%></td>
						<td><%=s_url%></td>
						<td><%=s_enabled%></td>
						<td><%=s_seqno%></td>
						<td align="center">
						<a class="ajaxlink" onclick="return window.confirm('您确定要删除该广告?')" href="?act=delete&id=<%=s_id%>">删除</a>｜
						<a class="ajaxlink" href="adEdit.asp?act=showEdit&id=<%=s_id%>">编辑</a>
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
						  <td colspan="6" align="right">
						  <%= strPageInfo%>
						  </td>
					  </tr>
					  <%End If%>
                    </tbody>
					
					</table>
				</div>

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->