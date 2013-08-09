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

	
	Sub Main()	
		autologin = "1"
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<form class="validator" method="post" action="?act=login" id="loginForm" name="loginForm">
<div class="area">
	
    <div class="reg_cente">
    	<div class="reg_left">
        	<dl>
            	<dt>登录</dt>
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
			<input type="submit" value="马上登录!" name="commit" class="login_bottom">
			</p>
        </div>
        <div class="reg_right">
            <dl>
                <dt class="font18">还没有<%=Dream3CLS.SiteConfig("SiteShortName")%>账户吗？</dt>
                <dd><a class="reg_log" href="signup.asp">注册</a></dd>
            </dl>
        </div>
    </div>
    
</div>
</form>

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