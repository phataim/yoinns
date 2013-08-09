<%

	
	Sub SendRegMail()
		Dim HtmlTitle,HtmlContent,regConfirmUrl
		'title
		HtmlTitle = Dream3Tpl.LoadTemplate("mail_reg_title")
		HtmlTitle = Replace(HtmlTitle, "{$SiteShortName}", SiteConfig("SiteShortName"))
		'content
		HtmlContent = Dream3Tpl.LoadTemplate("mail_reg_content")
		HtmlContent = Replace(HtmlContent, "{$SiteName}", SiteConfig("SiteName"))
		HtmlContent = Replace(HtmlContent, "{$UserName}", username)
		regConfirmUrl = GetSiteUrl() & "/user/account/reg.asp?id="&userid&"&code="&validcode
		HtmlContent = Replace(HtmlContent, "{$Reg_Confirm_Url}",regConfirmUrl )
		
		cmEmail.SendMail email,HtmlTitle,HtmlContent
		If cmEmail.Count>0 Then
			'发送成功
		Else
			gMsgArr = "验证邮件发送失败，请与管理员联系！"
			gMsgFlag = "E"
		End If

	End Sub
	
	Sub SendSMS()
		If Cint(SiteConfig("SendRegSMS")) <> 1  Then Exit Sub
		If IsNull(mobile) Or Len(mobile) <=0 Then Exit Sub
		content = GetSMSRegSuccessContent()

		result = Dream3SMS.SendSMS(mobile,content)

	End Sub
	
	Function GetSMSRegSuccessContent()
		
		Dim HtmlSMS
		HtmlSMS = Dream3Tpl.LoadTemplate("sms_signup_success_content")
		HtmlSMS = Replace(HtmlSMS, "{$SiteName}",SiteConfig("SiteName"))
		HtmlSMS = Replace(HtmlSMS, "{$UserName}",username)
		GetSMSRegSuccessContent = HtmlSMS
	End Function
	
%>