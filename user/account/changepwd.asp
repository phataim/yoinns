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
			gMsgArr = gMsgArr&"|���벻��Ϊ�գ�"
		End If
		
		If password <> "" and (password<>confirm) Then
			gMsgArr = gMsgArr&"|�����ȷ�����벻����"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
	
		'�ж��Ƿ��Ѿ����ڼ�¼
		Sql = "select * from T_User Where id="&userid&" and validcode='"&validcode&"'"

		Rs.open Sql,conn,1,2
		
		'����������˺ţ���ֱ����ʾ���ͳɹ�
		If  Rs.EOF Then
			gMsgArr = gMsgArr&"|�벻Ҫ�ֹ��޸ĵ�ַ��"
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
			gMsgArr = gMsgArr&"���˺��ѱ�ɾ��!"
			gMsgFlag = "E"
			canModify = false
			Exit Sub
		End If

		If Rs("validcode") <> validcode Then
			gMsgArr = gMsgArr&"������ĵ�ַ�����������Ա��ϵ!"
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
						<div class="head"><h2>��������</h2>&nbsp;&nbsp;&nbsp;<span>���ڶ������������룩</span></div>
						<div class="sect">
							<form class="validator" method="post" action="?act=chgpwd" id="login-user-form">
								<div class="field email">
									<label for="login-email-address">Email���û���</label>
									 <input type="text" size="30" name="username" id="username" class="f-input readonly" value="<%=username%>" readonly/>
								</div>
								<div class="field password">
									<label for="signup-password">����</label>
									<input type="password" size="30" name="password" id="signup-password" class="f-input" />
									<span class="hint">Ϊ�������ʺŰ�ȫ������������������Ϊ6���ַ�����</span>
								</div>
								<div class="field password">
									<label for="confirm">ȷ������</label>
									<input type="password" size="30" name="confirm" id="confirm" class="f-input" />
								</div>
								<div class="act">
									<input type="hidden" name="userid" value="<%=userid%>"/>
									<input type="hidden" name="validcode" value="<%=validcode%>"/>
									<input type="submit" class="formbutton" id="login-submit" name="commit" value="��һ��" <%If Not canModify Then%>disabled="true"<%End If%> >
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
						<div class="success"><h2>�����޸ĳɹ���</h2> </div>
						<div class="sect">
							<p class="error-tip">
							���������ѳɹ��޸ģ������������¼<%=SiteConfig("SiteShortName")%>��
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
							<h2>��û��<%=SiteConfig("SiteShortName")%>�˻���</h2>
							<p>����<a href="signup.asp">ע��</a>��</p>
						</div>
					</div>
					<div class="sbox-bottom"></div>
				</div>
			</div>
		</div>
	</div>	
</div>

<!--#include file="../../common/inc/footer_user.asp"-->