<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../../common/api/cls_email.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<%
Dim Action
Dim username,email,password,confirm,city_id,mobile,subscribe,userid,manager,validcode
Dim smssecret,opFlag
	Action = Request.QueryString("act")

	Select Case Action
		Case "save"
			Call SaveRecord()
		Case Else
			Call Main()
	End Select
	
	Sub SaveRecord()
	
		mobile=  Dream3CLS.RSQL("mobile")
		smssecret =  Dream3CLS.RSQL("smssecret")
		city_id=  Dream3CLS.RParam("city_id")
		subscribe=  Dream3CLS.RParam("subscribe")

		'validate Form
		If mobile = "" Then
			gMsgArr = gMsgArr&"|手机号码必填！"
		End If
		If smssecret = "" Then
			gMsgArr = gMsgArr&"|请输入6位手机验证码！"
		End If		
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		Sql = "select count(id) from T_User where enabled='Y'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		userCount = Rs(0)
		
		If Rs.state =1 Then Rs.Close
		'判断是否已经存在记录
		Sql = "select * from T_User Where mobile='"&mobile&"'"
		Rs.open Sql,conn,1,2
		
		If  Rs.EOF Then
			gMsgArr = "请不要修改请求地址！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If Rs("enabled") = "Y" Then
			gMsgArr = "该手机已经通过申请！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		If smssecret <> Rs("validcode") Then
			gMsgArr = "您输入的验证码不正确！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		password = Dream3CLS.MakeRandom(6)
		Rs("password") 	= md5(password)
		Rs("city_id") 	= city_id
		Rs("money") = 0
		Rs("ip") = Request.ServerVariables("REMOTE_ADDR")
		If userCount = 0 Then
			manager = "Y"
		Else
			manager = "N"
		End If
		Rs("manager") 	= manager
		Rs("enabled") 	= "Y"

		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		'得到当前用户的ID
		Sql = "Select id From T_User Where mobile ='"&mobile&"'"
		Set Rs = Dream3CLS.Exec(Sql)
		userid = Rs(0)
		
		
		'如果邀请ID不为空，则记录邀请记录
		inviteUserId = Request.Cookies(DREAM3C)("_InviteUserID")
		
		inviteUserId = Dream3CLS.ChkNumeric(inviteUserId)
		If inviteUserId <> 0 Then

			Set Rs = Server.CreateObject("Adodb.recordset")
			Sql = "Select * from T_Invite "
			Rs.open Sql,conn,1,2
			Rs.AddNew
			Rs("user_id") = inviteUserId
			Rs("user_ip") 	= ""
			Rs("admin_id") = 0
			Rs("other_user_id") = userid
			Rs("other_user_ip") = Request.ServerVariables("REMOTE_ADDR")
			Rs("team_id") 	= 0
			Rs("state") 	= "N"
			Rs("create_time")= now()

			Rs.Update
			Rs.Close
			Set Rs = Nothing
			
			'清空cookies
			Response.Cookies(DREAM3C)("_InviteUserID") =  ""
			
		End If
		
		If Rs.state = 1 Then Rs.Close
		If CStr(subscribe) = "1" Then
			'判断是否已经存在记录
			Sql = "select * from T_SMSSubscribe Where mobile='"&mobile&"'"
			
			Rs.open Sql,conn,1,2
			'如果不存在则写入
			If  Rs.EOF Then
				Rs.AddNew
			End If	
			Rs("mobile") = mobile
			Rs("enabled") = "Y"
			SMSSecret = Dream3CLS.MakeRandom(6)
			Rs("secret") 	= SMSSecret
			Rs("city_id") 	= city_id
			Rs.Update
			Rs.Close
			Set Rs = Nothing
			
		End If

		
		'gMsgFlag = "S"
		'Dream3CLS.showMsg "保存成功","S","index.asp"
		'存进Session，暂时不存在cookies中
		
		CleanCookies()
		
		Session("_UserName") = mobile
		Session("_UserID") = userid
		Session("_IsManager") = manager
		If manager = "Y" then
			Session("_IsManagerLogin") = "Y"
		End If
		Response.Cookies(DREAM3C)("_UserID") = userid
		
		opFlag = "showpassword"
		'response.Redirect("../../index.asp")
		
	End Sub
	

	

	
	Sub Main()	
		subscribe = "1"
		mobile = Dream3CLS.RSQL("mobile")
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=SiteConfig("SiteName")%>-用户注册</title>

<div id="box">	
	<div class="cf">		
		<div id="login">
			<!---->
			<%If opFlag<>"showpassword" Then %>
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>注册</h2><span>&nbsp;或者 <a href="#">登录</a></span></div>
						<div class="sect">
                    <form class="validator" action="?act=save" method="post" id="signupForm" name="signupForm">
                        <div class="field">
                            <label for="signup-password-confirm">您的手机号码</label>
                            <input style="display:none" type="text" size="30" name="mobile" id="mobile" class="number" value="<%=mobile%>" readonly="true"/>
							<h1><%=mobile%></h1>
							
                        </div>
						<div class="field">
                            <label for="signup-password-confirm">手机验证码</label>
                            <input type="text" size="30" name="smssecret" id="smssecret" class="number" value="<%=smssecret%>"/><span class="inputtip">请从您的手机接收的短信上获取6位验证码</span>
							<input type="button" class="formbutton" id="btnSend" name="btnSend" value="重新获取验证码" onclick="history.back(-1);">
                        </div>
						<div class="field city">
                            <label id="enter-address-city-label" for="signup-city">所在城市</label>
							<select name="city_id" class="f-city">
							<%=Dream3Team.getCategory("city",city_id)%>
							<option value='0' <%If city_id=0 Then Response.Write("selected")%>>其他</option>
							</select>
                        </div>
						 <div class="field subscribe">
						  	<label for="signup-password-confirm"></label>
                            <input tabindex="3" type="checkbox" value="1" name="subscribe" id="subscribe" class="f-check" <%If subscribe = "1" Then response.Write("checked")%> />&nbsp;&nbsp;&nbsp;
                            短信订阅每日最新团购信息
                        </div>
						
						
                        <div class="act">
                            <input type="submit" class="formbutton" id="signup-submit" name="commit" value="注册">
                        </div>
                    </form>
                </div>
					</div>
					<div class="login-bottom"></div>
			</div>
			<%Else%>
			<!---->
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="success"><h2>您的账号注册成功了！</h2> </div>
						<div class="sect">
							<p class="error-tip">
							您的手机号为"<%=mobile%>"<br>
							您的初始密码为：<font color="#ff0000"><%=password%></font><br>
							请尽快修改初始密码&nbsp;<a href="../settings/index.asp">进入修改</a>&nbsp;!
							</p>
						</div>
					</div>
					<div class="login-bottom"></div>
			</div>
			<%End If%>
			<!---->
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
<%If opFlag<>"showpassword" Then %>
<SCRIPT language=javascript type=text/javascript>                    
 var secs = 60;
 var wait = secs * 1000;
 document.signupForm.btnSend.value = "请等待 [" + secs + "]";
 document.signupForm.btnSend.disabled = true;

 for(i = 1; i <= secs; i++)
 {
	   window.setTimeout("Update(" + i + ")", i * 1000);
 }
 window.setTimeout("Timer()", wait);


 
 function Update(num)
 {
	   if(num != secs)
	   {
			 printnr = (wait / 1000) - num;
			 document.signupForm.btnSend.value = "请等待 [" + printnr + "]";
	   }
 }
 
 function Timer()
 {
	   document.signupForm.btnSend.disabled = false;
	   document.signupForm.btnSend.value = " 重新获取验证码 ";
 }

</SCRIPT>
<%End If%>

<!--#include file="../../common/inc/footer_user.asp"-->
