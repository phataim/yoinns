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
Dim userIdArr()

Set userMap = new AspMap

Set cityMap = new AspMap
Call Dream3Product.getCategoryMap("city",cityMap)

	Action = Request.QueryString("act")
	Select Case Action
		   Case "delete"
		   		Call DeleteRecord()
			Case "read"
				Call ReadRecord()
		   Case Else
				Call Main()
	End Select
	
	Sub ReadRecord()
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		Sql = "Update T_FeedBack Set user_id = "&session("_UserID")&" Where id="&id
		
		Dream3CLS.Exec(Sql)
		gMsgArr = "处理完成！"
		gMsgFlag = "S"
		Call Main()
	End Sub
	
	
	Sub DeleteRecord()
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		Sql = "Delete From T_FeedBack Where id="&id
		
		Dream3CLS.Exec(Sql)
		gMsgArr = "删除成功！"
		gMsgFlag = "S"
		Call Main()
	End Sub
	

	
	Sub Main()		

		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		
		intPageNow = request.QueryString("page")

		intPageSize = 10

		sql = "select id,classifier,user_id,title,contact,content,create_time from T_FeedBack where 1=1 Order By create_time Desc"
		sqlCount = "SELECT Count([id]) FROM [T_FeedBack] where 1=1"&searchStr
	
			
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
				userIdArr(i) = arrU(2,i)
			Next
			
			Call Dream3Team.getUserMap(userIdArr,userMap)
			
		End If
			
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<script type="text/javascript" src="../../common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="../../common/js/jquery/jquery.dream3box.js"></script>
<div id="box">
 <div id="content" class="coupons-box clear mainwide">
		<div class="box clear">
            <div class="box-top"></div>
            <div class="box-content">
                <div class="head">
                    <h2>意见反馈及商务合作</h2>
					<ul class="filter">
						<li></li>
					</ul>
				</div>
				
                <div class="sect">
					<table id="orders-list" cellspacing="0" cellpadding="0" border="0" class="coupons-table">
					<tr>
					<th width="200">客户</th>
					<th width="80">类型</th>
					<th width="360">内容</th>
					<th width="80">状态</th>
					<th width="80">日期</th>
					<th width="100">操作</th>
					</tr>
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
							If arrU(1,i) = "seller" Then
								category = "商务合作"
							End if
							
					%>	
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td nowrap><%=arrU(3,i)%></td>
						<td nowrap><%=category%></td>
						<td nowrap><%=Dream3CLS.GetStrValue(arrU(5,i),20)%></td>
						<td nowrap>
						<%
						If IsArray(userMap.getv(CStr(arrU(2,i)))) Then
							Response.Write(userMap.getv(CStr(arrU(2,i)))(0))
						End If
						%>
						</td>
						<td nowrap><%=FormatDateTime(arrU(6,i),2)%></td>
						<td class="op" nowrap>
						<%
						If arrU(2,i) = 0 Then
						%>
						<a  href="feedback.asp?act=read&id=<%=arrU(0,i)%>" class="ajaxlink" onclick="return window.confirm('您确定要删除该条记录?')">处理</a>|
						<%
						End If
						%>
						<a  href="feedback.asp?act=delete&id=<%=arrU(0,i)%>" class="ajaxlink" onclick="return window.confirm('您确定要删除该条记录?')">删除</a>
						<a  href="#" class="ajaxlink" onclick="ShowDetail(<%=arrU(0,i)%>)">详情</a>
						<div id="feedback_content_<%=arrU(0,i)%>" style="display:none;width:500px;height:400px;">
							<p class="info"><b>类型：</b><%=category%></p>
							<p class="info"><b>客户：</b><%=arrU(3,i)%></p>
							<p class="info"><b>联系方式：</b><%=arrU(4,i)%></p>
							<p class="info"><b>内容：</b><%=arrU(5,i)%></p>
						</div>
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



<script language="javascript">
function ShowDetail(pid){
	$('#feedback_content_'+pid).dream3box({title:"",shut:"关闭"});
}
</script>

<!--#include file="../../common/inc/footer_manage.asp"-->
