<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/api/cls_email.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<%
Dim Action
Dim SelectMailMode,SmtpServerMail,SmtpServer,SmtpServerUserName,SmtpServerPassword

	Action = Request.QueryString("act")
	Select Case Action
		    Case "save"
		   		Call SaveMailSetting()
			Case "testSendMail"
		   		Call TestSendMail()
		    Case Else
				Call Main()
	End Select
	
	Sub TestSendMail
		serviceEmail = Dream3CLS.RSQL("serviceEmail")
		topic = "�������������Ƿ���ȷ"
		mailbody = "��ϲ�������ܿ���������˵������������������"
		If cmEmail.ErrCode = 0 Then

			cmEmail.SendMail serviceEmail,topic,mailbody

			If cmEmail.Count>0 Then
				gMsgArr = "���ͳɹ����������䣡"
				gMsgFlag = "S"
			Else
				'gMsgArr = cmEmail.Description
				gMsgArr = "����ʧ�ܣ��������ã�"
				gMsgFlag = "E"
			End If
		Else
			gMsgArr = "����ϵͳ�����ʼ�����ʧ��,ԭ��"&cmEmail.ErrMsg
			gMsgFlag = "E"
		End If
		
		Call Main()
		
	End Sub
	
	Sub SaveMailSetting()
	
		SelectMailMode =  Request.Form("SelectMailMode")
		SmtpServerMail=  Request.Form("SmtpServerMail")
		SmtpServer=  Request.Form("SmtpServer")
		SmtpServerUserName=  Request.Form("SmtpServerUserName")
		SmtpServerPassword=  Request.Form("SmtpServerPassword")

		Rs.Open "[T_Config]",Conn,1,3
	
		Set XMLDOM=Server.CreateObject("Microsoft.XMLDOM")
		XMLDOM.loadxml("<Dream3>"&Rs("SiteSettingsXML")&"</Dream3>")
		SiteSettingsXMLStrings=""
		Set objNodes = XMLDOM.documentElement.ChildNodes
		Set objRoot = XMLDOM.documentElement
		for each ho in Request.Form
			objRoot.SelectSingleNode(ho).text = ""&server.HTMLEncode(Request(""&ho&""))&""
		next
		for each element in objNodes	
			SiteSettingsXMLStrings=SiteSettingsXMLStrings&"<"&element.nodename&">"&element.text&"</"&element.nodename&">"&vbCrlf
		next
		
		Set XMLDOM=nothing
		Rs("SiteSettingsXML")=SiteSettingsXMLStrings
		Rs.update
		Rs.close
		'���¼���ȫ�ֱ���������ʾ
		'Call loadConfig()
		Dream3CLS.ReloadConfigCache()
		
		gMsgFlag = "S"
		
	End Sub

	
	Sub Main()		

		SelectMailMode = Dream3CLS.SiteConfig("SelectMailMode")
		SmtpServerMail= Dream3CLS.SiteConfig("SmtpServerMail")
		SmtpServer= Dream3CLS.SiteConfig("SmtpServer")
		SmtpServerUserName= Dream3CLS.SiteConfig("SmtpServerUserName")
		SmtpServerPassword= Dream3CLS.SiteConfig("SmtpServerPassword")

	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">�ʼ�����</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">

                <div class="sect">
                    <form method="post" action="mail.asp?act=save">
						<div class="wholetip clear"><h3>1����������
</h3></div>
                        <div class="field">
                            <label>�����ʼ����</label>
                            <select name="SelectMailMode">
							    <option value="1" <%If SelectMailMode="1" then response.Write("selected") %>>JMAIL</option>
								<option value="2" <%If SelectMailMode="2" then response.Write("selected") %>>CDONTS</option>
								<option value="3" <%If SelectMailMode="3" then response.Write("selected") %>>ASPEMAIL</option>
								<option value="4" <%If SelectMailMode="4" then response.Write("selected") %>>CDO</option>
                            </select>
                        </div>
						<div class="field">
                            <label>������Email��ַ</label>
                            <input type="text" name="SmtpServerMail" value="<%=SmtpServerMail%>" class="f-input" size="30">
                        </div>
                        <div class="field">
                            <label>SMTP ������</label>
                            <input type="text" name="SmtpServer" value="<%=SmtpServer%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>SMTP ������ע������</label>
                            <input type="text" name="SmtpServerUserName" value="<%=SmtpServerUserName%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>SMTP ����������</label>
                            <input type="text" name="SmtpServerPassword" value="<%=SmtpServerPassword%>" class="f-input" size="30">
                        </div>
						<div class="act">
                            <input type="submit" class="formbutton" value="����">
                        </div>
                    </form>
					<form method="post" action="mail.asp?act=testSendMail">
						<div class="wholetip clear" style="display:none"><h3>2�����������Ƿ���ȷ</h3></div>
                        
						<div class="field">
                            <label>���Ĳ��Խ��������ַ</label>
                            <input type="text" name="serviceEmail" value="<%=Dream3CLS.SiteConfig("ServiceEmail")%>" class="f-input" size="30">
                        </div>
						<div class="act">
                            <input type="submit" class="formbutton" value="���Լ��Ĳ������䷢����Email">
                        </div>
                    </form>
                </div>
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->