<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_tpl.asp"-->
<!--#include file="common/api/cls_email.asp"-->
<%
Dim Action
Dim Rs,Sql
Dim code 
Dim opFlag, sendMailFlag
Dim email,msg,cityname,validcode

	Action = Request.Form("act")
	Select Case Action
		Case "save"
			SaveRecord()
		Case Else
			Call Main()
	End Select

	
	Sub SaveRecord()	
	
		email=  Dream3CLS.RSQL("email")

		city_id = Dream3CLS.ChkNumeric(Request.Form("city_id"))
		If city_id = 0 Then
			city_id = Dream3CLS.ChkNumeric(G_City_ID)
		End If
		
		'validate Form
		If email="" OR not Dream3CLS.IsValidEmail(email) Then
			gMsgArr = "Email不合法！"
			gMsgFlag = "E"
			Exit Sub
		End If
		
		Sql = "Select * From T_Subscribe Where email ='"&email&"'"
		Rs.open Sql,conn,1,2
		'如果不存在则写入并发Email
		If  Rs.EOF Then
			'如果需要验证，则发送验证邮件
			If SiteConfig("IsMailVaild") = "1" Then
				Dream3Team.WriteToSubscribe email,city_id,"N"
				sendMailFlag = "Y"
				Call SendSubscribeConfirmMail()
			Else
				Dream3Team.WriteToSubscribe email,city_id,"Y"
			End If
		Else
			'enabled = Rs("enabled")
			'If enabled = "Y" Then
				'isValid = "exist"
			'Else
				'isValid = "resend"
				'resend email
				'If SiteConfig("IsMailVaild") =  "1" Then
					'resend email 发送邮件标签
				'End If
 			'End If
			Rs("city_id") = city_id
			Rs.Update
			Rs.Close
			Set Rs = Nothing
		End If
		
		cityname = Dream3Team.getCityName(city_id,"全部")
		
		opFlag = "success"
		
		
	End Sub
	
	Sub SendSubscribeConfirmMail()
		Sql = "Select * From T_Subscribe Where email ='"&email&"'"
		Set sRs = Dream3CLS.Exec(Sql)
		validcode = sRs("secret")
		sRs.Close
		Set sRs = Nothing
		Dim HtmlTitle,HtmlContent,regConfirmUrl
		'title
		HtmlTitle = Dream3Tpl.LoadTemplate("mail_subscribe_title")
		HtmlTitle = Replace(HtmlTitle, "{$SiteShortName}", SiteConfig("SiteShortName"))
		'content
		HtmlContent = Dream3Tpl.LoadTemplate("mail_subscribe_content")
		HtmlContent = Replace(HtmlContent, "{$SiteName}", SiteConfig("SiteName"))
		regConfirmUrl = GetSiteUrl() & "/user/account/reg2.asp?code="&validcode&"&email="&email
		HtmlContent = Replace(HtmlContent, "{$Reg_Confirm_Url}",regConfirmUrl )

		cmEmail.SendMail email,HtmlTitle,HtmlContent

	End Sub
	
	Sub Main()
		city_id = G_City_ID
	End Sub
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
	
<div id="box">	
	<div class="cf">		
		<div id="recent-deals">
			<!--#include file="common/inc/subscribe_common.asp"-->
			<div id="sidebar">
				<div id="sidebar_mail" class="want_know">
					<!--#include file="common/inc/mail_right.asp"-->
				</div>
			</div>
		</div>
	</div>	
</div>

<!--#include file="common/inc/footer_user.asp"-->