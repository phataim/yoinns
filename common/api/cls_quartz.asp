<%
Class  Dream3_Quartz

  	Private Sub Class_Initialize()
 		
	End Sub
	
	Public Sub InvokeProductState()
		'这里可以采用Application来记录访问次数，1分钟才去查询数据库一次
		s_now_time = Dream3CLS.getTime(Now())
		s_last_quartz_time = Dream3CLS.ChkNumeric(Application(DREAM3C&"_LAST_QUARTZ_TIME"))
		If s_now_time - s_last_quartz_time < 600 Then
			Exit Sub
		End if
		Application(DREAM3C&"_LAST_QUARTZ_TIME") = s_now_time
		
		'设置产品，订单状态
		SetProductState()
		SetOrderState()
		
		q_now_str = CStr(formatdatetime(now,2))
		Set q_rs = Server.CreateObject("adodb.recordset")
		q_sql = "select * from T_Config "
		q_rs.Open q_sql, Conn, 1, 3
		
		If IsNull(q_rs("quartzdate")) Or q_rs("quartzdate") <> q_now_str Then
			'invoke
			
			ClearUserLoginInfo()
			
			q_rs("quartzdate") 	= q_now_str
			q_rs.Update
		End If
		q_rs.Close
		Set q_rs = Nothing
		
	End Sub
	
	'批量删除T_UserIP表的所有内容
	Public Sub ClearUserLoginInfo()
		ON Error Resume Next
		f_sql = "Delete from T_UserIP"
		conn.execute(f_sql)	
	End Sub
	
	'批量设置产品的状态
	'判断是否为一天的第一次
	'如果该产品为Normal且已过期，则根据实际情况更新state为expired
	Public Sub SetProductState()
		expireDateTomrrow = Dream3CLS.GetStartTime(now)
		
		If IsSQLDataBase = 1 Then
			f_sql = "update  T_Product set state = 'expired' Where state = 'normal' and Datediff(d,expiredate,'"&expireDateTomrrow&"') > 0"
		Else
			f_sql = "update  T_Product set state = 'expired' Where state = 'normal' and Datediff('d',expiredate,'"&expireDateTomrrow&"') > 0"
		End If

		Dream3CLS.Exec(f_sql)
	End Sub
	
	'设置订单状态

	
	Public sub SetOrderState()
		s_today_startdate = Dream3CLS.GetStartTime(now)
		
		If IsSQLDataBase = 1 Then
			f_sql = "select * from  T_Order Where (state = 'unconfirm' or state = 'unpay') and Datediff(d,start_date,'"&s_today_startdate&"') > 0"
		Else
			f_sql = "select * from  T_Order Where (state = 'unconfirm' or state = 'unpay') and Datediff('d',start_date,'"&s_today_startdate&"') > 0"
		End If

		
		Set f_rs = Server.CreateObject("adodb.recordset")			

		f_rs.open f_sql,conn,1,2
		
		Do While Not f_rs.EOF 
			'成功的标准：预设值+订单值大于最小的值
			f_order_id = f_rs("id")
			f_order_no = f_rs("order_no")
			f_product_id = f_rs("product_id")
			f_order_status = f_rs("state")
			f_comment = ""
			
			f_set_order_status = "failed"
			
			Set oRs = Server.CreateObject("Adodb.recordset")
			o_sql = "Select * From T_Order  Where id="&f_order_id
			oRs.open o_sql,conn,1,2
			oRs("state") = f_set_order_status
			oRs.Update
			oRs.Close	
			Set oRs = nothing		
			
			
			f_user_type = "auto"
		
			
			Dream3Product.WriteToOrderTrans "expire", 0, f_user_type, f_order_id, f_set_order_status ,f_comment
				
			
			f_rs.Movenext
		Loop
	
	End sub
	
End Class

Dim Dream3Quartz
Set Dream3Quartz = New Dream3_Quartz

%>