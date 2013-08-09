<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../../common/api/cls_sms.asp"-->
<!--#include file="../../common/api/cls_xml.asp"-->
<%
Dim Action
Dim mobile,checkcode,opFlag,smssecret

	Action = Request.QueryString("act")
	Select Case Action
		Case "unreg"
			Call UnReg()
		Case Else
			Call Main()
	End Select
	
	Sub UnReg()
	
		mobile =  Dream3CLS.RSQL("mobile")
		checkcode = Dream3CLs.RParam("checkcode")
		
		If mobile = "" Then
			gMsgArr = gMsgArr&"|请输入手机号码！"
		Else 
			If  Not Dream3CLS.validate(mobile,4) Then
				gMsgArr = gMsgArr&"|手机号码不合法！"
			End If
		End If
		
		If checkcode = "" Then
			gMsgArr = gMsgArr&"|请输入验证码!"
		Else
			If Not Dream3User.CodeIsTrue Then
				gMsgArr = gMsgArr&"|您输入的验证码和系统产生的不一致，请重新输入!"
			End If
		End If

		
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		
		'判断是否已经存在记录
		Sql = "select * from T_SMSSubscribe Where mobile='"&mobile&"'"
		
		Rs.open Sql,conn,1,2
		'如果不存在则写入
		If  Rs.EOF Then
			gMsgArr = gMsgArr&"|您输入手机号码不存在！"
			gMsgFlag = "E"
			Exit Sub
		Elseif Rs("enabled") = "Y" Then
			sms = Rs("sms")
			If sms > CInt(SiteConfig("SMSSubsLimit")) then
				gMsgArr = "系统给您发送的验证码次数过多，已被限制发送，请与管理员联系！"
				gMsgFlag = "E"
				Exit Sub
			End If
			smssecret = Dream3CLS.MakeRandom(6)
			Rs("sms") = sms + 1
			Rs("secret") = smssecret
			Rs.Update
			Rs.Close
			Set Rs = Nothing
			'发送短信
			Call SendSMS()
			If gMsgFlag = "E" Then Exit Sub
			
			Response.Redirect("checkunreg.asp?mobile="&mobile)
			Exit Sub
		Elseif  Rs("enabled") = "N" Then
			gMsgArr = gMsgArr&"|您已取消了短信订阅！"
			gMsgFlag = "E"
			Exit Sub
		End If	
	
	End Sub
	
	Sub SendSMS()
		content = GetSMSUnRegContent()
		result = Dream3SMS.SendSMS(mobile,content)

		If result <> "success" Then
			gMsgArr = "验证码发送失败，请与管理员联系！"
			gMsgFlag = "E"
			Exit Sub
		End If
	End Sub
	
	Function GetSMSUnRegContent()
		
		Dim HtmlSMS
		HtmlSMS = Dream3Tpl.LoadTemplate("sms_unreg_content")
		HtmlSMS = Replace(HtmlSMS, "{$SiteName}",SiteConfig("SiteName"))
		HtmlSMS = Replace(HtmlSMS, "{$SiteShortName}",SiteConfig("SiteShortName"))
		HtmlSMS = Replace(HtmlSMS, "{$CityName}",G_City_NAME)
		HtmlSMS = Replace(HtmlSMS, "{$SMSSecret}",SMSSecret)
		GetSMSUnRegContent = HtmlSMS
	End Function

	
	Sub Main()	
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<div id="box">	
	<div class="cf">		
		<div id="login">
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>取消短信订阅</h2>(您正在申请取消短信订阅)</div>
						<div class="sect">
							<form class="validator" method="post" action="?act=unreg" id="login-user-form">
								<div class="field email">
									<label for="login-email-address">手机号</label>
									 <input type="text" size="30" name="mobile" id="mobile" class="f-input" value="<%=mobile%>"/>
								</div>
							    
								<div class="field email">
									<label for="login-email-address">验证码</label>
									 <input name="checkcode" type="text" class="logininput" id="checkcode" size="5" maxlength="4" onFocus="get_checkcode();this.onfocus=null;" onKeyUp="ajaxcheckcode('check_code','checkcode');" />
		  <span id="img_checkcode" style="cursor:pointer;" onClick="get_checkcode();">点击获取验证码</span><span id="isok_checkcode"></span>
								</div>
								
								<div class="act">
									<input type="submit" class="formbutton" id="login-submit" name="commit" value="提交">
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
							<h2>还没有<%=SiteConfig("SiteShortName")%>账户？</h2>
							<p>立即<a href="signup.asp">注册</a>！</p>
						</div>
					</div>
					<div class="sbox-bottom"></div>
				</div>
			</div>
		</div>
	</div>	
</div>
<script language="javascript">
<!--//
var show_checkcode = false;
function get_checkcode() {
	var chkCodeFile = "../../common/inc/getcode.asp";
	if(!show_checkcode){
		if(document.getElementById("img_checkcode"))
			document.getElementById("img_checkcode").innerHTML = '<img  id="checkcodeimg" src="'+chkCodeFile+'?t='+Math.random()+'" alt="点击刷新验证码" style="cursor:pointer;border:0;vertical-align:middle;height:18px;" onclick="this.src=\''+chkCodeFile+'?t=\'+Math.random()" />'
			show_checkcode = true;

		if(document.getElementById("isok_checkcode"))
			document.getElementById("isok_checkcode").innerHTML = '<a href="javascript://" onclick="setTimeout(function(){ document.getElementById(\'checkcodeimg\').src=\''+chkCodeFile+'?t=\'+Math.random()},100);">看不清<\/a>';
	}
}
//-->
</script>
<!--#include file="../../common/inc/footer_user.asp"-->