<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->


<%
On Error Resume Next
Dim Action

	Action = Request.Form("act")
	Select Case Action
		Case "pay"
			Call Pay()
		Case Else
			Call Main()
	End Select
	
	Sub Main()
		
		
		
	End Sub

%>

<!--#include file="../../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=SiteConfig("SiteName")%>-验证邮箱</title>

<div class="blank20"></div>
<div id="box">	
	<div class="cf">		
		<div id="credit">
			<div class="login-box" id="content">
					
					<div class="login-top"></div>
					
					
					<div class="login-content">
						<div class="success"><h2>请验证邮箱</h2> </div>
						<div class="sect">
							<p class="error-tip">
							您已成功注册了“<%=SiteConfig("SiteShortName")%>”,请到您申请注册的邮箱中点击链接完成注册！
							<br>
							如果您未收到验证邮件，请到<a href="remail.asp">这里</a>重新发送验证邮件！
							</p>
						</div>
					</div>
					<div class="login-bottom"></div>
			</div>
		</div>
	</div>
</div>

<!--#include file="../../common/inc/footer_user.asp"-->