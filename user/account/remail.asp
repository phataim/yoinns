<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../../common/api/cls_email.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<!--#include file="../../common/api/cls_sms.asp"-->
<!--#include file="../../common/api/cls_xml.asp"-->
<%
Dim Action
Dim username,email,password,confirm,city_id,mobile,subscribe,userid,manager,validcode

	Action = Request.QueryString("act")
	Select Case Action
		Case "save"
			Call SaveRecord()
		Case Else
			Call Main()
	End Select
	
	Sub SaveRecord()
	
		email=  Dream3CLS.RParam("email")

		'validate Form
		If email = "" Then
			gMsgArr = "�ʼ���ַ����Ϊ�գ�"
		End If
		
		If email<>"" and not Dream3CLS.IsValidEmail(email) Then
			gMsgArr = gMsgArr&"|Email���Ϸ���"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		
		'�ж��Ƿ��Ѿ����ڼ�¼
		Sql = "select * from T_User Where email='"&email&"'"
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Rs.EOF Then
			gMsgArr = "��Email��δ��ע�ᣡ"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If Rs("enabled") = "Y" Then
			gMsgArr = "��Email��ͨ����֤��"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		validcode = Rs("validcode")
		username = Rs("username")
		userid = Rs("id")
		
		'��ʼ�����ʼ�
		Call SendRegMail()
		If gMsgFlag = "E" Then
			Exit Sub
		Else
			response.Redirect("signupresult.asp")
			response.End()
		End If
		
		
		gMsgFlag = "S"
		
	End Sub
	
	Sub SendRegMail()
		Dim HtmlTitle,HtmlContent,regConfirmUrl
		'title
		HtmlTitle = Dream3Tpl.LoadTemplate("mail_reg_title")
		HtmlTitle = Replace(HtmlTitle, "{$SiteShortName}", SiteConfig("SiteShortName"))
		'content
		HtmlContent = Dream3Tpl.LoadTemplate("mail_reg_content")
		HtmlContent = Replace(HtmlContent, "{$SiteName}", SiteConfig("SiteName"))
		HtmlContent = Replace(HtmlContent, "{$UserName}", username)
		regConfirmUrl = GetSiteUrl() & "/user/account/reg.asp?id="&userid&"&code="&validcode
		HtmlContent = Replace(HtmlContent, "{$Reg_Confirm_Url}",regConfirmUrl )
		
		cmEmail.SendMail email,HtmlTitle,HtmlContent
		If cmEmail.Count>0 Then
			'���ͳɹ�
		Else
			gMsgArr = "��֤�ʼ�����ʧ�ܣ��������Ա��ϵ��"
			gMsgFlag = "E"
		End If

	End Sub
	
		Sub SendSMS()
		If Cint(SiteConfig("SendRegSMS")) <> 1  Then Exit Sub
		If IsNull(mobile) Or Len(mobile) <=0 Then Exit Sub
		content = GetSMSRegSuccessContent()

		result = Dream3SMS.SendSMS(mobile,content)

	End Sub
	
	Function GetSMSRegSuccessContent()
		
		Dim HtmlSMS
		HtmlSMS = Dream3Tpl.LoadTemplate("sms_signup_success_content")
		HtmlSMS = Replace(HtmlSMS, "{$SiteName}",SiteConfig("SiteName"))
		HtmlSMS = Replace(HtmlSMS, "{$UserName}",username)
		GetSMSRegSuccessContent = HtmlSMS
	End Function
	
	Sub Main()	
		subscribe = "1"
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=SiteConfig("SiteName")%>-���·���ע���ʼ�</title>

<div id="box">	
	<div class="cf">		
		<div id="login">
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>���·���ע��Email</h2><span>&nbsp;���� <a href="login.asp">��¼</a></span></div>
						<div class="sect">
                    <form class="validator" action="?act=save" method="post" id="signup-user-form">
                        <div class="field email">
                            <label for="signup-email-address">Email</label>
                            <input type="text" size="30" name="email" id="email" class="f-input" value="<%=email%>"/> 
                            <span class="hint">���ǻ������д���������·���һ��ע����֤Email!</span>
                        </div>
                   
						
						
                        <div class="act">
                            <input type="submit" class="formbutton" id="signup-submit" name="commit" value="����">
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

<!--#include file="../../common/inc/footer_user.asp"-->
