<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_static.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<%
Dim Action
Dim Rs,Sql


Dim userid,product_id , order_id
Dim username,order_realname,order_email,checkintype_display,checkindays,totalmoney,reserve,order_state
Dim order_status_display,order_create_time,order_mobile , order_payway,service,order_pay_time , order_start_time,order_end_time, remark
Dim htitle,hotelname,hid
Action = Request("act")

Select Case Action
	Case "refund"
		Call Refund()
	Case Else
		Call Main()
End Select

Sub Main()		
	
		order_id = Dream3CLS.ChkNumeric(Request("id"))
		Sql = "Select * From T_Order Where id="&order_id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
			Response.End()
		End If
		
		user_id = Rs("user_id")
		product_id = Rs("product_id")
		orderState= Rs("state")
		totalmoney = CDBL(Rs("totalmoney"))
		checkindays = Rs("checkindays")
		reserve = Rs("reserve")
		order_state = Rs("state")
		order_create_time = Rs("create_time")
		order_start_time=Rs("start_date")
		order_end_time=Rs("end_date")
		order_mobile = Rs("mobile")
		order_email = Rs("email")
		order_realname = Rs("realname")
		order_pay_time = Rs("pay_time")
		service = Rs("service")
		checkintype= Rs("checkintype")
		
		sql = "select * from t_product where id="&product_id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Dream3CLS.showMsg "��Ҫ��ѯ����Ϣ�����ڣ�","S","error.asp"
			Response.End()
		End If
		htitle=Rs("housetitle")
		hid=Rs("hid")
		sql2="select * from T_hotel where h_id="&hid
		Set Rs2 = Dream3CLS.Exec(Sql2)
		If Rs2.EOF Then
			Dream3CLS.showMsg "��Ҫ��ѯ����Ϣ�����ڣ�","S","error.asp"
			Response.End()
		End If
		hotelname=Rs2("h_hotelname")
		
		Set rs2=nothing
		
		Set rs = nothing
		
		Select Case checkintype
			Case "perDay"	
				checkintype_display = "����"
			Case "perWeek"	
				checkintype_display = "����"
			Case "perMonth"	
				checkintype_display = "����"
		End Select
		
		Select Case order_state
			Case "unconfirm"
				order_status_display = "��ȷ��"
			Case "unpay"
				order_status_display = "������"
			Case "pay"
				order_status_display = "�����"
			Case "lodgercancel"
				order_status_display = "����ȡ��"
			Case "ownercancel"
				order_status_display = "����ȡ��"
			Case "failed"
				order_status_display = "ʧ��"
		End Select
		
		Select Case service
			Case "cash"
				order_payway = "�����ֽ�֧��"
			Case "yeepay"
				order_payway = "�ױ�֧��"
			Case "alipay"
				order_payway = "֧����֧��"
			Case "chinabank"
				order_payway = "��������֧��"
			Case "tenpay"
				order_payway = "�Ƹ�֧ͨ��"
			Case Else
				order_payway = "δ����֧��"
		End Select

		
		Set userRs = Dream3Product.GetUserById(user_id)
		username = userRs("username")
		email = userRs("email")
		
		Set productRs = Dream3Product.GetProductById(product_id)
		housetitle = productRs("housetitle")
		
		
		
		
	
		
End Sub

	
	Sub Refund()
		
		refundType = Dream3CLS.RParam("refund")
		
		order_id = Dream3CLS.ChkNumeric(Request("id"))
		If refundType = "" Then 
			gMsgFlag = "E"
			gMsgArr = "��ѡ���˿ʽ"
			Call Main()
			Exit Sub
		End If

		'�˿���˻�
		Sql = "Select * From T_Order Where id="&order_id
		Rs.Open Sql,Conn,1,2
		If Rs("state") <> "pay" then
			gMsgFlag = "E"
			gMsgArr = "ֻ��֧���Ķ��������˿�"
			Call Main()
			Exit Sub
		End If
	
		
		If refundType = "manual" Then
			
			user_id = Rs("user_id")
			product_id = Rs("product_id")
			totalmoney = Rs("totalmoney")
			order_no = Rs("order_No")
			Rs("state") = "refund"
			Rs("pay_time") = null
			Rs.Update
			Rs.Close
			Set Rs = Nothing
			Dream3Product.WriteToFinRecord user_id,Session("_UserID"),product_id,order_no,"income","manualrefund",totalmoney
			'����־
			
		End If
		
		
		gMsgFlag = "S"
		gMsgArr = "�˿�ɹ�"
		Call Main()
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="../../common/js/tools.js"></script>

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">��������</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">

					
				<div class="sect">
					<table align="center" width="96%" class="coupons-table">
		<tbody>
		
		<tr><td><b>������⣺</b></td><td ><a href="<%=VirtualPath%>/detail.asp?pid=<%=product_id%>" target=_blank><%=htitle%></a></td>
		    <td><b>�����Ƶ꣺</b></td><td><a href="<%=VirtualPath%>/show.asp?hid=<%=hid%>" target="_blank"><%=hotelname%></a></td></tr>
		<tr>
			<td><b>�������ͣ�</b></td><td><%=checkintype_display%></td>
			<td><b>��ס������</b></td><td><%=checkindays%>��</td>
		</tr>
		<tr>
			<td><b>�ܽ�</b></td><td><%=totalmoney%></td>
			<td><b>����</b></td><td><%=reserve%>Ԫ</td>
		</tr>
		<tr>
			<td><b>����״̬��</b></td><td><font color="red"><%=order_status_display%></font></td>
			<td><b></b></td><td></td>
		</tr>
		<%If order_state="pay" Then%>
		<tr>
		<td><b>������ϸ��</b></td>
		<td colspan="3"><%=order_payway%><font color="red"><b><%=totalmoney%></b></font> Ԫ&nbsp;</td>
		</tr>
		<%End If%>
		<tr>
			<td><b>����ʱ�䣺</b></td><td><%=order_create_time%></td>
			<td><b>֧��ʱ�䣺</b></td><td><%=order_pay_time%></td>
			
			<!--��������Ϊ��ү����-->
			<br>
			
		</tr>
		<TR>
			<td><b></BR>��ס���ڣ�</b></td><td><%=order_start_time%></td>
			<td><b>�˷����ڣ�</b></td><td><%=order_end_time%></td>	
		</TR>

		
		<tr>
		<th colspan="4"><hr></th>
		</tr>
		<tr>
			<td width="15%"><b>�û�����</b></td><td><%=order_realname%></td>
			<td width="15%"><b>Email��</b></td><td><%=order_email%></td>
		</tr>
		<tr><td><b>�ֻ����룺</b></td><td><%=order_mobile%> </td></tr>
		
		<tr><td><b>�������ԣ�</b></td><td><%=remark%></td></tr>
		
		<%If order_state="pay" Then%>
		
		<form method="post" action="orderDetail.asp">
		<tr><th colspan="4"><hr></th>
		</tr><tr><td><b>�˿��</b></td><td>
		<select id="order-dialog-refund-id" name="refund">
			<option selected="" value="">��ѡ���˿ʽ</option>
			<option value="manual">ͨ���˹���ʽ���˿�</option>
		</select>&nbsp;
		
		<input type="hidden" name="act" value="refund"/>
		<input type="hidden" name="id" value="<%=order_id%>"/>
		
		<input type="submit" value="ȷ��"></td></tr>
		</form>
		<%End If%>
	</tbody></table>
		</div>
				

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->