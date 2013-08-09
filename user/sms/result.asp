<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<%
Dim Action
Dim mobile,flag,cityname

	Action = Request.QueryString("act")
	Select Case Action
		Case "checkreg"
			Call CheckReg()
		Case Else
			Call Main()
	End Select

	
	Sub Main()	
		mobile =  Dream3CLS.RSQL("mobile")
		flag = Dream3CLS.RParam("flag")
		Sql = "Select * From T_SMSSubscribe Where mobile='"&mobile&"'"
		Rs.Open Sql,conn,1,1
		If Not Rs.EOF Then
			cityname = Dream3Team.getCityName(Rs("city_id"),"全部")
		End If
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<div id="box">	
	<div class="cf">		
		<div id="login">
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<%If flag = "success" then%>
					<div class="login-content">
						<div class="success"><h2>您短信订阅成功了！</h2> </div>
						<div class="sect">
							<p class="error-tip">
							您的手机号<%=mobile%>已成功订阅了"<%=SiteConfig("SiteName")%>""<%=cityname%>"的短信
							</p>
						</div>
					</div>
					<%End If%>
					<%If flag = "unreg" then%>
					<div class="login-content">
						<div class="success"><h2>您短信订阅已成功取消了！</h2> </div>
						<div class="sect">
							<p class="error-tip">
							您的手机号<%=mobile%>已成功取消订阅了"<%=SiteConfig("SiteName")%>"的短信
							</p>
						</div>
					</div>
					<%End If%>
					
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