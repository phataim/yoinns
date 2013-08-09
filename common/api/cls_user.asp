<%
Class  Dream3_User

  	Private Sub Class_Initialize()
 		
	End Sub
	
	
	'得用户的金额
	Public Function GetUserMoney(f_user_id)
		if f_user_id = "" Then getUserMoney = 0 :Exit Function
		f_sql = "Select [money] From T_User Where id="&f_user_id
		Set f_rs = Dream3CLS.Exec(f_sql)
		getUserMoney = Dream3CLS.FormatNumbersNil(cdbl(f_rs("money")))
	End Function
	
	'得用户扣款
	Public Sub AddOrDeductUserMoney(f_user_id,f_money)
		Set f_rs = Server.CreateObject("adodb.recordset")			
		f_sql = "Select [money] From T_User Where id="&f_user_id
		f_rs.open f_sql,conn,1,2
		If f_rs.EOF Then
			Exit Sub
		Else
			f_rs("money") = CDBL(f_rs("money")) + CDBL(f_money)
			f_rs.Update
			f_rs.Close
			Set f_rs = Nothing
		End If
	End Sub
	
	Public Function CodeIsTrue()
		Dim CodeStr
		CodeStr=Lcase(Trim(Request.Form("checkcode")))
		If CStr(Session("checkcode"))=CStr(CodeStr) And CodeStr<>""  Then
			CodeIsTrue=True
			Session("checkcode")=Empty
		Else
			CodeIsTrue=False
			Session("checkcode")=Empty
		End If
	End Function
	
	'记录登录次数
	Public Sub LogIPLoginTimes(f_ip)
		If f_ip = "" Then
			f_ip = "unknown"
		End If
		Set f_rs = Server.CreateObject("adodb.recordset")			
		f_sql = "Select * From T_UserIP Where IP='"&f_ip&"'"

		f_rs.open f_sql,conn,1,2
		If f_rs.EOF Then
			f_rs.Addnew
			f_rs("IP") = f_ip
			f_rs("logintimes") = 1
			f_rs("login_date") = CStr(formatdatetime(now,2))
		Else
			If IsNull(f_rs("logintimes")) Or f_rs("logintimes")="" Then
				f_rs("logintimes") =  1
			Else
				f_rs("logintimes") = f_rs("logintimes") + 1
			End If
			
		End If
		f_rs.Update
		f_rs.Close
		Set f_rs = nothing
	End Sub
	
	'判断是否需要开启验证码
	Public Function IsCheckCode(f_ip)
		Dim f_logintimes
		If f_ip = "" Then
			f_ip = "unknown"
		End If		
		f_sql = "Select logintimes From T_UserIP Where IP='"&f_ip&"'"
		Set f_rs = Dream3CLS.Exec(f_sql)
		If f_rs.EOF Then
			IsCheckCode = false
		Else
			f_logintimes = f_rs("logintimes") 
			If f_logintimes >= 3 Then
				IsCheckCode = true
			Else
				IsCheckCode = false
			End If
		End If
	End Function
	
	'判断是否需要停止发送短信
	Public Function IsStopSendSMS(f_ip)
		Dim f_sms
		If f_ip = "" Then
			f_ip = "unknown"
		End If		
		f_sql = "Select sms From T_UserIP Where IP='"&f_ip&"'"
		Set f_rs = Dream3CLS.Exec(f_sql)
		If f_rs.EOF Then
			IsStopSendSMS = false
		Else
			f_sms = f_rs("sms") 
			If f_sms >= Dream3CLS.ChkNumeric(SiteConfig("IPSMSCount")) Then
				IsStopSendSMS = true
			Else
				IsStopSendSMS = false
			End If
		End If
	End Function
	
	Public Function IsIPAllowed(f_ips,f_target_ip)
		If Instr(f_ips,f_target_ip) > 0 Then
			IsIPAllowed = true
		Else
			IsIPAllowed = false
		End If
	End Function
	
	Public Function GetUserDisplayName(f_username,f_mobile)
		If IsNull(f_username) Or Trim(f_username) = "" Then
			GetUserDisplayName = f_mobile
		Else
			GetUserDisplayName = f_username
		End If
	End Function
	
	'从用户map中获取数据
	Public Function GetUserFromMap(f_userMap,f_user_id)
		Dim f_display
		f_user_id = CStr(f_user_id)
		If IsArray(f_userMap.getv(f_user_id)) Then
			If f_userMap.getv(f_user_id)(0) <> "" Then
				f_display = f_userMap.getv(f_user_id)(0) &"<BR>"
			End If
			If f_userMap.getv(f_user_id)(1) <> "" Then
				f_display = f_display & f_userMap.getv(f_user_id)(1) &"<BR>"
			End If
			If f_userMap.getv(f_user_id)(2) <> "" Then
				f_display = f_display & f_userMap.getv(f_user_id)(2)
			End If
		End If
		GetUserFromMap = f_display
	End Function
	
	
	'记录短信发送次数
	Public Sub LogSMSSendTimes(f_ip)
		If f_ip = "" Then
			f_ip = "unknown"
		End If
		Set f_rs = Server.CreateObject("adodb.recordset")			
		f_sql = "Select * From T_UserIP Where IP='"&f_ip&"'"

		f_rs.open f_sql,conn,1,2
		If f_rs.EOF Then
			f_rs.Addnew
			f_rs("IP") = f_ip
			f_rs("sms") = 1
			f_rs("login_date") = CStr(formatdatetime(now,2))
		Else
			f_rs("sms") = f_rs("sms") + 1
		End If
		f_rs.Update
		f_rs.Close
		Set f_rs = nothing
	End Sub
	
	
End Class

Dim Dream3User
Set Dream3User = New Dream3_User

%>