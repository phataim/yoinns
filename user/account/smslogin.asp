<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<%
Dim Action
Dim username,password,autologin
Dim isCheckCode,loginip

loginip = Request.ServerVariables("REMOTE_ADDR")

isCheckCode = Dream3User.IsCheckCode(loginip)

	Action = Request.QueryString("act")
	Select Case Action
		Case "login"
			Call Login()
		Case Else
			Call Main()
	End Select
	
	Sub Login()
	
		username =  Dream3CLS.RSQL("username")
		password=  Dream3CLS.RParam("password")
		autologin=  Dream3CLS.RParam("autologin")

		'validate Form
		If username = "" Then
			gMsgArr = "请输入登录名或手机号！"
		End If
		
		If password ="" Then
			gMsgArr = gMsgArr&"|请输入密码！"
		End If
		
		'记录登录次数
		Dream3User.LogIPLoginTimes(loginip)
		
		If isCheckCode Then
			If Not Dream3User.CodeIsTrue Then
				gMsgArr = gMsgArr&"|您输入的认证码和系统产生的不一致，请重新输入!"
			End If
		End If
		
		isCheckCode = Dream3User.IsCheckCode(loginip)
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		
		'判断是否已经存在记录
		Sql = "select id from T_User Where username='"&username&"' or mobile='"&username&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If  Rs.EOF Then
			gMsgArr = "用户名或手机不存在！"
			username = ""
			gMsgFlag = "E"
			Rs.Close
			Call Main()
			Exit Sub
		End If
		
		Rs.Close
		
		Sql = "select * from T_User Where (username='"&username&"' or mobile='"&username&"') and password='"&md5(password)&"'"
		
		
		Rs.open Sql,conn,1,2
		
		If  Rs.EOF Then
			gMsgArr = "用户名密码不匹配！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If  Rs("enabled")="N" Then
			gMsgArr = "您的账号未通过验证或者被锁定，暂时无法登录！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		'Update Ip and Last_time
		Rs("ip") = loginip
		Rs("last_time") = Now
		Rs.Update
		
		'读取订单信息，并显示在首页
		If Dream3Team.IsUserOrder(Rs("id"))  Then
		Response.Cookies(DREAM3C)("_UserOrderFlag") = "Y"
		Else
			Response.Cookies(DREAM3C)("_UserOrderFlag") = "N"
		End If

		Session("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Session("_UserID") = Rs("id")
		Session("_IsManager") = Rs("manager")

		'默认保存一个月
		Response.Cookies(DREAM3C).Expires = Date + 30
		Response.Cookies(DREAM3C)("_UserID") = Rs("id")
		Response.Cookies(DREAM3C)("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Response.Cookies(DREAM3C)("_Password") =  Rs("password")
		Response.Cookies(DREAM3C)("_IsManager") =  Rs("manager")
		Response.Cookies(DREAM3C)("_UserCityID") =  Rs("city_id")
		
		Rs.Close
		Set Rs = Nothing
		
		response.Redirect("../../index.asp")
		
	End Sub

	
	Sub Main()	
		autologin = "1"
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
						<div class="head"><h2>登录</h2><span>&nbsp;或者 <a href="smssignup.asp">注册</a></span></div>
						<div class="sect">
							<form class="validator" method="post" action="?act=login" id="login-user-form">
								<div class="field email">
									<label for="login-email-address">手机／用户名</label>
									 <input type="text" size="30" name="username" id="username" class="f-input" value="<%=username%>"/>
								</div>
							    <div class="field password">
									<label for="login-password">密码</label>
									<input type="password" size="30" name="password" id="password" class="f-input" />
								  <span class="lostpassword"><a href="forgetpwd.asp">忘记密码？</a></span>								
								</div>
								<%If isCheckCode Then%>
								<div class="field email">
									<label for="login-email-address">验证码</label>
									 <input name="checkcode" type="text" class="logininput" id="checkcode" size="5" maxlength="4" onFocus="get_checkcode();this.onfocus=null;" onKeyUp="ajaxcheckcode('check_code','checkcode');" />
		  <span id="img_checkcode" style="cursor:pointer;" onClick="get_checkcode();">点击获取验证码</span><span id="isok_checkcode"></span>
								</div>
								<%End If%>
								<div class="field autologin">
									 <input type="checkbox" value="1" name="auto-login" id="autologin" class="f-check" <%If autologin = "1" Then response.Write("checked")%> />
									<label for="autologin">下次自动登录</label>
								</div>
								<div class="act">
									<input type="submit" class="formbutton" id="login-submit" name="commit" value="登录">
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