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
			gMsgArr = gMsgArr&"|�ֻ�������"
		End If
		If smssecret = "" Then
			gMsgArr = gMsgArr&"|������6λ�ֻ���֤�룡"
		End If		
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		Sql = "select count(id) from T_User where enabled='Y'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		userCount = Rs(0)
		
		If Rs.state =1 Then Rs.Close
		'�ж��Ƿ��Ѿ����ڼ�¼
		Sql = "select * from T_User Where mobile='"&mobile&"'"
		Rs.open Sql,conn,1,2
		
		If  Rs.EOF Then
			gMsgArr = "�벻Ҫ�޸������ַ��"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If Rs("enabled") = "Y" Then
			gMsgArr = "���ֻ��Ѿ�ͨ�����룡"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		If smssecret <> Rs("validcode") Then
			gMsgArr = "���������֤�벻��ȷ��"
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
		
		'�õ���ǰ�û���ID
		Sql = "Select id From T_User Where mobile ='"&mobile&"'"
		Set Rs = Dream3CLS.Exec(Sql)
		userid = Rs(0)
		
		
		'�������ID��Ϊ�գ����¼�����¼
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
			
			'���cookies
			Response.Cookies(DREAM3C)("_InviteUserID") =  ""
			
		End If
		
		If Rs.state = 1 Then Rs.Close
		If CStr(subscribe) = "1" Then
			'�ж��Ƿ��Ѿ����ڼ�¼
			Sql = "select * from T_SMSSubscribe Where mobile='"&mobile&"'"
			
			Rs.open Sql,conn,1,2
			'�����������д��
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
		'Dream3CLS.showMsg "����ɹ�","S","index.asp"
		'���Session����ʱ������cookies��
		
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
<title><%=SiteConfig("SiteName")%>-�û�ע��</title>

<div id="box">	
	<div class="cf">		
		<div id="login">
			<!---->
			<%If opFlag<>"showpassword" Then %>
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>ע��</h2><span>&nbsp;���� <a href="#">��¼</a></span></div>
						<div class="sect">
                    <form class="validator" action="?act=save" method="post" id="signupForm" name="signupForm">
                        <div class="field">
                            <label for="signup-password-confirm">�����ֻ�����</label>
                            <input style="display:none" type="text" size="30" name="mobile" id="mobile" class="number" value="<%=mobile%>" readonly="true"/>
							<h1><%=mobile%></h1>
							
                        </div>
						<div class="field">
                            <label for="signup-password-confirm">�ֻ���֤��</label>
                            <input type="text" size="30" name="smssecret" id="smssecret" class="number" value="<%=smssecret%>"/><span class="inputtip">��������ֻ����յĶ����ϻ�ȡ6λ��֤��</span>
							<input type="button" class="formbutton" id="btnSend" name="btnSend" value="���»�ȡ��֤��" onclick="history.back(-1);">
                        </div>
						<div class="field city">
                            <label id="enter-address-city-label" for="signup-city">���ڳ���</label>
							<select name="city_id" class="f-city">
							<%=Dream3Team.getCategory("city",city_id)%>
							<option value='0' <%If city_id=0 Then Response.Write("selected")%>>����</option>
							</select>
                        </div>
						 <div class="field subscribe">
						  	<label for="signup-password-confirm"></label>
                            <input tabindex="3" type="checkbox" value="1" name="subscribe" id="subscribe" class="f-check" <%If subscribe = "1" Then response.Write("checked")%> />&nbsp;&nbsp;&nbsp;
                            ���Ŷ���ÿ�������Ź���Ϣ
                        </div>
						
						
                        <div class="act">
                            <input type="submit" class="formbutton" id="signup-submit" name="commit" value="ע��">
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
						<div class="success"><h2>�����˺�ע��ɹ��ˣ�</h2> </div>
						<div class="sect">
							<p class="error-tip">
							�����ֻ���Ϊ"<%=mobile%>"<br>
							���ĳ�ʼ����Ϊ��<font color="#ff0000"><%=password%></font><br>
							�뾡���޸ĳ�ʼ����&nbsp;<a href="../settings/index.asp">�����޸�</a>&nbsp;!
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
							<h2>����<%=SiteConfig("SiteShortName")%>�˻���</h2>
							<p>��ֱ��<a href="login.asp">��¼</a>��</p>
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
 document.signupForm.btnSend.value = "��ȴ� [" + secs + "]";
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
			 document.signupForm.btnSend.value = "��ȴ� [" + printnr + "]";
	   }
 }
 
 function Timer()
 {
	   document.signupForm.btnSend.disabled = false;
	   document.signupForm.btnSend.value = " ���»�ȡ��֤�� ";
 }

</SCRIPT>
<%End If%>

<!--#include file="../../common/inc/footer_user.asp"-->
