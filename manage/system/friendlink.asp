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
Dim linkId

	Action = Request.QueryString("act")
	Select Case Action
		   Case "delete"
		   		Call DeleteLink()
		   Case Else
				Call Main()
	End Select
	
	Sub DeleteLink()
		linkId = Dream3CLS.ChkNumeric(Request.QueryString("linkId"))
		Sql = "Delete From T_FriendLink Where id="&linkId
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		Call Main()
	End Sub
	

	
	Sub Main()		

		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		'strLocalUrl = strLocalUrl
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		
		sql = "select id,siteName,siteUrl,logo,seqno from T_FriendLink order by seqno desc "
		sqlCount = "SELECT Count([id]) FROM [T_FriendLink]"
	
			
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
        <span class="fl">友情链接</span>
        <span class="fr">
        	<a class="ajaxlink" href="friendlinkEdit.asp?act=showAdd">添加链接</a>
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
						<th nowrap="" width="150">网站名称</th>
						<th nowrap="" width="200">网站网址</th>
						<th nowrap="" width="40%">LOGO</th>
						<th nowrap="" width="60">排序</th>
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
						<a class="ajaxlink" onclick="return window.confirm('您确定要删除该友情链接?')" href="friendLink.asp?act=delete&linkId=<%=arrU(0,i)%>">删除</a>｜
						<a class="ajaxlink" href="friendlinkEdit.asp?act=showEdit&linkId=<%=arrU(0,i)%>">编辑</a>
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