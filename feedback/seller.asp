<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->

<%
Dim Action
Dim Sql,Rs
Dim userid,contact,username,content

Action = Request.QueryString("act")
	Select Case Action
		Case "save"
			Call SaveRecord()
		Case Else
			Call Main()
	End Select
	
	Sub SaveRecord()
		username =  Dream3CLS.RParam("username")
		contact =  Dream3CLS.RParam("contact")
		content=  Dream3CLS.RParam("content")
		
		'validate Form
		If username = "" Then
			gMsgArr = "�ƺ�����Ϊ�գ�"
		End If
		
		If contact = "" Then
			gMsgArr = gMsgArr&"|��ϵ��ʽ����Ϊ�գ�"
		End If
		
		If content = "" Then
			gMsgArr = gMsgArr&"|�Ź���Ϣ����Ϊ�գ�"
		End If
		
		If Len(content) > 2000 Then
			gMsgArr = gMsgArr&"|�Ź���Ϣ���ܳ���2000�ַ���"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
	

		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_Feedback "
		
		Rs.open Sql,conn,1,2
		Rs.AddNew
		Rs("title") 	= username
		Rs("contact") 	= contact
		Rs("content") 	= content
		Rs("classifier") = "seller"
		Rs("user_id") = 0
		Rs("create_time")= Now()
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		Response.Redirect("success.asp")
	End Sub

	
	Sub Main()	
		userid = Dream3CLS.ChkNumeric(Request.Cookies(DREAM3C)("_UserID"))
		If userid <> 0 Then
			Sql = "Select username,email From T_User Where id="&userid
			Set Rs = Dream3CLS.Exec(Sql)
			If Not Rs.EOF Then
				username = Rs("Username")
				contact = Rs("email")
			End If
		End If
	End Sub


%>
<%
G_Title_Content = "�ṩ�Ź���Ϣ|"&SiteConfig("SiteName")&"-"&SiteConfig("SiteTitle")
%>
<!--#include file="../common/inc/header_user.asp"-->
<div id="box">	
	<div class="cf">		
		<div id="recent-deals">
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>�ṩ�Ź���Ϣ</h2></div>
						
						<div class="sect">
							<p class="notice">�ر�ӭ�����̼ҡ��Ա��������ṩ�Ź���Ϣ��</p>
							<form class="validator" action="seller.asp?act=save" method="post" id="feedback-user-form">
								<div class="field fullname">
									<label for="feedback-fullname">���ĳƺ�</label>
									<input type="text"  class="f-input" id="feedback-fullname" name="username" size="30" value="<%=username%>">
								</div> 
								<div class="field email">
									<label for="feedback-email-address">��ϵ��ʽ</label>
									<input type="text" value="<%=contact%>" class="f-input" id="feedback-email-address" name="contact" size="30">
									<span class="hint">�����������ֻ���QQ�Ż����䣬������ϵ</span>
								</div>
								<div class="field suggest">
									<label for="feedback-suggest">�Ź���Ϣ</label>
									<textarea class="f-textarea" id="feedback-suggest" name="content" rows="5" cols="30"><%=content%></textarea>
								</div>
								<div class="clear"></div>
								<div class="act">
									<input type="submit" class="formbutton" id="feedback-submit" name="commit" value="�ύ">
								</div>
							</form>
						</div>
						
					</div>
					<div class="login-bottom"></div>
			</div>
			<div id="sidebar">
				<div id="sidebar_mail" class="want_know">
					<!--#include file="../common/inc/mail_right.asp"-->
				</div>
			</div>
		</div>
	</div>	
</div>


<!--#include file="../common/inc/footer_user.asp"-->
