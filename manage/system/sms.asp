<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_xml.asp"-->
<!--#include file="../../common/api/cls_sms.asp"-->
<!--#include file="../../common/api/MD5.asp"-->
<%
Dim Action
Dim  SMSUserID, SMSUserPwd,NormalSMSUserPwd,SMSUrl
Dim  balance,smsbalance

	Action = Request.QueryString("act")
	Select Case Action
		   Case "save"
		   		Call SaveRecord()
		   Case Else
				Call Main()
	End Select
	
	Sub SaveRecord()

		SMSUserID =  Request.Form("SMSUserID")
		'SMSUserPwd =  Request.Form("SMSUserPwd")
		NormalSMSUserPwd=  Request.Form("NormalSMSUserPwd")
		SMSUrl=  Request.Form("SMSUrl")


		Rs.Open "[T_Config]",Conn,1,3
		
	    Set XMLDOM=Server.CreateObject("Microsoft.XMLDOM")
		XMLDOM.loadxml("<Dream3>"&Rs("SiteSettingsXML")&"</Dream3>")
		SiteSettingsXMLStrings=""
		Set objNodes = XMLDOM.documentElement.ChildNodes
		Set objRoot = XMLDOM.documentElement
		'for each ho in Request.Form
			'objRoot.SelectSingleNode(ho).text = ""&server.HTMLEncode(Request(""&ho&""))&""
		'next
		
		objRoot.SelectSingleNode("SMSUserID").text = SMSUserID
		
		If NormalSMSUserPwd <> "" Then
			objRoot.SelectSingleNode("SMSUserPwd").text = MD5(NormalSMSUserPwd)
		End If
		
		for each element in objNodes	
			SiteSettingsXMLStrings=SiteSettingsXMLStrings&"<"&element.nodename&">"&element.text&"</"&element.nodename&">"&vbCrlf
		next
		
		Set XMLDOM=nothing
		Rs("SiteSettingsXML")=SiteSettingsXMLStrings
		Rs.update
		Rs.close
		Set Rs = Nothing
		
		'重新加载全局变量用于显示
		'Call loadConfig()
		Dream3CLS.ReloadConfigCache()
		
		gMsgFlag = "S"
		
		Call Main()
		
	End Sub

	
	Sub Main()		
		
		SMSUserID = Dream3CLS.SiteConfig("SMSUserID")
		SMSUserPwd =  Dream3CLS.SiteConfig("SMSUserPwd")
		SMSUrl = Dream3CLS.SiteConfig("SMSUrl")
		
		'If Not isnumeric(smsbalance) then
			'balance = "<B><font color='#FF0000'>您的账户设置不正确</font></B>"
		'Else
			'balance = "您的账户还有<B><font color='#FF0000'>"&smsbalance&"</font></B>条短信"
		'End If
		
	End Sub
%>

<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">短信设置</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">
					
				<div class="sect">
					
					<form name="form" method="post"  action="sms.asp?act=save">
					
					<div class="field">
						<div class="wholetip clear"><h3>1、短信配置</h3></div>
                     
                        <div class="field">
                            <label>短信用户</label>
                            <input type="text" name="SMSUserID" value="<%=SMSUserID%>" class="f-input" size="30" style="width: 150px;">&nbsp;&nbsp;&nbsp;骏商网络增值平台(<a href="http://www.dream3.cn/sms/" target="_blank">www.dream3.cn/sms/</a>)
                        </div>
                        <div class="field">
                            <label>短信密码</label>
                            <input type="text" name="NormalSMSUserPwd" value="<%=NormalSMSUserPwd%>" style="width: 150px;" class="f-input"  size="30">&nbsp;&nbsp;&nbsp;系统默认不显示密码，如果要修改密码，请在密码框中输入后点击保存按钮
                        </div>
						
						<div class="field">
                            <label>短信发送地址</label>
                            <input type="text" name="SMSUserID" value="<%=SMSUrl%>" class="f-input" size="30" style="width: 150px;">&nbsp;&nbsp;&nbsp;请不要随便修改
                        </div>
						
						<div class="wholetip clear" style="display:none"><h3>2、短信余额</h3></div>
                     
                        <div class="field"  style="display:none">
                            <label>短信余额</label>
                            <%=balance%>
                        </div>
                        

						
						<div class="act">
							<input type="submit" class="formbutton"  value="保存">
						</div>
                	</div>
				</form>
				
				
            </div>
            
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->