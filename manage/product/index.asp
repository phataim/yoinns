<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_static.asp"-->
<!--#include file="../../onlinepay/onlinepaycode.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim classifier, searchStr,productState,pid
Dim cityMap,userMap
Dim housetitle,city_code,lodgeType,leaseType,userId,online

Dim cityComboItem,lodgeTypeComboItem,leaseTypeComboItem

Dim s ,curpagestr , curparam,s_hid,hid

Dim userIdArr() ,cityCodeArr()
Set userMap = new AspMap
Set cityMap = new AspMap

Action = Request.QueryString("act")

	Select Case Action
		Case "batchEnabled"
			Call BatchEnabledRecord()
		Case "singleEnabled"
			Call SingleEnabled()
		Case "batchRecommend"
			Call BatchRecommend()
		Case "singlerecommend"
			Call SingleRecommend()
		Case "batchAudit"
			Call BatchAuditRecord()
		Case "delete"
			Call DeleteRecord()
		Case "deleteBatch"
			Call DeleteBatchRecord()
		Case Else
			Call Main()
	End Select
	
	
	Sub EnabledSingleRecord(s_id,s_enabled)
		sql = "Update T_Product Set enabled='"&s_enabled&"' Where id="&s_id
		Dream3CLS.Exec(sql)
	End Sub
	
	Sub SingleEnabled()
		pid = Dream3CLS.RParam("pid")
		classifier = Dream3CLS.RParam("classifier")
		enabled =  Dream3CLS.RParam("p_enabled")

		EnabledSingleRecord pid,enabled
		
		gMsgArr = "����״̬�ɹ���"
		gMsgFlag = "S"
		Call Main()
		
	End Sub
	
	Sub BatchEnabledRecord()
		ids = Dream3CLS.RParam("chkId")
		to_enabled = Dream3CLS.RParam("to_enabled")
		classifier = Dream3CLS.RParam("classifier")
		If to_enabled = "" Then
			gMsgArr = "��ѡ��Ҫ���õ�״̬��"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If ids = "" Then
			gMsgArr = "��ѡ��Ҫ���õļ�¼��"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		If ids <> "" Then
			arr = Split(ids,",")

			For i = 0 To UBound(arr)
				EnabledSingleRecord arr(i),to_enabled 
			Next
		End If
		gMsgArr = "����״̬�ɹ���"
		gMsgFlag = "S"

		Call Main()
		
	End Sub
	
	
	Sub BatchRecommend()
		ids = Dream3CLS.RParam("chkId")
		classifier = Dream3CLS.RParam("classifier")
		
		If ids = "" Then
			gMsgArr = "��ѡ��Ҫ���õļ�¼��"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		If ids <> "" Then
			arr = Split(ids,",")

			For i = 0 To UBound(arr)
				RecommendSingleRecord arr(i)
			Next
		End If
		gMsgArr = "�����Ƽ�״̬�ɹ���"
		gMsgFlag = "S"
		Call Main()
		
	End Sub
	
	Sub SingleRecommend()
		pid = Dream3CLS.RParam("pid")
		classifier = Dream3CLS.RParam("classifier")

		RecommendSingleRecord pid
		
		gMsgArr = "�����Ƽ�״̬�ɹ���"
		gMsgFlag = "S"
		Call Main()
		
	End Sub
	
	
	Sub RecommendSingleRecord(s_id)
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "Select *  from T_Product  Where id="&s_id

		Set Rs = Server.CreateObject("Adodb.recordset")
		Rs.Open sql,conn,1,2
		recommend = "Y"
		If Not IsNull(Rs("recommend")) and Rs("recommend") = "Y" Then 
			recommend = "N"
		End If
		Rs("recommend") = recommend
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
	End Sub
	
	Sub BatchAuditRecord()
		ids = Dream3CLS.RParam("chkId")
		to_state = Dream3CLS.RParam("to_state")
		classifier = Dream3CLS.RParam("classifier")
		
		If to_state = "" Then
			gMsgArr = "��ѡ��Ҫ���õ�״̬��"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If ids = "" Then
			gMsgArr = "��ѡ��Ҫ���õļ�¼��"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		If ids <> "" Then
			arr = Split(ids,",")

			For i = 0 To UBound(arr)
				AuditSingleRecord arr(i) , to_state
			Next
		End If
		gMsgArr = "�������״̬�ɹ���"
		gMsgFlag = "S"
		Call Main()
		
	End Sub
	
	
	Sub AuditSingleRecord(s_id,s_state)
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "Select *  from T_Product  Where id="&s_id& " and state='auditing'"

		Set Rs = Server.CreateObject("Adodb.recordset")
		Rs.Open sql,conn,1,2
		'��������ͨ����������Ĭ��Ϊ����״̬
		If s_state = "normal" Then
			Rs("online") = "Y"
		End If
		Rs("state") = s_state
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		
	End Sub

	Sub DeleteRecord()
		id = Dream3CLS.ChkNumeric(Request("id"))
		DeleteSingleRecord(id)
		gMsgArr = "ɾ���ɹ���"
		gMsgFlag = "S"
		Call Main()
		
	End Sub
	
	Sub DeleteSingleRecord(s_id)
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "Update  T_Product set state = 'delete' Where id="&s_id
		Dream3CLS.Exec(sql)
	End Sub
	
	Sub DeleteBatchRecord()
		ids = Dream3CLS.RParam("chkId")
		If ids = "" Then
			gMsgArr = "��ѡ��Ҫɾ���ļ�¼��"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		If ids <> "" Then
			arr = Split(ids,",")

			For i = 0 To UBound(arr)
				DeleteSingleRecord(arr(i))
			Next
		End If
		gMsgArr = "ɾ���ɹ���"
		gMsgFlag = "S"
		Call Main()
		
	End Sub
	

	
	Sub Main()		
	
		
		'����
		'Dream3Quartz.InvokeTeamState()		
		classifier = Dream3CLS.RParam("classifier")
		userId = Dream3CLS.RParam("userId")
		city_code = Dream3CLS.RParam("city_code")
		lodgeType  = Dream3CLS.RParam("lodgeType")
		leaseType  = Dream3CLS.RParam("leaseType")
		housetitle = Dream3CLS.RParam("housetitle")
		online = Dream3CLS.RParam("online")
		hid=Dream3CLS.RParam("hid")
		
		Select Case classifier
			Case "pending"
				productState = "pending"
			Case "normal"
				productState = "normal"
			Case "auditing"
				productState = "auditing"
			Case "unpass"
				productState = "unpass"
			Case "delete"
				productState = "delete"
			Case else
				productState = "auditing"
				
		End Select
		
		cityComboItem = Dream3Product.GetCityCombo(city_code)
		lodgeTypeComboItem = Dream3Static.GetLodgeTypeCombo(lodgeType)
		leaseTypeComboItem = Dream3Static.GetLeaseTypeCombo(leaseType)
		
		intPageNow = request.QueryString("page")
		
		curparam = "classifier="&classifier&"&hid="&hid&"&userId="&userId&"&housetitle="&housetitle&"&online="&online
		curpagestr = curparam & "&page="&intPageNow

		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl & "?"&curparam
		


		intPageSize = 10
		
		
		If productState <> ""  Then
			searchStr = searchStr & " and state = '"&productState&"'"
		End If
		
		If hid <> ""  Then
			searchStr = searchStr & " and  hid = '"&hid&"'"
		End If
		
		
		If housetitle <> ""  Then
			searchStr = searchStr & " and housetitle like '%"&housetitle&"%'"
		End If
		
		If userId <> ""  Then
			searchStr = searchStr & " and user_id = "&userId
		End If
		
		If online <> ""  Then
			searchStr = searchStr & " and online = '"&online&"'"
		End If
		
		If city_code <> ""  Then
			If Right(city_code,4) = "0000" Then
				searchStr = searchStr& " and city_code like '"&Left(city_code,2)&"%'"
			Else
				searchStr = searchStr& " and city_code like  '"&Left(city_code,4)&"%'"
			End If
		End If
		

		
		sql = "select  id,state,housetitle,lodgetype,leasetype,roomtitle,image,create_time,address,dayrentprice,weekrentprice,monthrentprice,user_id,city_code,recommend,enabled,online,hid from T_Product Where 1=1 "&searchStr
		Sql = Sql &" Order by id desc"
		
		sqlCount = "SELECT Count([id]) FROM [T_Product] where 1=1"&searchStr

		
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
				ReDim Preserve cityCodeArr(i)
				userIdArr(i) = arrU(12,i)
				cityCodeArr(i) = arrU(13,i)
			Next
			
			Call Dream3Product.getUserMap(userIdArr,userMap)
			Call Dream3Product.getCityMap(cityCodeArr,cityMap)
			
		End If
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<script type="text/javascript" src="<%=VirtualPath%>/common/js/tools.js"></script>
<script type="text/javascript" src="<%=VirtualPath%>/common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="<%=VirtualPath%>/common/js/calendar.js"></script>

<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl">��ǰ��Դ</span>
        <span class="fr">
        	
        </span>
    </div>
    <div class="say">
        
			<form method="post" action="index.asp?classifier=<%=classifier%>">
			�û�ID��<input type="text" class="h-input" size="5" name="userId" value="<%=userId%>" >&nbsp;
			���⣺<input type="text" class="h-input" size="15" name="roomtitle" value="<%=roomtitle%>" >&nbsp;
			�Ƶ����ƣ�
			<select style="width: 100px;"  name="hid">
			<option value="" >ȫ��</option>
			<%
			Sql = "Select * from T_hotel"
			Set Rs = Dream3CLS.Exec(Sql)
			do while not Rs.EOF
			%>
			<option value ="<%=Rs("h_id")%>"><%=Rs("h_hotelname")%></option>
			<%
			Rs.movenext
			loop
			Rs.close
			%>
			</select>
			���ߣ�
			<select style="width: 70px;"  name="online">
			<option value="" >ȫ��</option>
			<option value="Y" <%If online = "Y" Then%>selected<%End If%>>��</option>
			<option value="N" <%If online = "N" Then%>selected<%End If%>>��</option>
			</select>
			
			<input type="submit" value="ɸѡ" class="formbutton"  style="padding:1px 6px;"/>
			<form>
    </div>
</div>


<div id="box">

				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" id="orders-list" class="coupons-table">
					<tbody>
					<tr>
					<th width="20"></th>
					<th width="40">ID</th>
					<th width="100" nowrap="">��&nbsp;&nbsp;��</th>
					
					<th width="120" nowrap="">�����Ƶ�</th>
					<th nowrap="" width="80">������</th>
					<th nowrap="" width="60">״̬</th>
					<th nowrap="" width="60">�Ƿ�����</th>
					<th nowrap="" width="60">�Ƽ�</th>
					<th nowrap="" width="60">����</th>
					<th width="140">����</th></tr>
					
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
							s_id = arrU(0,i)
							s_house_title = arrU(2,i)
							s_state =  arrU(1,i)
							s_hid =  arrU(17,i)
							statestr = arrU(1,i)
							If statestr = "pending" Then
								statestr = "������"
							Elseif  statestr = "normal" Then
								statestr = "�����"
							Elseif  statestr = "auditing" Then
								statestr = "�����"
							Elseif  statestr = "unpass" Then
								statestr = "δͨ��"
							Elseif  statestr = "delete" Then
								statestr = "��ɾ��"
							Else
								statestr = "δ����"
							End If
							s_lodgeType = arrU(3,i)
							s_leasetype = arrU(4,i)
							s_lodgeType = Dream3Static.GetLodgeType(s_lodgeType)
							s_leasetype = Dream3Static.GetLeaseType(s_leaseType)
							
							image = arrU(6,i)
							If image <> "" Then image = "../../"&image
							createTime = Dream3CLS.Formatdate(arrU(7,i),2)
							address = arrU(8,i)
							dayrentprice  = arrU(9,i)
							If dayrentprice = 0 Then dayrentprice = "δ����"
							weekrentprice = arrU(10,i)
							If weekrentprice = 0 Then dayrentprice = "δ����"
							monthrentprice = arrU(11,i)
							If monthrentprice = 0 Then dayrentprice = "δ����"
							s_user_id = arrU(12,i)
							s_city_code = arrU(13,i)

							If IsArray(cityMap.getv(s_city_code)) Then
								s_city_name = cityMap.getv(s_city_code)(0)
							Else
								s_city_name  = "�õ����Ѳ����ڱ��("&s_city_code&")"
							End If
							s_recommend = arrU(14,i)
							If s_recommend = "Y" Then
								s_recommend_str = "��"
							Else
								s_recommend_str = "��"
							End If
							s_enabled = arrU(15,i)
							If s_enabled = "Y" Then
								s_enabled_str = "��"
							Else
								s_enabled = "N"
								s_enabled_str = "��"
							End If
							s_online = arrU(16,i)
							If s_online = "Y" Then
								s_online_str = "��"
							Else
								s_online_str = "��"
							End If
					
					%>		
					  <tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td><input type="checkbox" name="chkId" value="<%=s_id%>"/></td>
                        <td>
						<a class="ajaxlink" href="view.asp?pid=<%=s_id%>" target="_blank"><%=s_id%></a>
						</td>
				        <td><%=s_house_title%></td>
						<%
						Sqls = "Select * from T_hotel where h_id="&s_hid
						Set Rss = Dream3CLS.Exec(Sqls)
						%>
						<td><%=Rss("h_hotelname")%></td>
					    <td nowrap="nowrap">
						<%=Dream3User.GetUserFromMap(userMap,s_user_id)%>
						</td>
					    <td><%=statestr%></td>
						<td>
						
						<%
						if classifier = "normal" Then
							If s_enabled = "Y" Then
								s_to_enabled = "N"
							else
								s_to_enabled = "Y"
							End If
						%>
							<a class="ajaxlink" href="?act=singleEnabled&<%=curpagestr%>&p_enabled=<%=s_to_enabled%>&pid=<%=s_id%>" onClick="return confirm('ȷ��Ҫ����ѡ�м�¼������״̬��')"><%=s_enabled_str%></a>
						<%Else%>
							<%=s_enabled_str%>
						<%End If%>
						</td>
						<td>
						<%if classifier = "normal" Then%>
							<a class="ajaxlink" href="?act=singlerecommend&<%=curpagestr%>&pid=<%=s_id%>" onClick="return confirm('ȷ��Ҫ����ѡ�м�¼���Ƽ�״̬��')"><%=s_recommend_str%></a>
						<%Else%>
							<%=s_recommend_str%>
						<%End If%>
						</td>
						<td><%=s_online_str%></td>
					    <td nowrap="nowrap" class="op">
	
						<!--<a class="ajaxlink" href="<%=VirtualPath%>/pstep1.asp?act=showedit&pid=<%=s_id%>" target="_blank" onClick="return confirm('�޸�����˹��Ķ�������Ҫ������� ,��δ������ɵĶ�����ʧЧ\nȷ��Ҫ�޸�?')">�༭</a>-->
						<a class="ajaxlink" href="<%=VirtualPath%>/preview2.asp?pid=<%=s_id%>" target="_blank">���</a>
						</td>
				      </tr>
					<%
						Next
					  End If
					  %>
					<%If IsArray(arrU) Then%>
					<tr>
					  <td colspan="17" align="right">
					  <%= strPageInfo%>
					  </td>
				  	</tr>
				  	<%End If%>
					<tr>	
						  <td colspan="11" style="padding-left:20px;" >
						  <table>
						  <tr><td>
	ȫѡ<input type="checkbox" name="chkall" id="chkall" class="checkbox" onClick="CheckAll(this.form)" />
	
							<%
							If classifier = "auditing" Then
							%>
							�������״̬��
							<select style="width: 160px;"  name="to_state">
								<option value="" >--��ѡ��--</option>
								<option value="normal" >��ͨ��</option>
								<option value="unpass" >δͨ��</option>
							</select>
							<input type="submit" value="����" onClick="if(confirm('ȷ��Ҫ����ѡ�м�¼��״̬��')){form.action='?classifier=<%=classifier%>&act=batchAudit<%=s_param%>';}else{return false}" class="btn" />
							
							<%
							Elseif classifier = "pending" Then
							%>
							<input type="submit" value="ɾ��" onClick="if(confirm('ȷ��Ҫɾ��ѡ�м�¼��')){form.action='?classifier=<%=classifier%>&act=deleteBatch<%=s_param%>';}else{return false}" class="btn" />
							<%
							Elseif classifier = "unpass" Then
							%>
							<input type="submit" value="ɾ��" onClick="if(confirm('ȷ��Ҫɾ��ѡ�м�¼��')){form.action='?classifier=<%=classifier%>&act=deleteBatch<%=s_param%>';}else{return false}" class="btn" />
							&nbsp;
							����״̬��
							<select style="width: 160px;"  name="to_state">
								<option value="" >--��ѡ��--</option>
								<option value="normal" >��ͨ��</option>
								<option value="unpass" >������</option>
							</select>
							<input type="submit" value="����" onClick="if(confirm('ȷ��Ҫ����ѡ�м�¼��״̬��')){form.action='?classifier=<%=classifier%>&act=batchAudit<%=s_param%>';}else{return false}" class="btn" />

							<%
							Elseif classifier = "normal" Then
							%>
							<input type="submit" value="����Ϊ�Ƽ�" onClick="if(confirm('ȷ��Ҫ����ѡ�м�¼���Ƽ�״̬��(������Ƽ��Ļ�ȡ���Ƽ�)')){form.action='?classifier=<%=classifier%>&act=batchRecommend<%=s_param%>';}else{return false}" class="btn" />
							&nbsp;
							��������״̬��
							<select style="width: 160px;"  name="to_enabled">
								<option value="" >--��ѡ��--</option>
								<option value="Y" >����</option>
								<option value="N" >����</option>
							</select>
							<input type="submit" value="����" onClick="if(confirm('ȷ��Ҫ����ѡ�м�¼��״̬��')){form.action='?classifier=<%=classifier%>&act=batchEnabled<%=s_param%>';}else{return false}" class="btn" />
							<%
							End If
							%>
							
							
							
							</td> </tr>
							</table>
							</td>
						</tr>	
                    </tbody>
					</table>
				</div>
				
            
</div>
<%
'clear map
%>
<!--#include file="../../common/inc/footer_manage.asp"-->