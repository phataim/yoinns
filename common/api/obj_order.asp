<%
Rem ************************************************
Rem ** ����: Dream3.cn
Rem ** Dream3.cn ������
Rem ************************************************
Class Obj_Order
	Public houseTitle
	Public productId
	Public orderId
	Public orderNo
	Public orderCreateTime
	Public orderPayTime
	Public orderState
	Public orderStateDisplay
	Public ordercheckinDays
	Public ordercheckinType
	Public ordercheckinTypeDisplay
	Public orderTotalMoney
	Public orderRoomNum
	Public orderSinglePrice
	Public orderReserve
	Public orderRemark
	Public orderService
	Public orderPayId
	Public orderstartDate
	Public orderPaywayDisplay
	Public orderendDate
	Public userEmail
	Public userRealName
	Public userMobile
    Public hotelname
    Public hid
    Public hoteladdress
    Public hotelline
	Private sobjConn
	Private sbooInitState


	Private Sub Class_Initialize
		Call ClearVars()
	End Sub

	Private Sub class_terminate()
		Set sobjConn = nothing
	End Sub

	Public Sub ClearVars()
		sOrderNo = ""
		sOrderId = ""
	End Sub

	Private Sub ClearMainVars()
		'sstrSql = ""
	End Sub

	Rem ## SQL���
	Public Property Let inOrderId(Value)
		orderId = Value
	End Property
	
	Rem ## ���ݿ����Ӷ���
	Public Property Let objConn(Value)
		Set sobjConn = Value
	End Property

	Rem ## ȡ�ü�¼��, ��ά������ִ�, �ڽ���ѭ�����ʱ������ IsArray() �ж�
	Public Property Get orderResult()
		Call InitClass()
		If Not sbooInitState Then
			Response.Write("��ҳ���ʼ��ʧ��, ������������")
			Exit Property
		End If

		Dim rs, sql
		sql = "select * from T_Order Where id="&orderId

		Set rs = Server.CreateObject("Adodb.RecordSet")

		rs.open sql, sobjConn, 1, 1
		orderNo = rs("order_no")
		orderRemark = Rs("remark")
		
		
		productId  = Rs("product_id")
		orderCreateTime = Rs("create_time")
		orderPayTime  = Rs("pay_time")
		orderState  = Rs("state")
		orderReserve= Rs("reserve")
		orderRoomNum= Rs("roomnum")
		ordercheckinDays =  Rs("checkindays")
		ordercheckinType =  Rs("checkinType")
		orderService = Rs("service")								
		orderTotalMoney=  Rs("totalmoney")
		orderSinglePrice=  Rs("singleprice")
		orderTotalMoney =  Rs("TotalMoney")
		orderService =  Rs("service")
		orderPayId =  Rs("pay_id")
		orderstartDate =  Rs("start_Date")
		orderendDate =  Rs("end_Date")
		
		userEmail =  Rs("email")
		userRealName =  Rs("realname")
		userMobile =  Rs("mobile")
	
		rs.close

		
		Select Case orderState
			Case "unconfirm"
				orderStateDisplay = "��ȷ��"
			Case "unpay"
				orderStateDisplay = "������"
			Case "pay"
				orderStateDisplay = "�����"
			Case "lodgercancel"
				orderStateDisplay = "����ȡ��"
			Case "ownercancel"
				orderStateDisplay = "����ȡ��"
			Case "refund"
				orderStateDisplay = "���˿�"
			Case "failed"
				orderStateDisplay = "ʧ��"
		End Select
		
		Select Case ordercheckinType
			Case "perMonth"	
				ordercheckinTypeDisplay = "����"
			Case Else
				ordercheckinTypeDisplay = "����"
		End Select
		
		
		Select Case orderservice
			Case "cash"
				orderPaywayDisplay = "�����ֽ�֧��"
			Case "yeepay"
				orderPaywayDisplay = "�ױ�֧��"
			Case "alipay"
				orderPaywayDisplay = "֧����֧��"
			Case "chinabank"
				orderPaywayDisplay = "��������֧��"
			Case "tenpay"
				orderPaywayDisplay = "�Ƹ�֧ͨ��"
			Case Else
				orderPaywayDisplay = "δ����֧��"
		End Select
		
		sql = "select * from t_product where id="&productId
		rs.open sql, sobjConn, 1, 1
		houseTitle = Rs("housetitle")
		hid=Rs("hid")
		hid=Rs("hid")
		sql2="select * from T_hotel where h_id="&hid
		Set Rs2 = Dream3CLS.Exec(Sql2)
		If Rs2.EOF Then
			Dream3CLS.showMsg "��Ҫ��ѯ����Ϣ�����ڣ�","S","error.asp"
			Response.End()
		End If
		hotelname=Rs2("h_hotelname")
		hoteladdress=Rs2("h_address")
		hotelline=Rs2("h_line")
		rs2.close
		Set rs2=nothing
		rs.close
		Set rs = nothing
		
		orderResult = 0
		
		Call ClearMainVars()
	End Property

	Rem ## ���ʼ��
	Public Sub InitClass()
		sbooInitState = True
		If Not(IsObject(sobjConn)) Then
			sbooInitState = False

			response.write("���ݿ�����δָ��")
			response.End()
		End If
	
	End Sub
	
	'��ȡ������ʷ
	Public Function GetOrderTrans(f_order_id)
		f_sql = "select * from T_Trans where order_id="&f_order_id & " Order By id desc"
		Set GetOrderTrans = Dream3CLS.Exec(f_sql)
    End Function
	

End Class
%>