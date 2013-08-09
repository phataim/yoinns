<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/api/cls_sms.asp"-->
<!--#include file="../../common/api/cls_xml.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../../common/api/cls_email.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<%
Dim Action
Dim mobile,smssecret
Dim opFlag

loginip = Request.ServerVariables("REMOTE_ADDR")

	Action = Request.QueryString("act")
	Select Case Action
		Case "save"
			Call SaveRecord()
		Case Else
				Call Main()
	End Select
	
	Sub SaveRecord()
	
		mobile=  Dream3CLS.RParam("mobile")

		'validate Form
		If mobile = "" Then
			gMsgArr = gMsgArr&"|请输入手机号码！"
			gMsgFlag = "E"
			Exit Sub
		End If

		If mobile<>"" and not Dream3CLS.validate(mobile,4) Then
			gMsgArr = gMsgArr&"|手机号码不合法！"
			gMsgFlag = "E"
			Exit Sub
		End If
		
		isStopSendSMS = Dream3User.IsStopSendSMS(loginip)
		If isStopSendSMS Then
			gMsgArr = "系统已限制给你发送短信，请与管理员联系！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		'判断是否已经存在记录
		Sql = "select id from T_User Where mobile='"&mobile&"' and enabled='Y'"
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "您输入的手机号码已经存在并通过验证！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		'保存记录
		
		smssecret = Dream3CLS.MakeRandom(6)
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_User Where mobile='"&mobile&"'"

		Rs.open Sql,conn,1,2
		If Rs.EOF Then
			Rs.AddNew
		End If
		Rs("username") = ""
		Rs("mobile") 	= mobile
		Rs("city_id") 	= 0
		If IsNull(Rs("validcode")) Or Rs("validcode") = "" Or Len(Rs("validcode")) > 6 Then
			Rs("validcode") = smssecret
		End if
		Rs("create_time")= now()
		Rs("enabled") 	= "N"

		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		'发送验证码
		Call SendSMS()
		If gMsgFlag = "E" Then Exit Sub
		'记录登录次数
		Dream3User.LogSMSSendTimes(loginip)
		
		Response.Redirect("smssignup2.asp?mobile="&mobile)
		
	End Sub
	
	Sub SendSMS()
		content = GetSMSRegContent()
		result = Dream3SMS.SendSMS(mobile,content)

		If result <> "success" Then
			gMsgArr = "验证码发送失败，请与管理员联系！"
			gMsgFlag = "E"
			Exit Sub
		End If
	End Sub
	
	Function GetSMSRegContent()
		
		Dim HtmlSMS
		HtmlSMS = Dream3Tpl.LoadTemplate("sms_signup_content")
		HtmlSMS = Replace(HtmlSMS, "{$SiteName}",SiteConfig("SiteName"))
		HtmlSMS = Replace(HtmlSMS, "{$SMSSecret}",SMSSecret)
		GetSMSRegContent = HtmlSMS
	End Function
	
	
	Sub Main()	

	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=SiteConfig("SiteName")%>-用户注册</title>
<div id="box">	
	<div class="cf">		
		<div id="login">
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>注册</h2><span>&nbsp;或者 <a href="login.asp">登录</a></span></div>
						<div class="sect">
                    <form class="validator" action="?act=save" method="post" id="signupForm" name="signupForm">
                        <div class="field">
                            <label for="signup-password-confirm">您的手机号码：</label>
                           <input class="number" type="text" maxlength="11" autocomplete="off" name="mobile" id="mobile" value="<%=mobile%>"><span class="inputtip">手机号码是我们联系您的最重要方式，并用于优惠券的短信通知</span>
                        </div>
						
                        <div class="act">
                             <input type="submit" class="formbutton" id="signup-submit" name="commit" value="点击获取手机验证码">
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
