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
Dim c,id,totalMoney
Dim classifierName

'reserve �����û�֧���ⷿʱ�Ķ���
'cash  ����Ա��̨�˹�Ϊ����֧���ֽ�

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
				searchStr = " and action='reserve'"
				classifierName = "����"
			Case "cash"
				searchStr = " and action='cash'"
				classifierName = "�ֽ�֧��"
			Case "manualrefund"
				searchStr = " and action='manualrefund'"
				classifierName = "�˹��˿��¼"
		    Case Else
				classifier = "reserve"
				classifierName = "����"
				searchStr = " and action='reserve'"
		End Select
		
		
		'�õ��ܶ�
		Sql = "Select Sum(money)  from T_Fin_Record where 1=1"&searchStr
		Set Rs = Dream3CLS.Exec(Sql)
		totalMoney = Rs(0)

		If not isnumeric(Trim(totalMoney)) then totalMoney=0
		
		sql = "select id,user_id,admin_id,detail_id,order_no,direction, money,action,create_time from T_Fin_Record  where 1=1 "&searchStr
		sql = sql&" Order by create_time Desc"
		sqlCount = "SELECT Count([id]) FROM [T_Fin_Record] where 1=1 "&searchStr


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
			
			'ѭ�����飬��Ѱid����������
			If IsArray(arrU) Then
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
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl"><%=classifierName%></span><span class="fr">&nbsp;</span></div>
    <div class="say">
	�ܽ�<span class="currency"><%=Dream3CLS.SiteConfig("CNYSymbol")%></span><%=totalMoney%>
    </div>
</div>


<div id="box">
                <div class="sect">
				
					<%
					If classifier = "reverse" Then
					%>
					<table id="orders-list" cellspacing="0" cellpadding="0" border="0" class="coupons-table">
						<tr>
						<th width="200">�û�</th>
						<th width="100">����</th>
						<th width="160">���</th>
						<th width="200">����Ա</th>
						<th width="200">���³�ֵʱ��</th>
						</tr>
						<%
						If IsArray(arrU) Then
							For i = 0 to UBound(arrU, 2)
						%>
						<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
							<td nowrap>
							<%=Dream3User.GetUserFromMap(userMap,arrU(1,i))%>
							</td>
							<td nowrap>����<%If CDBL(arrU(6,i)) < 0 Then%>�ۿ�<%Else%>��ֵ<%End If%></td>
							<td nowrap><span class="money"><%=Dream3CLS.SiteConfig("CNYSymbol")%></span><%=arrU(5,i)%></td>
							<td nowrap>
							<%
							If isArray(adminMap.getv(CStr(arrU(2,i)))) Then
							%>
							<%=Dream3User.GetUserFromMap(adminMap,arrU(2,i))%>
							<%
							End If
							%>
							</td>
							<td nowrap><%=Dream3CLS.Formatdate(arrU(7,i),1)%></td>
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
					<table id="orders-list" cellspacing="0" cellpadding="0" border="0" class="coupons-table">
						<tr>
						<th width="200">�û�</th>
						<th width="100">������</th>
						<th width="100">����</th>
						<th width="160">���</th>
						<th width="200">����Ա</th>
						<th width="200">����ʱ��</th>
						</tr>
						<%
						If IsArray(arrU) Then
							For i = 0 to UBound(arrU, 2)
						%>
						<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
							<td nowrap>
							<%=Dream3User.GetUserFromMap(userMap,arrU(1,i))%>
							</td>
							<td nowrap><%=arrU(4,i)%></td>
							<td nowrap>����֧��</td>
							<td nowrap><span class="money"><%=Dream3CLS.SiteConfig("CNYSymbol")%></span><%=arrU(6,i)%></td>
							<td nowrap>
							<%
							If isArray(adminMap.getv(CStr(arrU(2,i)))) Then
							%>
							<%=Dream3User.GetUserFromMap(adminMap,arrU(2,i))%>
							<%
							End If
							%>
							</td>
							<td nowrap><%=Dream3CLS.Formatdate(arrU(8,i),1)%></td>
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
					'�˹��˿��¼
					If classifier = "manualrefund"  Then
					%>
					<table id="orders-list" cellspacing="0" cellpadding="0" border="0" class="coupons-table">
						<tr>
						<th width="200">Email/�û���</th>
						<th width="100">����</th>
						<th width="160">���</th>
						<th width="200">����Ա</th>
						<th width="200">�˿�ʱ��</th>
						</tr>
						<%
						If IsArray(arrU) Then
							For i = 0 to UBound(arrU, 2)
						%>
						
						<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
							<td nowrap>
							<%=Dream3User.GetUserFromMap(userMap,arrU(1,i))%>
							</td>
							<td nowrap>
							�˹��˿�
							</td>
							<td nowrap><span class="money"><%=Dream3CLS.SiteConfig("CNYSymbol")%></span><%=arrU(6,i)%></td>
							<td nowrap>
							<%
							If isArray(adminMap.getv(CStr(arrU(2,i)))) Then
							%>
							<%=Dream3User.GetUserFromMap(adminMap,arrU(2,i))%>
							<%
							End If
							%>
							</td>
							<td nowrap><%=Dream3CLS.Formatdate(arrU(8,i),1)%></td>
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
