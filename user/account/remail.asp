<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../../common/api/cls_email.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<!--#include file="../../common/api/cls_sms.asp"-->
<!--#include file="../../common/api/cls_xml.asp"-->
<%
Dim Action
Dim username,email,password,confirm,city_id,mobile,subscribe,userid,manager,validcode

	Action = Request.QueryString("act")
	Select Case Action
		Case "save"
			Call SaveRecord()
		Case Else
			Call Main()
	End Select
	
	Sub SaveRecord()
	
		email=  Dream3CLS.RParam("email")

		'validate Form
		If email = "" Then
			gMsgArr = "邮件地址不能为空！"
		End If
		
		If email<>"" and not Dream3CLS.IsValidEmail(email) Then
			gMsgArr = gMsgArr&"|Email不合法！"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		
		'判断是否已经存在记录
		Sql = "select * from T_User Where email='"&email&"'"
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Rs.EOF Then
			gMsgArr = "该Email还未被注册！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If Rs("enabled") = "Y" Then
			gMsgArr = "该Email已通过验证！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		validcode = Rs("validcode")
		username = Rs("username")
		userid = Rs("id")
		
		'开始发送邮件
		Call SendRegMail()
		If gMsgFlag = "E" Then
			Exit Sub
		Else
			response.Redirect("signupresult.asp")
			response.End()
		End If
		
		
		gMsgFlag = "S"
		
	End Sub
	
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
	
	Sub Main()	
		subscribe = "1"
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=SiteConfig("SiteName")%>-重新发送注册邮件</title>

<div id="box">	
	<div class="cf">		
		<div id="login">
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>重新发送注册Email</h2><span>&nbsp;或者 <a href="login.asp">登录</a></span></div>
						<div class="sect">
                    <form class="validator" action="?act=save" method="post" id="signup-user-form">
                        <div class="field email">
                            <label for="signup-email-address">Email</label>
                            <input type="text" size="30" name="email" id="email" class="f-input" value="<%=email%>"/> 
                            <span class="hint">我们会给您填写的邮箱重新发送一份注册认证Email!</span>
                        </div>
                   
						
						
                        <div class="act">
                            <input type="submit" class="formbutton" id="signup-submit" name="commit" value="发送">
                        </div>
                    </form>
                </div>
					</div>
					<div class="login-bottom"></div>
			</div>
			<div id="sidebar">
				<div class="sbox">
					<div class="sbox-top"></div>
					<div class="sbox-content">
						<div class="side-tip">
							<h2>已有<%=SiteConfig("SiteShortName")%>账户？</h2>
							<p>请直接<a href="login.asp">登录</a>！</p>
						</div>
					</div>
					<div class="sbox-bottom"></div>
				</div>
			</div>
		</div>
	</div>	
</div>

<!--#include file="../../common/inc/footer_user.asp"-->
