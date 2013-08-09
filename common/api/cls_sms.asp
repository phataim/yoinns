<%
Class Dream3_SMS

	Private Sub Class_Initialize()
		On Error Resume Next
	End Sub
	
	Public Function SendSMS(f_mobile,f_content)
		Dim s_return
		
		url = Dream3CLS.SiteConfig("SMSUrl")&"?Account="&Dream3CLS.SiteConfig("SMSUserID")&"&Password="&Dream3CLS.SiteConfig("SMSUserPwd")&"&Phone="&f_mobile&"&Content="&f_content
		
		s_xml = GetURLByGet(url)
		't(s_xml)
		s_result = Dream3XML.GetValueByTag(s_xml,"response")
		's_result = 1
		
		If s_result = 1 Then
			s_return = "success"
		Else
			s_return = f_mobile&"发送失败，失败代码："&s_result
		End If
		
		SendSMS = s_return
	End Function
	
	'查询余额
	Public Function GetSMSBalance()
		Dim s_return
		'url = "http://210.77.144.234/newesms/user/qamount.jsp?cpid="&Dream3CLS.SiteConfig("SMSUserID")&"&pwd="&Dream3CLS.SiteConfig("SMSUserPwd")
		url = "http://202.85.214.45/mc/userbalance.php?ua="&Dream3CLS.SiteConfig("SMSUserID")&"&pw="&Dream3CLS.SiteConfig("SMSUserPwd")
		s_xml = GetURLByGet(url)
		s_result = Dream3XML.GetValueByTag(s_xml,"Result")
		s_value = Dream3XML.GetValueByTag(s_xml,"Balance")
		
		if s_result = 4 Then 
			GetSMSBalance = s_value
			Exit Function
		Else
			GetSMSBalance = "错误"
		End If
		'Select Case s_reslut
			'Case 0
				's_return = "密码错误"
			'Case 1
				's_return = "密码尝试超过次数限制"
			'Case 2
				's_return = "用户不存在"
			'Case 3
				's_return = "用户暂停使用"
			'Case 4
				's_return = s_value
			'Case else
				's_return = "未定义"
		'End Select
	End Function
	
	Function GetURLByGet(URL)
		Set http=Server.CreateObject("Microsoft.XMLHTTP") 
			 On Error Resume Next
			 http.Open "get",URL,False 
			 http.send()
			 if Err then
			 Err.Clear
			 GetURLByGet = "NOTFOUND"
			 exit function
			 End if
			 getHTTPPage=BytesToBstr(Http.responseBody,"utf-8")
		set http=nothing 
		GetURLByGet=getHTTPPage
	End Function
	


End Class

Dim Dream3SMS
Set Dream3SMS = New Dream3_SMS
%>