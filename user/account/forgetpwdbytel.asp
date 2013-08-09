<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_email.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<%
Dim Action
Dim username,password,email
Dim isCheckCode,checkcode
Dim opFlag,validcode,userid

loginip = Request.ServerVariables("REMOTE_ADDR")

	Action = Request.QueryString("act")
	Select Case Action
		Case "nextstep"
			Call Nextstep()
		Case Else
				Call Main()
	End Select
	
	Sub Nextstep()
	
		username =  Dream3CLS.RSQL("username")
		checkcode=  Dream3CLS.RParam("checkcode")

		'validate Form
		If username = "" Then
			gMsgArr = "请输入登录名或者Email！"
		End If
		
		If checkcode ="" Then
			gMsgArr = gMsgArr&"|请输入验证码！"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		If Not Dream3User.CodeIsTrue Then
			gMsgArr = gMsgArr&"|您输入的认证码和系统产生的不一致，请重新输入!"
			gMsgFlag = "E"
			Exit Sub
		End If
		
	
		'判断是否已经存在记录
		Sql = "select * from T_User Where username='"&username&"' or email='"&username&"'"
		Rs.open Sql,conn,1,2
		
		'如果不存在账号，则直接显示发送成功
		If  Rs.EOF Then
			opFlag = "showresult"
		Else
			email = Rs("email")
			userid = Rs("id")
			If  IsNull(email) Or email = "" Then
				opFlag = "showresult"
			Else
				validcode = Dream3CLS.GetRandomize(32)
				Rs("validcode") = validcode
				Rs.Update
				SendForgetPwdMail()
				If gMsgFlag = "E" Then
					Exit Sub
				End If
				opFlag = "showresult"
			End If
		End If
		
		Rs.Close
		
	End Sub

	
	Sub Main()	

	End Sub
	
	Sub SendForgetPwdMail()
		Dim HtmlTitle,HtmlContent,regConfirmUrl
		'title
		HtmlTitle = Dream3Tpl.LoadTemplate("mail_forgetpwd_title")
		HtmlTitle = Replace(HtmlTitle, "{$SiteShortName}", SiteConfig("SiteShortName"))
		HtmlTitle = Replace(HtmlTitle, "{$SiteName}", SiteConfig("SiteName"))
		'content
		HtmlContent = Dream3Tpl.LoadTemplate("mail_forgetpwd_content")
		HtmlContent = Replace(HtmlContent, "{$SiteName}", SiteConfig("SiteName"))
		HtmlContent = Replace(HtmlContent, "{$UserName}", username)
		regConfirmUrl = GetSiteUrl() & "/user/account/changepwd.asp?id="&userid&"&code="&validcode
		HtmlContent = Replace(HtmlContent, "{$Reg_Confirm_Url}",regConfirmUrl )
		
		cmEmail.SendMail email,HtmlTitle,HtmlContent
		If cmEmail.Count>0 Then
			'发送成功
		Else
			gMsgArr = "邮件发送失败，请与管理员联系！"
			gMsgFlag = "E"
		End If

	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />


<form class="validator" method="post" action="" id="loginForm" name="loginForm">
<div class="area">
	
    <div class="reg_cente">
		<%
		If opFlag <> "showresult" Then
		%>
    	<div class="reg_left">
        	<dl>
            	<dt>忘记密码</dt>
                <dd>第一步：发送确认邮件
				<input type="text" value="<%=username%>" class="reg_txt" id="username" name="username">
				</dd>
				<dd>验证码：
				<input name="checkcode" type="text" class="reg_txt" id="checkcode" size="5" maxlength="4" onFocus="get_checkcode();this.onfocus=null;" onKeyUp="ajaxcheckcode('check_code','checkcode');" />
		  <BR><span id="img_checkcode" style="cursor:pointer;" onClick="get_checkcode();">点击获取验证码</span><span id="isok_checkcode"></span>
				</dd>
            </dl>
            
            <p><a class="login_bottom" href="#" onClick="document.loginForm.submit();">下一步!</a></p>
        </div>
		
		<%Else%>
		<div class="reg_left">
        	<dl>
            	<dt>提示</dt>
                <dd>确认邮件发送成功！<br>
				系统已给您的邮箱成功发送了修改密码的邮件，请查收并按照提示完成操作！
				</dd>
				
            </dl>
        </div>
		<%End If%>
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