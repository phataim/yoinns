<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<!--#include file="../../common/api/cls_sms.asp"-->
<%
Dim Action
Dim username,password,autologin
Dim email,confirm,city_id,mobile,subscribe,userid,manager,validcode,affirm,reg_code
Dim isCheckCode,loginip

loginip = Request.ServerVariables("REMOTE_ADDR")

isCheckCode = Dream3User.IsCheckCode(loginip)
	Action = Request.QueryString("act")
	Select Case Action
		Case "login"
			Call Login()
		Case "save"
			Call SaveRecord()
		Case Else
			Call Main()
	End Select
	
	Sub Login()
	
		username =  Dream3CLS.RSQL("username")
		password=  Dream3CLS.RParam("password")
		autologin=  Dream3CLS.RParam("autologin")

		'validate Form
		If username = "" Then
			gMsgArr = "请输入用户名或注册邮箱或注册手机号码！"
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
		Sql = "select id from T_User Where username='"&username&"' or email='"&username&"'or mobile='"&username&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If  Rs.EOF Then
			gMsgArr = "用户名不存在！"
			username = ""
			gMsgFlag = "E"
			Rs.Close
			Call Main()
			Exit Sub
		End If
		
		Rs.Close
		
		Sql = "select * from T_User Where (username='"&username&"' or email='"&username&"' or mobile='"&username&"') and password='"&md5(password)&"'"
		
		
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
		If Dream3Product.IsUserOrder(Rs("id"))  Then
		Response.Cookies(DREAM3C)("_UserOrderFlag") = "Y"
		Else
			Response.Cookies(DREAM3C)("_UserOrderFlag") = "N"
		End If
		
		Session("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Session("_UserID") = Rs("id")
		Session("_IsManager") = Rs("manager")
		Session("_UserFace") = Rs("face")

		'默认保存一个月
		Response.Cookies(DREAM3C).Expires = Date + 30
		Response.Cookies(DREAM3C)("_UserID") = Rs("id")
		Response.Cookies(DREAM3C)("_UserName") = Dream3User.GetUserDisplayName(Rs("username"), Rs("mobile"))
		Response.Cookies(DREAM3C)("_Password") =  Rs("password")
		Response.Cookies(DREAM3C)("_IsManager") =  Rs("manager")
		Response.Cookies(DREAM3C)("_UserCityCode") =  Rs("city_code")
		
		Rs.Close
		Set Rs = Nothing
		

		
		response.Redirect("../../index.asp")
		
	End Sub

	Sub SaveRecord()

		email=  Dream3CLS.RParam("email")
		username =  Dream3CLS.RParam("username")
		password=  Dream3CLS.RParam("password")
		confirm=  Dream3CLS.RParam("confirm")
		mobile=  Dream3CLS.RParam("mobile")
		city_id=  Dream3CLS.RParam("city_id")
		subscribe=  Dream3CLS.RParam("subscribe")
		affirm=  Dream3CLS.RParam("affirm")
		reg_code= Dream3CLS.RParam("reg_code")
		'validate Form
		
		If affirm = "" Then
			gMsgArr = "请先同意注册条款！"
			gMsgFlag = "E"
			Exit Sub
		End If
		
		If username = "" Then
			gMsgArr = gMsgArr&"|用户名不能为空！"
		End If
		If username<>"" and (Dream3CLS.strLength(username) < 4 or Dream3CLS.strLength(username) > 16) Then
			gMsgArr = gMsgArr&"|用户名必须在4-16个字符之间！"
		elseif InStr(UserName, "=") > 0 Or InStr(UserName, ".") > 0 Or InStr(UserName, "%") > 0 Or InStr(UserName, Chr(32)) > 0 Or InStr(UserName, "?") > 0 Or InStr(UserName, "&") > 0 Or InStr(UserName, ";") > 0 Or InStr(UserName, ",") > 0 Or InStr(UserName, "'") > 0 Or InStr(UserName, ",") > 0 Or InStr(UserName, Chr(34)) > 0 Or InStr(UserName, Chr(9)) > 0 Or InStr(UserName, "") > 0 Or InStr(UserName, "$") > 0 Or InStr(UserName, "*") Or InStr(UserName, "|") Or InStr(UserName, """") > 0 Then
			gMsgArr = gMsgArr&"|用户名中含有非法的字符！"
		End If
		
		'email不为必须
		'If email = "" Then
		'	gMsgArr = gMsgArr&"|邮件地址不能为空！ "
		'End If
		
		If email<>"" and not Dream3CLS.IsValidEmail(email) Then
			gMsgArr = gMsgArr&"|Email不合法！"
		End If
		
		
			
		
		If password = "" Then
			gMsgArr = gMsgArr&"|密码不能为空！"
		End If
		
		If password <> "" and (password<>confirm) Then
			gMsgArr = gMsgArr&"|密码和确认密码不符！"
		End If
		
		'如果手机号码必填
		If Dream3CLS.SiteConfig("IsForceMobile") = "1" Then
			If mobile = "" Then
				gMsgArr = gMsgArr&"|手机号码必填！"
			End If
		End If	
		
		
		If mobile<>"" and not Dream3CLS.validate(mobile,4) Then
			gMsgArr = gMsgArr&"|手机号码不合法！"
		End If
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		telcode = session("r_no") '读取验证码
		if telcode="" Then
			gMsgArr = gMsgArr&"|您没有填写手机验证码"
		else
			if reg_code <> telcode then
				gMsgArr= gMsgArr&"|您填写的手机验证码"&reg_code&"不正确，请重新输入"
			end if
		end if
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		
		'判断是否已经存在记录
		Sql = "select id from T_User Where email='"&email&"'"
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "Email已经存在！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		Sql = "select id from T_User Where username='"&username&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "用户名已经存在！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		Sql = "select id from T_User Where mobile='"&mobile&"'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "手机号码已存在！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		validcode = Dream3CLS.GetRandomize(32)
		
		Sql = "select count(id) from T_User"
		
		Set Rs = Dream3CLS.Exec(Sql)
		userCount = Rs(0)
		
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_User "
		Rs.open Sql,conn,1,2
		Rs.AddNew
		Rs("username") = username
		Rs("password") 	= md5(password)
		Rs("email") 	= email
		Rs("mobile") 	= mobile
		
		Rs("ip") = Request.ServerVariables("REMOTE_ADDR")
		Rs("validcode") = validcode
		Rs("create_time")= now()
		Rs("state")= 1
		If userCount = 0 Then
			manager = "Y"
		Else
			manager = "N"
		End If
		Rs("manager") 	= manager
		If Dream3CLS.SiteConfig("IsMailVaild") = "1" Then
			enabled = "N"
		Else
			enabled = "Y"
		End If
		Rs("enabled") 	= enabled
		
		citysql = "select * from T_City where depth = 3 order by citypostcode "
		Set cityRs = Dream3CLS.Exec(citysql)
		If Not cityRs.EOF Then
			Rs("city_code") 	= cityRs("citypostcode")
		Else
			Rs("city_code") = "0"
		End If

		Rs.Update
		Rs.Close
		Set Rs = Nothing

		'得到当前用户的ID
		Sql = "Select id From T_User Where username ='"&username&"'"
		Set Rs = Dream3CLS.Exec(Sql)
		userid = Rs(0)
		
		

		'如果需要验证，则发送验证邮件
		If Dream3CLS.SiteConfig("IsMailVaild") = "1" Then
			Call SendRegMail()
			If gMsgFlag = "E" Then
				Exit Sub
			Else
				response.Redirect("signupresult.asp")
				response.End()
			End If
		End If
		
		gMsgFlag = "S"
		'Dream3CLS.showMsg "保存成功","S","index.asp"
		'存进Session，暂时不存在cookies中
		
		CleanCookies()
		
		Session("_UserName") = username
		Session("_UserID") = userid
		Session("_IsManager") = manager
		If manager = "Y" then
			Session("_IsManagerLogin") = "Y"
		End If
		
		Response.Cookies(DREAM3C)("_UserID") = userid
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		'取消注册成功发短信
		'发送注册成功短信
		'Call SendSMS() 
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		
		response.Redirect("../../index.asp")
		
	End Sub
	
	Sub SendRegMail()
		Dim HtmlTitle,HtmlContent,regConfirmUrl
		'title
		HtmlTitle = Dream3Tpl.LoadTemplate("mail_reg_title")
		HtmlTitle = Replace(HtmlTitle, "{$SiteShortName}", Dream3CLS.SiteConfig("SiteShortName"))
		'content
		HtmlContent = Dream3Tpl.LoadTemplate("mail_reg_content")
		HtmlContent = Replace(HtmlContent, "{$SiteName}", Dream3CLS.SiteConfig("SiteName"))
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
	
	Sub Main()	
		autologin = "1"
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<script language="javascript" src="../sms/m_js.js"></script>

<div class="area">
	
    <div class="reg_cente">
	<form class="validator" method="post" action="?act=login" id="loginForm" name="loginForm">
    	<div class="reg_left">
        	<dl>
            	<dt>登陆</dt>
                <dd>邮箱/登录名/手机号：
				<input type="text" value="<%=username%>" class="reg_txt" id="username" name="username">
				</dd>
                <dd>密码：
				<input type="password" value="" class="reg_txt" id="password" name="password">
				</dd>
				<BR><span class="validatorMsg"><a href="forgetpwd.asp">忘记密码？</a></span>
				<%If isCheckCode Then%>
				<dd>验证码：
				<input name="checkcode" type="text" class="reg_txt" id="checkcode" size="5" maxlength="4" onFocus="get_checkcode();this.onfocus=null;" onKeyUp="ajaxcheckcode('check_code','checkcode');" />
		  <BR><span id="img_checkcode" style="cursor:pointer;" onClick="get_checkcode();">点击获取验证码</span><span id="isok_checkcode"></span>
				</dd>
				<%End If%>
                
            </dl>
            <p style="width:340px;float:left;margin-top:20px;" class="validatorMsg">
			<input type="checkbox" value="1" name="autologin" id="autologin" class="f-check" <%If autologin = "1" Then response.Write("checked")%> />
			&nbsp;
            下次自动登录
            </p>
            <p>
			<input type="submit" value="马上登陆!" name="commit" class="login_bottom">
			</p>
        </div>
		 </form>
       <form class="validator" action="?act=save" method="post" id="signupForm" name="signupForm">
	   <div class="login_right">
        	<dl>
            	<dt>普通用户注册</dt>
				<dd>用户名/昵称：
				<input type="text" value="手机号码/邮箱/用户名" class="reg_txt" id="Text1" name="username"onclick="value='';focus()"
>  <font color="ff0000">*</font>             <span class="validatorMsg"><br />填写4-16个字符，一个汉字为两个字符。</span>
				</dd>

                <dd>密码：
				<input type="password" value="" class="reg_txt" id="password1" name="password"> <font color="ff0000">*</font> 
				<span class="validatorMsg"><br />为了您的帐号安全，建议密码最少设置为6个字符以上。</span>			
				</dd>
                
                <dd>确认密码：
				<input type="password" value="" class="reg_txt" id="confirm" name="confirm"> <font color="ff0000">*</font> 
				<span class="validatorMsg"><br />请再次输入您的密码</span>
				</dd>
               
                <dd>邮箱：
				<input type="text" name="email" id="email" class="reg_txt" value="<%=email%>"/> 
				<span class="validatorMsg"><br />用于登录及找回密码，不会公开，请放心填写。</span>
				</dd>
                
                
                
                <dd>手机号码：
				<input type="text" value="<%=mobile%>" class="reg_txt2" id="mobile" name="mobile"  maxlength="13" /> <font color="ff0000">*</font> 
                <!--mike -->
				<br /><span class="validatorMsg">请输入你的手机号码</span>
                <input name="regcodesub" type="button" value="发送验证码" onclick="send_sms()" />
                <!--mike -->

				</dd>
                
				<dd>验证码:
				<br />
                <!--mike -->
                <input type="text" value="<%=reg_code%>" class="reg_txt3"  name="reg_code" id="reg_code"  onkeydown="check_r_no();" onkeyup="check_r_no();" onclick="check_r_no();" ><!--mike --><span id="is_ok_reg"></span><!--mike -->
                <!--mike -->
                <span class="validatorMsg"><br />请输入你的手机验证码</span>
				</dd>
            </dl>
            <p style="width:340px;float:left;margin-top:20px;">
            <input type="checkbox" id="affirm" name="affirm" checked="" autocomplete="off">&nbsp;
            我已阅读并同意<%=Dream3CLS.SiteConfig("SiteShortName")%>的服务条款<a href="../../help/index.asp?c=terms" target=_blank>《<%=Dream3CLS.SiteConfig("SiteShortName")%>服务条款》</a>
            </p>
            <p id="register"><a class="reg_button" href="#" onclick="document.signupForm.submit();">立刻注册!</a></p>
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