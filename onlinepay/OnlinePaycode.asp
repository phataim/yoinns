<%
'���ö���״̬
Public sub SetOrderState(o_order_no,o_pay_type,o_pay_id,o_money)
	Dim o_order_user_id
	Dim o_order_origin
	Dim o_usercredit
	Dim o_order_id
	Dim o_user_deduct
	Set o_rs = Server.CreateObject("Adodb.recordset")
	'���ڶ�����ſ������ڳ��ڵ�������order_id����������Ҫ������
	If Len(Cstr(o_order_no)) > 12 Then
		Sql = "Select * from T_Order Where order_no='"&o_order_no&"'"
	Else
		Sql = "Select * from T_Order Where  id="&cint(o_order_no)
	End If
			
	o_rs.open Sql,conn,1,2
	If o_rs.EOF Then 
		o_rs.close
		Set o_rs = Nothing
		Exit Sub
	End If
	o_state = o_rs("state")
	If o_state = "pay" Then
		o_rs.close
		Set o_rs = Nothing
		Exit Sub
	End If
	o_product_id = o_rs("product_id")
	o_order_id = o_rs("id")
	o_order_user_id = o_rs("user_id")
	o_rs("state") 	= "pay"
	o_rs("service") 	= o_pay_type
	o_rs("pay_time")= Now()
	If o_pay_id <> "" Then
		o_rs("pay_id") 	= o_pay_id
	End If
		
	o_rs.Update
	o_rs.Close
	Set o_rs = Nothing
	
	'����ֽ�֧�������¼��Fin_record
	'�ֽ�֧��Ҳֻ��֧���˻���������
	'���û��ۿ�,����û��˻�Ϊ�գ��򲻽��У�����������û��˻�����۳��û��˻�����
	If o_pay_type = "cash" Then
		Dream3Product.WriteToFinRecord o_order_user_id,Session("_UserID"),o_product_id,o_order_no,"expense","cash",o_money
	Else
		'o_usercredit = Dream3User.getUserMoney(o_order_user_id)
		'o_usercredit = CDBL(o_usercredit)
	
		'If o_usercredit <> 0 Then
			'����˻�����֧����ԭ�ۣ��˴��ж϶��࣬���ǻ����ж�һ��
			'If o_usercredit <= CDBL(o_order_origin) Then
				'o_user_deduct = o_usercredit
			'End If
			'Dream3User.AddOrDeductUserMoney o_order_user_id,-CDBL(o_user_deduct)
		Dream3Product.WriteToFinRecord o_order_user_id,0,o_product_id,o_order_no,"expense","reserve",o_money
			
		'End If
	End If
	
	
	'֧���ɹ������������״̬ΪR(������)
	'Dream3Product.UpdateInviteInfo o_order_user_id,o_product_id,"R"
	'����
	'Dream3Product.UpdateBonus o_order_user_id,o_product_id,o_bonus
	
	'���Ͷ���
	'Call Dream3Product.SendOrderSuccessSMS(o_order_id)
			
End sub


'���ݶ��������²�Ʒ״̬�������������ֱ���ò�Ʒ����
Public Sub UpdateProductState(f_product_id)
	Dim f_order_days
	f_order_days = ""
	sql = "select start_date,end_date from T_Order where state = 'pay' and product_id =" & f_product_id
	Set f_order_rs = Server.CreateObject("adodb.recordset")	
	f_order_rs.Open Sql,Conn,1,2
	Do While Not f_order_rs.EOF
		f_start_date = f_order_rs("start_date")
		f_end_date = f_order_rs("end_date")
		f_days = DateDiff("d", f_start_date, f_end_date) + 1
		
		For f_i = 0 To f_days - 1
			f_order_days = f_order_days & "," & Dream3CLS.Formatdate(DateAdd("d", f_i, f_start_date) , 2)
		Next
		
		f_order_rs.Movenext
	Loop
	f_order_rs.Close
	Set f_order_rs = Nothing
	
	
	If f_order_days <> "" Then
		'�ж��Ƿ���Զ���
		Set productRs = Server.CreateObject("adodb.recordset")			
		Sql = "Select * From T_product Where id="&f_product_id
		productRs.Open Sql,Conn,1,2
	
		productRs("order_days") = f_order_days
		productRs.Update
		productRs.Close
		Set productRs = Nothing
	End If
		
End Sub
%>