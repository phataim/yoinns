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
<title><%=SiteConfig("SiteName")%>-��֤����</title>

<div class="blank20"></div>
<div id="box">	
	<div class="cf">		
		<div id="credit">
			<div class="login-box" id="content">
					
					<div class="login-top"></div>
					
					
					<div class="login-content">
						<div class="success"><h2>����֤����</h2> </div>
						<div class="sect">
							<p class="error-tip">
							���ѳɹ�ע���ˡ�<%=SiteConfig("SiteShortName")%>��,�뵽������ע��������е���������ע�ᣡ
							<br>
							�����δ�յ���֤�ʼ����뵽<a href="remail.asp">����</a>���·�����֤�ʼ���
							</p>
						</div>
					</div>
					<div class="login-bottom"></div>
			</div>
		</div>
	</div>
</div>

<!--#include file="../../common/inc/footer_user.asp"-->