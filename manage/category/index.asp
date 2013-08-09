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
		classifier = Request.QueryString("classifier")
		Sql = "Delete From T_Category Where id="&id
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		gMsgArr = "ɾ���ɹ�"
		Call Main()
	End Sub
	
	Sub EnabledRecord()
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		classifier = Request.QueryString("classifier")
		enabled = Request.QueryString("enabled")
		If enabled ="Y" then
			Sql = "Update  T_Category Set enabled='N' Where id="&id
		Else
			Sql = "Update  T_Category Set enabled='Y' Where id="&id
		End If
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		gMsgArr = "���óɹ�"
		Call Main()
	End Sub

	
	Sub Main()		
		
		classifier = Request.QueryString("classifier")
		If classifier <> "express" and  classifier <> "grade" and classifier <> "group"   Then classifier = "grade"
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl & "?classifier="&classifier
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		
		sql = "select id,cname,ename,category,seqno,classifier,enabled from T_Category Where classifier='"&classifier&"' order by seqno desc"
		sqlCount = "SELECT Count([id]) FROM [T_Category] Where classifier='"&classifier&"'"
		
	
			
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
			
		Select Case classifier
			Case "express"
		   		title = "��ݹ�˾"
			Case "group"
		   		title = "�Ź�����"
			Case "grade"
		   		title = "�û��ȼ�"
		    Case Else
				title = "�����б�"
		End Select
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl"><%=title%></span>
        <span class="fr">
        	<a class="ajaxlink" href="categoryEdit.asp?act=showAdd&classifier=<%=classifier%>">�½�<%=title%></a>
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
						<th nowrap="" width="150">��������</th>
						<th nowrap="" width="200">Ӣ������</th>
						<th nowrap="" width="40%">�Զ������</th>
						<th nowrap="" width="60">����</th>
						<th nowrap="" width="60">״̬</th>
						<th nowrap="" width="120">����</th>
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
						<td>
							<%If arrU(6,i)="Y" Then%>
								����
							<%Else%>
								ʧЧ
							<%End If%>
						</td>
						<td align="center">
						<a class="ajaxlink" onclick="return window.confirm('��ȷ��Ҫɾ��������¼?')" href="index.asp?act=delete&classifier=<%=classifier%>&id=<%=arrU(0,i)%>">ɾ��</a>��
						<a class="ajaxlink" href="categoryEdit.asp?act=showEdit&classifier=<%=classifier%>&id=<%=arrU(0,i)%>">�༭</a>
						<%If arrU(5,i)="city" Then%>
						<a class="ajaxlink" href="index.asp?act=enabled&enabled=<%=arrU(6,i)%>&classifier=<%=classifier%>&id=<%=arrU(0,i)%>">
						<%If arrU(6,i)="Y" Then%>
						����
						<%Else%>
						����
						<%End If%>
						</a>
						<%End If%>
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
      
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->