<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<%
Dim Action
Dim IsForum,IsDisplayFailTeam,IsDisplayQuestion,IsUseSMS,IsMailVaild,IsForceMobile,IPLimit,SendRegSMS
Dim RegType,OrderOKSMS,ShowClassify

	Action = Request.QueryString("act")
	Select Case Action
		   Case "save"
		   		Call save()
		   Case Else
				Call Main()
	End Select
	
	Sub Save()
		IsForum =  Request.Form("IsForum")
		IsDisplayFailTeam=  Request.Form("IsDisplayFailTeam")
		IsDisplayQuestion=  Request.Form("IsDisplayQuestion")
		IsUseSMS=  Request.Form("IsUseSMS")
		IsMailVaild=  Request.Form("IsMailVaild")
		IsForceMobile=  Request.Form("IsForceMobile")	
		IPLimit = 		Request.Form("IPLimit")	
		RegType = 		Request.Form("RegType")	
		OrderOKSMS = 		Request.Form("OrderOKSMS")
		SendRegSMS  = 		Request.Form("SendRegSMS")	
		ShowClassify  = 		Request.Form("ShowClassify")	
	
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
		IsForum = Dream3CLS.SiteConfig("IsForum")
		IsDisplayFailTeam= Dream3CLS.SiteConfig("IsDisplayFailTeam")
		IsDisplayQuestion= Dream3CLS.SiteConfig("IsDisplayQuestion")
		IsUseSMS= Dream3CLS.SiteConfig("IsUseSMS")
		IsMailVaild= Dream3CLS.SiteConfig("IsMailVaild")
		IsForceMobile= Dream3CLS.SiteConfig("IsForceMobile")
		IPLimit = Dream3CLS.SiteConfig("IPLimit")
		RegType = Dream3CLS.SiteConfig("RegType")
		OrderOKSMS = Dream3CLS.SiteConfig("OrderOKSMS")
		SendRegSMS = Dream3CLS.SiteConfig("SendRegSMS")
		ShowClassify = Dream3CLS.SiteConfig("ShowClassify")
	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">ѡ������</span><span class="fr">&nbsp;</span></div>
    <div class="say">
    </div>
</div>

<div id="box">
	<div class="sect">
				<form method="post" action="option.asp?act=save">
                     
						<div class="wholetip clear"><h3>1����������</h3></div>
						
						<div class="field">
                            <label>�������Ŷ���</label>
							<select name="IsUseSMS">
                              <option value="0" <%If IsUseSMS=0 then response.Write("selected") %>>��</option>
							  <option value="1" <%If IsUseSMS=1 then response.Write("selected") %>>��</option>
                            </select><span class="inputtip">�Ƿ������Ŷ��Ķ�����Ϣ����</span>
                        </div>
						<div class="field">
                            <label>����IP�޶�</label>
							<select name="IPLimit">
                              <option value="0" <%If IPLimit=0 then response.Write("selected") %>>��</option>
							  <option value="1" <%If IPLimit=1 then response.Write("selected") %>>��</option>
                            </select><span class="inputtip">�Ƿ���IP�޶�����</span>
                        </div>
						<div class="field" style="display:none">
                            <label>ע�᷽ʽ</label>
							<select name="RegType">
                              <option value="0" <%If RegType=0 then response.Write("selected") %>>��ͨ</option>
							  <option value="1" <%If RegType=1 then response.Write("selected") %>>�ֻ�</option>
                            </select><span class="inputtip">ע�᷽ʽ��Ϊ��ͨ���ֻ�ע�᷽ʽ</span>
                        </div>
						<div class="field">
                            <label>��������������ʾ</label>
							<select name="OrderOKSMS">
                              <option value="0" <%If OrderOKSMS=0 then response.Write("selected") %>>��</option>
							  <option value="1" <%If OrderOKSMS=1 then response.Write("selected") %>>��</option>
                            </select><span class="inputtip">Ĭ�ϲ�����</span>
                        </div>
						
						<div class="wholetip clear"><h3>n��ע��ѡ��</h3></div>
						<div class="field">
                            <label>������֤</label>
							<select name="IsMailVaild">
                              <option value="0" <%If IsMailVaild=0 then response.Write("selected") %>>��</option>
							  <option value="1" <%If IsMailVaild=1 then response.Write("selected") %>>��</option>
                            </select><span class="inputtip">�û�ע��,����ʱ���Ƿ�������������֤</span>
                        </div>
						<!--<div class="field">
                            <label>�ֻ��������</label>
							<select name="IsForceMobile">
                              <option value="0" <%If IsForceMobile=0 then response.Write("selected") %>>��</option>
							  <option value="1" <%If IsForceMobile=1 then response.Write("selected") %>>��</option>
                            </select><span class="inputtip">�û�ע��ʱ���Ƿ�����������Ϸ����ֻ�����</span>
                        </div> -->
						<div class="field">
                            <label>ע����ŷ���</label>
							<select name="SendRegSMS">
                              <option value="0" <%If SendRegSMS=0 then response.Write("selected") %>>��</option>
							  <option value="1" <%If SendRegSMS=1 then response.Write("selected") %>>��</option>
                            </select><span class="inputtip">�û�ע��ɹ�ʱ���Ƿ���ע����Ϣ���ͻ�</span>
                        </div>
						<div class="act">
                            <input type="submit" class="formbutton" value="����">
                        </div>
						
					</form>
                </div>      
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->