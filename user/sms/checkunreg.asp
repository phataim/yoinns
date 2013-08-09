<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<%
Dim Action
Dim mobile,smssecret

	Action = Request.QueryString("act")
	Select Case Action
		Case "checkunreg"
			Call CheckUnReg()
		Case Else
			Call Main()
	End Select
	
	Sub CheckUnReg()
	
		mobile =  Dream3CLS.RSQL("mobile")
		smssecret = Dream3CLs.RSQL("smssecret")
		
		If smssecret = "" Then
			gMsgArr = gMsgArr&"|请输入手机验证码！"
			gMsgFlag = "E"
			Exit Sub
		End If
		
		
		'判断是否已经存在记录
		Sql = "select * from T_SMSSubscribe Where mobile='"&mobile&"'"
		
		Rs.open Sql,conn,1,2
		If  Rs.EOF Then
			gMsgArr = "您提交的手机号码不存在！"
			gMsgFlag = "E"
			Exit Sub
		Elseif Rs("enabled") = "Y" Then
			If Rs("secret") = smssecret Then
				Rs("enabled") = "N"
				Rs.Update
				Rs.Close
				Set Rs = Nothing
				Response.Redirect("result.asp?flag=unreg&mobile="&mobile)
			Else
				gMsgArr = "您提交的手机验证码不正确！"
				gMsgFlag = "E"
				Exit Sub
			End If
		Elseif  Rs("enabled") = "N" Then
			gMsgArr = "您已经取消订阅了!"&SiteConfig("SiteShortName")&"短信服务，无须重复提交！"
			gMsgFlag = "E"
			Exit Sub
		End If	
		
	End Sub

	
	Sub Main()	
		mobile =  Dream3CLS.RSQL("mobile")
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
						<div class="head"><h2>输入手机验证码</h2>(您正在申请取消短信订阅的手机为：<%=mobile%>)</div>
						<div class="sect">
							<form class="validator" method="post" action="?act=checkunreg" id="login-user-form">
								<div class="field email">
									<label for="login-email-address">手机号</label>
									 <input type="text" size="30" name="showmobile" id="showmobile" readonly="true" class="f-input" value="<%=mobile%>"/>
								</div>
							    
								<div class="field email">
									<label for="login-email-address">手机验证码</label>
									 <input name="smssecret" type="text" class="logininput" id="smssecret" size="6" maxlength="6" />
		 						 <span id="img_checkcode" >请输入6位手机验证码</span>
								</div>
								
								<div class="act">
									<input type="hidden" id="mobile" name="mobile" value="<%=mobile%>"/>
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

<!--#include file="../../common/inc/footer_user.asp"-->