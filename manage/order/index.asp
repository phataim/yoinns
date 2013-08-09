<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../onlinepay/onlinepaycode.asp"-->

<%
Dim Action
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim Sql, sqlCount
Dim rs, searchStr
Dim stateStr
Dim classifier

Dim user_id,product_id

Dim productIdArr()
Dim userIdArr()
Set productMap = new AspMap
Set userMap = new AspMap


	Action = Request.QueryString("act")
	classifier = Dream3CLS.RParam("classifier")
	
	Select Case Action
		Case "cash"
		   	Call SetOrderCash()
		Case "admincancel"
		    Call AdminCancel()
		Case Else
			Call Main()
	End Select

	'Ϊ��������
	'��ʱ������֧���Ľ��Ϊorigin - credit
	Sub SetOrderCash()
		order_no = Dream3CLS.RSQL("orderno")
		Sql = "Select * From T_Order Where order_no='"&order_no&"'"
		

		Set Rs = Server.CreateObject("Adodb.recordset")
		Rs.open Sql,conn,1,2
		s_checkintype = Rs("checkintype")
		s_singleprice = CDBL(Rs("singleprice"))
		s_reserve = CDBL(Rs("reserve"))
		s_user_id = Rs("user_id")
		s_product_id = Rs("product_id")
		s_order_no = Rs("order_no")
		s_state = Rs("state")
		
		If s_state <> "unpay" Then
			'gMsgArr = "��鿴����״̬�Ƿ��Ѹı䣬Ŀǰ�޷������ֽ�֧����"
			'gMsgFlag = "E"
			'Call Main()
			'Exit Sub
		End If

		'Rs("state") = "pay"
		'Rs("pay_time") = now()
		
		'Rs.Update()
		'Rs.Close
		'Set Rs =Nothing
		
		'���ö���״̬
		SetOrderState s_order_no,"cash","",s_reserve
	
		
		gMsgFlag = "S"
		gMsgArr = "�ֽ�֧���ɹ�"
		Call Main()
	End Sub
	
	
	
	'''''''''''''''''''''''��ү��������'''''''''''''''''''''''''''''''''''''''''''''
	Sub AdminCancel()
		orderid = Dream3CLS.RNum("orderid")
		sql = "select * from T_Order where id = " & orderid 
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ��ö�����",0,"0")
			response.End()
		End If
		
		If (Rs("state") <> "unconfirm" and  Rs("state") <> "unpay")  Then
			Call Dream3CLS.MsgBox2("�޷�ȡ���ö�����",0,"0")
			response.End()
		End If
		
		Sql = "Update  T_Order set state = 'admincancel' Where id = " & orderid
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		gMsgArr = "ȡ���ɹ�"
		Call Main()
	End Sub
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	
	
	
	Sub Main()	
	
		user_id = Dream3CLS.RParam("user_id")
		product_id= Dream3CLS.RParam("product_id")
		
		If not IsNumeric(user_id) Then user_id=""
		If not IsNumeric(product_id) Then product_id=""
		 
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl &"?classifier="&classifier&"&user_id="&user_id&"&product_id="&product_id
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		If IsSQLDataBase = 1 Then
			'searchStr = "and Datediff(s,start_time,GetDate())>=0"
		Else
			'searchStr = "and Datediff('s',start_time,Now())>=0"
		End If
		
		classifierStyle = "all"

		Select Case classifier
			Case "unconfirm"
				searchStr = searchStr & " and state='unconfirm'"
			Case "unpay"
				searchStr = searchStr & " and state='unpay'"
			Case "pay"
				searchStr = searchStr & " and state='pay'"
			Case "lodgercancel"
				searchStr = searchStr & " and state='lodgercancel'"
			Case "ownercancel"
				searchStr = searchStr & " and state='ownercancel'"
			Case "failed"
				searchStr = searchStr & " and state='failed'"
			Case "admincancel"
				searchStr = searchStr & " and state='admincancel'"
			
		End Select
		
		If Dream3CLS.ChkNumeric(user_id) <> 0 Then
			searchStr = searchStr & " and user_id="&user_id
		End If
		
		If Dream3CLS.ChkNumeric(product_id) <> 0 Then
			searchStr = searchStr & " and product_id="&product_id
		End If

		
		Sql = "Select id,order_no,product_id,city_code,checkindays,state,roomnum,checkintype,reserve,singleprice,pay_time,create_time,user_id  from T_Order Where 1=1 "&searchStr
		Sql = Sql &" Order By create_time Desc"
		
		sqlCount = "SELECT Count(id) FROM T_Order where 1=1"&searchStr

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
				ReDim Preserve productIdArr(i)
				ReDim Preserve userIdArr(i)
				productIdArr(i) = arrU(2,i)
				userIdArr(i) = arrU(12,i)
			Next
			
			Call Dream3Product.getproductItemMap(productIdArr,productMap)
			Call Dream3Product.getUserMap(userIdArr,userMap)
			
		End If

	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<script type="text/javascript" src="../../common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="../../common/js/jquery/thickbox-compressed.js"></script>
<style type="text/css" media="all">
@import "../../common/static/style/thickbox.css";
</style>

<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl">������ѯ</span>
        <span class="fr">
        	
        </span>
    </div>
    <div class="say">
        <form method="post" action="index.asp?classifier=<%=classifier%>">
					�û���ţ�<input type="text" value="<%=user_id%>" class="h-input" name="user_id">&nbsp;
					��Ŀ��ţ�<input type="text" value="<%=product_id%>" class="h-input number" name="product_id">&nbsp;
					<input type="submit" style="padding: 1px 6px;" class="formbutton" value="ɸѡ">
					</form>
    </div>
</div>

<div id="box">

					
				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" class="coupons-table" id="orders-list">
					<tbody>
					<tr>
					<th width="40">ID</th>
					
					<!--------������Ƿ�ֹ����---------------->
					<th width="160">�ù�</th>
					<th width="120">����</th>
					<th width="140">�û�</th>
					<th>��������</th>
					<th>��ס����</th>
					<th>�ܽ��</th>
					<th>����</th>
					<th>״̬</th>
					<th>����</th>
					</tr>
					
					
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
							s_id = arrU(0,i)
							s_order_no = arrU(1,i)
							s_product_id = arrU(2,i)
							s_city_code = arrU(3,i)
							s_checkindays = arrU(4,i)
							s_state = arrU(5,i)
							s_roomnum = arrU(6,i)
							s_checkintype = arrU(7,i)
							s_royalties = arrU(8,i)
							single_price= cdbl(arrU(9,i))
							s_pay_time = arrU(10,i)
							s_create_time = arrU(11,i)
							s_user_id  = arrU(12,i)
							
							
							s_state_str = ""
							Select Case s_state
								Case "unconfirm"
									s_state_str = "������ȷ��"
								Case "unpay"
									s_state_str = "������"
								Case "pay"
									s_state_str = "�����"
								Case "lodgercancel"
									s_state_str = "����ȡ��"
								Case "ownercancel"
									s_state_str = "����ȡ��"
								Case "refund"
									s_state_str = "���˿�"
								Case "failed"
									s_state_str = "ʧ��"
								Case "admincancel"
								    s_state_str = "����Աȡ��"
							End Select
							
							Select Case s_checkintype
								Case "perDay"	
									s_checkintype_str = "����"
								Case "perWeek"	
									s_checkintype_str = "����"
								Case "perMonth"	
									s_checkintype_str = "����"
							End Select
							
							s_total_price = single_price * s_roomnum * s_checkindays
							
								'xiaoyaohang ����ԭ����getMap�����⡣��ȡ�������ݣ���ʱ��Ϊ���²�ѯ���ݿ⣬�Ժ���������ƿ�����޸�
							Dim houseTitle
							Sql = "Select  *  from  T_Product Where  id ="&s_product_id
							Set titleRs = Dream3CLS.Exec(Sql)
							If Not titleRs.EOF Then
							titleRs.MoveFirst
							houseTitle = titleRs("houseTitle")
							
							'''''�����ǰ�ү��������''''''''''''
							hid=titleRs("hid")
							    sql_hotel="select * from T_hotel where h_id="&hid
							    set hotelRS=Dream3CLS.Exec(sql_hotel)
							    if Not hotelRs.EOF then 
							    	hotelRs.MoveFirst
							    	hotelname=hotelRs("h_hotelname")
							    	h_uid=hotelRs("h_uid")
							    	   user_sql="select * from T_User where id="&h_uid
							         set userRs=Dream3CLS.Exec(user_sql)
							         if Not userRs.EOF then
							         	 userRs.MoveFirst
							         	 mobile=userRs("mobile")
							         end if
							    end if
							    
							End If
							
							s_housetitle = houseTitle
					%>		
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td>
						<%=s_id%>
						</td>
						
						<!--����Ϊ��ү��������-->
						<td><a href="http://www.yoinns.com/show.asp?hid=<%=hid%>" target="_blank"><%=hotelname%></a><br><%=mobile%></td>
						<td><%=s_housetitle%>&nbsp;(<a target="_blank" href="../../detail.asp?pid=<%=s_product_id%>" class="deal-title"><%=s_product_id%></a>)</td>
						<td>
						<a class="ajaxlink" href="../user/userDetail.asp?act=showEdit&pid=<%=s_user_id%>">
						
						<%=Dream3User.GetUserFromMap(userMap,s_user_id)%>
						</a>
						</td>
						<td><%=s_checkintype_str%></td>
						<td><%=s_checkindays%>��</td>   
						<td><%=s_royalties%>Ԫ</td>   <!--ԭ���ı�����<%=s_total_price%>,��ʱû�뵽�취���,ֻ���滻������ı���-----BYũ��-->
						<td><%=s_royalties%>Ԫ</td>
						<td><%=s_state_str%></td>
						
						
						<td nowrap="" class="op">
						<%If s_state = "unpay" then%>
						<a class="ajaxlink" onclick="return window.confirm('ȷ�ϱ�����Ϊ�ֽ𸶿�?')" href="index.asp?act=cash&classifier=<%=classifier%>&orderno=<%=s_order_no%>">�ֽ�</a>|
						<%End If%>
						<a class="ajaxlink" href="orderDetail.asp?id=<%=s_id%>">����</a>
						
						
						
						<!--��ү��������-->
						
						<%
										If  s_state = "unconfirm" Then
						%>
										
						<a href="?act=admincancel&orderid=<%=s_id%>" onclick="return window.confirm('��ȷ��Ҫȡ���ö���?')">ȡ��</a>
			
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
						  <td colspan="10" align="right">
						  <%= strPageInfo%>
						  </td>
					  </tr>
					 <%End If%>
                    </tbody></table>
				</div>
				
           
</div>

<!--#include file="../../common/inc/footer_manage.asp"-->