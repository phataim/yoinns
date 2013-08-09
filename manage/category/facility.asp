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
Dim classifier,title,enabled

	Action = Request.QueryString("act")
	Select Case Action
		Case "delete"
				Call DeleteRecord()
		Case "enabled"
				Call EnabledRecord()
		Case Else
				Call Main()
	End Select
	
	Sub DeleteRecord()
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		Sql = "Delete From T_Facility Where id="&id
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		gMsgArr = "删除成功"
		Call Main()
	End Sub
	
	Sub EnabledRecord()
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		classifier = Request.QueryString("classifier")
		enabled = Request.QueryString("enabled")
		If enabled ="Y" then
			Sql = "Update  T_Facility Set enabled='N' Where id="&id
		Else
			Sql = "Update  T_Facility Set enabled='Y' Where id="&id
		End If
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		gMsgArr = "设置成功"
		Call Main()
	End Sub

	
	Sub Main()		
		

		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		
		sql = "select id,cname,category,seqno,enabled from T_Facility Where 1=1 order by seqno desc"
		sqlCount = "SELECT Count([id]) FROM [T_Facility] Where 1=1"
		
	
			
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
			
		title = "房间设施"
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl"><%=title%></span>
        <span class="fr">
        	<a class="ajaxlink" href="facilityEdit.asp?act=showAdd">新建<%=title%></a>
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
						<th nowrap="" width="150">房间设施名称</th>
						<th nowrap="" width="40%">自定义分组</th>
						<th nowrap="" width="60">排序</th>
						<th nowrap="" width="60">状态</th>
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
						<td>
							<%If arrU(4,i)="Y" Then%>
								可用
							<%Else%>
								失效
							<%End If%>
						</td>
						<td align="center">
						<a class="ajaxlink" onclick="return window.confirm('您确定要删除该条记录?')" href="facility.asp?act=delete&id=<%=arrU(0,i)%>">删除</a>｜
						<a class="ajaxlink" href="facilityEdit.asp?act=showEdit&id=<%=arrU(0,i)%>">编辑</a>
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
						  <td colspan="7" align="right">
						  
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