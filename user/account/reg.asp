<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->

<%
Dim Action
Dim Sql,Rs
Dim userid,validcode
Dim msgStr

	Action = Request.QueryString("act")
	Select Case Action
		Case "save"
			Call SaveRecord()
		Case Else
				Call Main()
	End Select
	
	
	Sub Main()	
		userid = Dream3CLS.ChkNumeric(Request("id"))
		validcode = Dream3CLS.RSQL("code")
		Sql = "Select * From T_User Where id="&Userid
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			msgStr = "���ύ�����ӷǷ�������û��ѱ�ɾ����"
			Exit Sub
		End If
		If Rs("enabled")="Y" Then
			msgStr = "����������ͨ����֤�������ظ��ύ��"
			Exit Sub
		End If
		Rs.Close
		Sql = "Select * From T_User Where id="&Userid&" and validcode='"&validcode&"'"

		Rs.open Sql,conn,1,2
		If Rs.EOF Then
			msgStr = "���ύ�����������������Ա��ϵ��"
			Exit Sub
		End If
		Rs("enabled") = "Y"
		email = Rs("email")
		Rs.Update
		Rs.Close
		
		'ͬʱ���¶��ĵ��ʼ�
		Sql = "Select * From T_Subscribe Where email='"&email&"' and enabled='N'"

		Rs.open Sql,conn,1,2
		If Not Rs.EOF Then
			Rs("enabled") = "Y"
			Rs.Update
		End If
		
		Rs.Close
		Set Rs = Nothing
		
		msgStr = "��ϲ�������ѳɹ�ͨ����֤,���¼��"
		
	End Sub
%>
<%
G_Title_Content = SiteConfig("SiteName")&"-"&SiteConfig("SiteTitle")&" ������֤"
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div id="box">	
	<div class="cf">		
		<div id="recent-deals">
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>������֤</h2></div>
						<div class="sect">
							<div class="succ">
							<%=msgStr%>
							</div>
						</div>

					</div>
					<div class="login-bottom"></div>
			</div>
			<div id="sidebar">
				<div id="sidebar_mail" class="want_know">
					<!--#include file="../../common/inc/mail_right.asp"-->
				</div>
			</div>
		</div>
	</div>	
</div>

<!--#include file="../../common/inc/footer_user.asp"-->
