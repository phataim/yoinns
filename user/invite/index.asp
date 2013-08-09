<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_user.asp"-->
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
Dim searchStr
Dim teamIdArr()
Dim str1,classifier,stateStr
Dim userIdArr()

Set userMap = new AspMap
	
	Action = Request.QueryString("act")
	Select Case Action
		Case Else
			Call Main()
	End Select

	Sub Main()		
	
		str1=GetSiteUrl()
		
		classifier = Dream3CLS.RParam("c")
		
		Select Case classifier
			Case "pending"
				stateStr = "N"
			Case "done"
				stateStr = "Y"
			Case Else
				stateStr = ""
				classifier = "all"
		End Select
		
		searchStr = " and user_id ="&session("_UserID")
		If stateStr <> "" Then
			searchStr = searchStr&" and state='"&stateStr&"'"
		End If

		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl & "?c="&classifier
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		sql = "select id,user_id,admin_id,other_user_id,team_id,[credit],buy_time,create_time,state from T_Invite  where 1=1 "&searchStr

		sqlCount = "SELECT Count(id) FROM [T_Invite] where 1=1 "&searchStr
		

	
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
					ReDim Preserve userIdArr(i)
					userIdArr(i) = arrU(3,i)
				Next
				
				Call Dream3Team.getUserMap(userIdArr,userMap)
				
			End If
			
	End Sub
	
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript">
function copyToClipboard(txt) 
{ 
window.clipboardData.setData('text', txt); 
alert("���Ƴɹ�������ͨ�� MSN �� QQ ���͸�������");
} 
</script>
<div id="box">	
	<div class="cf">		
		<div id="credit">
			<div class="login-box" id="content">
					
					<!--#include file="../inc/menu.asp"-->
					
					<div class="login-content">
						<div class="head">
					<h2>�ҵ�����</h2>
					<ul class="filter">
						<li class="label">����: </li>
						<li <%If classifier="all" Then response.Write("class='current'")%>>
						<a href="index.asp?c=all">����</a>
						<span></span>
						</li>
						<li <%If classifier="pending" Then response.Write("class='current'")%>>
						<a href="index.asp?c=pending">δ����</a>
						<span></span></li>
						<li <%If classifier="done" Then response.Write("class='current'")%>>
						<a href="index.asp?c=done">�ѷ���</a>
						<span></span></li>					
					</ul>
				</div>
                <div class="sect">
					<div class="share-list">
						<div class="blk im">
							<div class="logo"><img src="<%=VirtualPath%>/common/themes/<%=SiteConfig("DefaultSiteStyle")%>/css/img/logo_qq.gif" /></div>
							<div class="info">
								<h4>��������ר���������ӣ���ͨ�� MSN �� QQ ���͸����ѣ�</h4>
								<input id="share-copy-text" type="text" value="<%=str1%>/invite.asp?code=<%=session("_UserID")%>" size="55" class="f-input" onfocus="this.select()" />
								<input id="share-copy-button" type="button" value="����" class="formbutton" onclick="copyToClipboard(document.getElementById('share-copy-text').value)" />
							</div>
						</div>
					</div>
 
					<table cellspacing="0" cellpadding="0" border="0" class="coupons-table">
					<tr>
						<th width="200">�û�</th>
						<th width="200">����ʱ��</th>
						<th width="200">״̬</th>
					</tr>
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
					%>	
					<tr>
						<td>
						<%
						If IsArray(userMap.getv(CStr(arrU(3,i)))) Then
							Response.Write(userMap.getv(CStr(arrU(3,i)))(0))
						End If
						%>
						</td>
						<td><%=Dream3CLS.Formatdate(arrU(7,i),4)%></td>
						<td>
						<%
						buytime = arrU(6,i)
						createTime = arrU(7,i)
						Select Case arrU(8,i)
							Case "Y"
								iState = "�ѷ���"
							Case "R"
								iState = "������"	
							Case "C"
								iState = "���δͨ��"
							Case "N"
								intSec = DateDiff("s",createTime,Now())
								If intSec > 60*60*24*7 Then
									iState = "�ѹ���"
								Else
									iState = "δ����"
								End if
							Case Else
								stateStr = "δ����"
						End Select
						%>
						<%=iState%>
						</td>
					</tr>
					<%
						Next
					End If
					%>
					<%If IsArray(arrU) Then%>
					<tr>
					  <td colspan="3" align="right">
					  <%= strPageInfo%>
					  </td>
					</tr>
					<%End If%>
					</table>
				</div>
            </div>
            <div class="login-bottom"></div>
			</div>
			<div id="sidebar" style="margin-top:28px;">
				<div class="sbox">
					<div class="sbox-top"></div>
					<div class="sbox-content">
						<div class="side-tip">
							<h3 class="first">��ͬ��״̬����ʲô��˼��</h3>
							<ul class="invalid">
								<li>δ���������������ע�ᣬ���Ǻ�����δ�μӹ��Ź�</li>
								<li>�ѷ�������ϲ���Ѿ���������Ԫ��</li>
								<li>���������������Ź��������� 24 Сʱ�ڷ��������Ժ�</li>
								<li>���δͨ������Ϊ�ֻ����ظ���ԭ����Ϊ��Ч����</li>
				
								<li>�ѹ��ڣ����� 7 ����δ�μ��Ź������������</li>
							</ul>
							<h3>�Լ������Լ�Ҳ�ܻ�÷�����</h3>
							<p>�����ԡ����ǻ��˹��˲飬���ڲ�ʵ��������Ϊ�������������Ϊ�����δͨ������</p>
						</div>
					</div>
					<div class="sbox-bottom"></div>
				</div>
			</div>
		</div>
	</div>	
</div>
<!--#include file="../../common/inc/footer_user.asp"-->