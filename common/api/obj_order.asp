<%
Rem ************************************************
Rem ** 作者: Dream3.cn
Rem ** Dream3.cn 订单类
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

	Rem ## SQL语句
	Public Property Let inOrderId(Value)
		orderId = Value
	End Property
	
	Rem ## 数据库连接对象
	Public Property Let objConn(Value)
		Set sobjConn = Value
	End Property

	Rem ## 取得记录集, 二维数组或字串, 在进行循环输出时必须用 IsArray() 判断
	Public Property Get orderResult()
		Call InitClass()
		If Not sbooInitState Then
			Response.Write("分页类初始化失败, 请检查各参数情况")
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
				orderStateDisplay = "待确认"
			Case "unpay"
				orderStateDisplay = "待付款"
			Case "pay"
				orderStateDisplay = "已完成"
			Case "lodgercancel"
				orderStateDisplay = "房客取消"
			Case "ownercancel"
				orderStateDisplay = "房东取消"
			Case "refund"
				orderStateDisplay = "已退款"
			Case "failed"
				orderStateDisplay = "失败"
		End Select
		
		Select Case ordercheckinType
			Case "perMonth"	
				ordercheckinTypeDisplay = "月租"
			Case Else
				ordercheckinTypeDisplay = "日租"
		End Select
		
		
		Select Case orderservice
			Case "cash"
				orderPaywayDisplay = "线下现金支付"
			Case "yeepay"
				orderPaywayDisplay = "易宝支付"
			Case "alipay"
				orderPaywayDisplay = "支付宝支付"
			Case "chinabank"
				orderPaywayDisplay = "网银在线支付"
			Case "tenpay"
				orderPaywayDisplay = "财付通支付"
			Case Else
				orderPaywayDisplay = "未定义支付"
		End Select
		
		sql = "select * from t_product where id="&productId
		rs.open sql, sobjConn, 1, 1
		houseTitle = Rs("housetitle")
		hid=Rs("hid")
		hid=Rs("hid")
		sql2="select * from T_hotel where h_id="&hid
		Set Rs2 = Dream3CLS.Exec(Sql2)
		If Rs2.EOF Then
			Dream3CLS.showMsg "您要查询的信息不存在！","S","error.asp"
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

	Rem ## 类初始化
	Public Sub InitClass()
		sbooInitState = True
		If Not(IsObject(sobjConn)) Then
			sbooInitState = False

			response.write("数据库连接未指定")
			response.End()
		End If
	
	End Sub
	
	'获取订单历史
	Public Function GetOrderTrans(f_order_id)
		f_sql = "select * from T_Trans where order_id="&f_order_id & " Order By id desc"
		Set GetOrderTrans = Dream3CLS.Exec(f_sql)
    End Function
	

End Class
%>