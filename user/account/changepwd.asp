<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/md5.asp"-->
<%
Dim Action
Dim username
Dim opFlag,validcode,userid,password,confirm
Dim canModify

loginip = Request.ServerVariables("REMOTE_ADDR")

	Action = Request.QueryString("act")
	Select Case Action
		Case "chgpwd"
			Call ChangePassword()
		Case Else
				Call Main()
	End Select
	
	Sub ChangePassword()
		canModify = true
		username =  Dream3CLS.RParam("username")
		userid =  Dream3CLS.ChkNumeric(Request("userid"))
		validcode=  Dream3CLS.RSQL("validcode")
		password=  Dream3CLS.RParam("password")
		confirm=  Dream3CLS.RParam("confirm")

		'validate Form
		If password = "" Then
			gMsgArr = gMsgArr&"|密码不能为空！"
		End If
		
		If password <> "" and (password<>confirm) Then
			gMsgArr = gMsgArr&"|密码和确认密码不符！"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
	
		'判断是否已经存在记录
		Sql = "select * from T_User Where id="&userid&" and validcode='"&validcode&"'"

		Rs.open Sql,conn,1,2
		
		'如果不存在账号，则直接显示发送成功
		If  Rs.EOF Then
			gMsgArr = gMsgArr&"|请不要手工修改地址！"
			gMsgFlag = "E"
			Exit Sub
		Else
			Rs("password") = md5(password)
			Rs.Update
			opFlag = "showresult"
		End If
		
		Rs.Close
		
	End Sub

	
	Sub Main()	
		canModify = true
		userid =  Dream3CLS.ChkNumeric(Request.QueryString("id"))
		validcode=  Dream3CLS.RParam("code")
		Sql = "Select * From T_User Where id="&userid
		Rs.Open sql,conn,1,2
		If Rs.EOF Then
			gMsgArr = gMsgArr&"该账号已被删除!"
			gMsgFlag = "E"
			canModify = false
			Exit Sub
		End If

		If Rs("validcode") <> validcode Then
			gMsgArr = gMsgArr&"您输入的地址有误，请与管理员联系!"
			gMsgFlag = "E"
			canModify = false
			Exit Sub
		End if
		username = Rs("username")
		Rs.Close
		Set Rs = Nothing
	End Sub
	
%>
<!--#include file="../../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<div id="box">	
	<div class="cf">		
		<div id="login">
			<%
			If opFlag <> "showresult" Then
			%>
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>忘记密码</h2>&nbsp;&nbsp;&nbsp;<span>（第二步：更改密码）</span></div>
						<div class="sect">
							<form class="validator" method="post" action="?act=chgpwd" id="login-user-form">
								<div class="field email">
									<label for="login-email-address">Email／用户名</label>
									 <input type="text" size="30" name="username" id="username" class="f-input readonly" value="<%=username%>" readonly/>
								</div>
								<div class="field password">
									<label for="signup-password">密码</label>
									<input type="password" size="30" name="password" id="signup-password" class="f-input" />
									<span class="hint">为了您的帐号安全，建议密码最少设置为6个字符以上</span>
								</div>
								<div class="field password">
									<label for="confirm">确认密码</label>
									<input type="password" size="30" name="confirm" id="confirm" class="f-input" />
								</div>
								<div class="act">
									<input type="hidden" name="userid" value="<%=userid%>"/>
									<input type="hidden" name="validcode" value="<%=validcode%>"/>
									<input type="submit" class="formbutton" id="login-submit" name="commit" value="下一步" <%If Not canModify Then%>disabled="true"<%End If%> >
								</div>
							</form>
						</div>
					</div>
					<div class="login-bottom"></div>
			</div>
			<%Else%>
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="success"><h2>密码修改成功！</h2> </div>
						<div class="sect">
							<p class="error-tip">
							您的密码已成功修改，请用新密码登录<%=SiteConfig("SiteShortName")%>！
							</p>
						</div>
					</div>

					<div class="login-bottom"></div>
			</div>
			<%End If%>
			
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