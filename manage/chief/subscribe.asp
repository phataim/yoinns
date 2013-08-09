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
Dim cityname,email
Dim cityMap

Set cityMap = new AspMap
Call Dream3Team.getCategoryMap("city",cityMap)

	Action = Request.QueryString("act")
	Select Case Action
		   Case "delete"
		   		Call DeleteRecord()
		   Case Else
				Call Main()
	End Select
	
	Sub DeleteRecord()
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		Sql = "Delete From T_Subscribe Where id="&id
		
		Dream3CLS.Exec(Sql)
		gMsgArr = "删除成功！"
		gMsgFlag = "S"
		Call Main()
	End Sub
	

	
	Sub Main()		
		email = Dream3CLS.RSQL("email")
		cityname = Dream3CLS.RSQL("cityname")
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl&"?cityname="&cityname&"&email="&email
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		If email <> "" Then
			searchStr = " and email like '%"&email&"%'"
		End If
		If cityname <> "" Then
			searchStr = searchStr&" and city_id in(select id from T_Category Where classifier='city' and cname like '%"&cityname&"%')"
		End If
		
		
		sql = "select id,email,city_id,secret,[enabled] from T_Subscribe where 1=1"&searchStr
		sqlCount = "SELECT Count([id]) FROM [T_Subscribe] where 1=1"&searchStr
	
			
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

<div id="box">
 <div id="content" class="coupons-box clear mainwide">
		<div class="box clear">
            <div class="box-top"></div>
            <div class="box-content">
                <div class="head">
                    <h2>邮件订阅列表</h2>
					<ul class="filter">
						<li></li>
					</ul>
				</div>
				<div class="sect" style="padding:0 10px;">
					<form method="post" action="subscribe.asp">
						<p style="margin:5px 0;">
						城市：<input type="text" name="cityname" value="<%=cityname%>" class="h-input" />&nbsp;
						邮件：<input type="text" name="email" value="<%=email%>" class="h-input" />&nbsp;
						<input type="submit" value="筛选" class="formbutton"  style="padding:1px 6px;"/>
						<form>
						</p>
				</div>
                <div class="sect">
					<table id="orders-list" cellspacing="0" cellpadding="0" border="0" class="coupons-table">
					<tr>
					<th width="350">邮件地址</th>
					<th width="80">城市</th>
					<th width="80">是否验证</th>
					<th width="350">密钥</th>
					<th width="80">操作</th>
					</tr>
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
							If arrU(2,i) = 0 Then
								cityname = "其他"
							Else
								cityname = cityMap.getv(CStr(arrU(2,i)))
							End if
							
							If arrU(4,i) = "Y" Then
								enabledStr = "是"
							Else
								enabledStr = "否"
							End If
					%>	
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td nowrap><%=arrU(1,i)%></td>
						<td nowrap><%=cityname%></td>
						<td nowrap><%=enabledStr%></td>
						<td nowrap><%=arrU(3,i)%></td>
						<td class="op" nowrap>
						<a  href="subscribe.asp?act=delete&id=<%=arrU(0,i)%>" class="ajaxlink" onclick="return window.confirm('您确定要删除该条记录?')">删除</a>
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
					<%End If%>			
                    </table>
				</div>
            </div>
            <div class="box-bottom"></div>
        </div>
    </div>
</div>
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->
