<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim pid,classifier,searchStr,stateStr
Dim teamIdArr(),userIdArr(),adminIdArr()
Dim c,id,total
Dim classifierName

'reserve 待审核评论，用户支付租房时的待审核评论
'cash  管理员后台人工为订单支付现金

Set teamMap = new AspMap
Set userMap = new AspMap
Set adminMap = new AspMap
	
	Action = Request.QueryString("act")
	Select Case Action
		Case Else
			Call Main()
	End Select


	
	Sub Main()		

		classifier = Dream3CLS.RParam("c")
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl & "?c="&classifier
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		Select Case classifier
		    Case "reserve"
				searchStr = " and state='N'"
				classifierName = "待审核评论"
			Case "cash"
				searchStr = " and state='Y'"
				classifierName = "已审核评论"
			Case "manualrefund"
				searchStr = ""
				classifierName = "全部评论"
		    Case Else
				classifier = "reserve"
				classifierName = "待审核评论"
				searchStr = " and state='N'"
		End Select
		
		
		'得到总额
	
		

		If not isnumeric(Trim(totalMoney)) then totalMoney=0
		
		sql = "select id,roomid,username,hotelname,houseTitle,contents,state,createtime from T_Comments   where 1=1 "&searchStr
		sql = sql&" Order by createtime Desc"
		sqlCount = "SELECT Count(id) FROM T_Comments where 1=1 "&searchStr
        Set Rs = Dream3CLS.Exec(sqlCount)
		total = Rs(0)

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
			If IsArray(arrU) and false Then
				For i = 0 to UBound(arrU, 2)
					ReDim Preserve teamIdArr(i)
					ReDim Preserve userIdArr(i)
					ReDim Preserve adminIdArr(i)
					teamIdArr(i) = arrU(3,i)
					userIdArr(i) = arrU(1,i)
					adminIdArr(i) = arrU(2,i)
				Next
				
				'Call Dream3Team.getTeamMap(teamIdArr,teamMap)
				Call Dream3Product.getUserMap(userIdArr,userMap)
				Call Dream3Product.getUserMap(adminIdArr,adminMap)
			End If
			
		
	End Sub
	
%>
<!--#include file="action.asp"-->
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl"><%=classifierName%></span><span class="fr">&nbsp;</span></div>
    <div class="say">
	总数：<%=total%>
    </div>
</div>


<div id="box">
                <div class="sect">
				
					<%
					If trim(classifier) = "reserve" Then
					%>
					<table id="orders-list" cellspacing="0" cellpadding="0" border="0" class="coupons-table">
						<tr>
						<th width="400">评论内容</th>
						<th width="100"> 评论人</th>
						<th width="160">房型</th>
						<th width="200">旅馆</th>
						<th width="200">评论时间</th>
                        <th width="50">审核</th>
						</tr>
						<%
						If IsArray(arrU) Then
							For i = 0 to UBound(arrU, 2)
						%>
						<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
							
							<td nowrap><%=left(arrU(5,i),20)%></td>
							
							<td nowrap><%=arrU(2,i)%></td>
							<td nowrap><a href="../../detail.asp?pid=<%=arrU(1,i)%>" target="_blank"><%=arrU(4,i)%></a></td>
							
							<td nowrap><%=arrU(3,i)%></td>
							<td nowrap><%=arrU(7,i)%></td>
                            <td nowrap><a href="comments.asp?c=<%=classifier%>&id=<%=arru(0,i)%>&action=tongguo">通过</a>/<a href="comments.asp?c=<%=classifier%>&id=<%=arru(0,i)%>&action=shanchu">删除</a></td>
						</tr>
						<%
							Next
					  	End If
						%>
                    </table>
					<%
					End If
					%>
					<%
					If classifier = "cash" Then
					%>
					<table id="orders-list" cellspacing="0" cellpadding="0" border="0" class="coupons-table" >
						<tr >
						<th width="400" align="center">评论内容</th>
						<th width="100"> 评论人</th>
						<th width="160">房型</th>
						<th width="200">旅馆</th>
						<th width="200">评论时间</th>
                        <th width="50">审核</th>
						</tr>
						<%
						If IsArray(arrU) Then
							For i = 0 to UBound(arrU, 2)
						%>
						<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td nowrap><%=left(arrU(5,i),20)%></td>
							
							<td nowrap><%=arrU(2,i)%></td>
						   <td nowrap><a href="../../detail.asp?pid=<%=arrU(1,i)%>" target="_blank"><%=arrU(4,i)%></a></td>
							<td nowrap><%=arrU(3,i)%></td>
							<td nowrap><%=arrU(7,i)%></td>
                            <td nowrap><a href="comments.asp?c=<%=classifier%>&id=<%=arru(0,i)%>&action=chongshen">重审</a>/<a href="comments.asp?c=<%=classifier%>&id=<%=arru(0,i)%>&action=shanchu">删除</a></td>
						</tr>
						<%
							Next
					  	End If
						%>
                    </table>
					<%
					End If
					%>
					<%
					'全部评论
					If classifier = "manualrefund"  Then
					%>
					<table id="orders-list" cellspacing="0" cellpadding="0" border="0" class="coupons-table">
						<tr>
					<th width="400">评论内容</th>
						<th width="100"> 评论人</th>
						<th width="160">房型</th>
						<th width="200">旅馆</th>
						<th width="200">评论时间</th>
                        <th width="50">状态</th>
						</tr>
						<%
						If IsArray(arrU) Then
							For i = 0 to UBound(arrU, 2)
						%>
						
						<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td nowrap><%=left(arrU(5,i),20)%></td>
							
							<td nowrap><%=arrU(2,i)%></td>
							<td nowrap><a href="../../detail.asp?pid=<%=arrU(1,i)%>" target="_blank"><%=arrU(4,i)%></a></td>
							<td nowrap><%=arrU(3,i)%></td>
							<td nowrap><%=arrU(7,i)%></td>
                            <td nowrap><%if arru(6,i)="Y" then%>已通过<%else%><a href="comments.asp?c=<%=classifier%>&id=<%=arru(0,i)%>&action=tongguo">通过</a><%end if%>/<a href="comments.asp?c=<%=classifier%>&id=<%=arru(0,i)%>&action=shanchu">删除</a></td>
						</tr>
						<%
							Next
					  	End If
						%>
                    </table>
					<%
					End If
					%>
					
					
					
					<%
					If IsArray(arrU) Then
					%>
					<table width="100%">
					<tr align="right">
						  <td colspan="6" align="right">
						  <%= strPageInfo%>
						  </td>
					  </tr>
					 </table>
					 <%End If%>
				</div>

</div>

<!--#include file="../../common/inc/footer_manage.asp"-->
