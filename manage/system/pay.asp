<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->

<%
Dim Action
Dim AlipayID, AlipayKey, AlipayAccount,AlipayService, YeepayID, YeepayKey, TenpayID, TenpayKey, ChinaBankID, ChinaBankKey,ChinaBankAccount,TenpayAccount
Dim OtherPay
	Action = Request.QueryString("act")
	Select Case Action
		   Case "save"
		   		Call SavePay()
		   Case Else
				Call Main()
	End Select
	
	Sub SavePay()

		AlipayID =  Request.Form("AlipayID")
		AlipayKey =  Request.Form("AlipayKey")
		AlipayAccount =  Request.Form("AlipayAccount")
		AlipayService  =  Request.Form("AlipayService")
		TenpayID =  Request.Form("TenpayID")
		TenpayKey =  Request.Form("TenpayKey")
		TenpayAccount=  Request.Form("TenpayAccount")
		ChinaBankID =  Request.Form("ChinaBankID")
		ChinaBankKey =  Request.Form("ChinaBankKey")
		ChinaBankAccount=  Request.Form("ChinaBankAccount")
		OtherPay =  Request.Form("OtherPay")
		YeepayID =  Request.Form("YeepayID")
		YeepayKey =  Request.Form("YeepayKey")


		Rs.Open "[T_Config]",Conn,1,3
		
	    Set XMLDOM=Server.CreateObject("Microsoft.XMLDOM")
		XMLDOM.loadxml("<Dream3>"&Rs("SiteSettingsXML")&"</Dream3>")
		SiteSettingsXMLStrings=""
		Set objNodes = XMLDOM.documentElement.ChildNodes
		Set objRoot = XMLDOM.documentElement
		for each ho in Request.Form
			If ho <> "OtherPay" Then
				objRoot.SelectSingleNode(ho).text = ""&server.HTMLEncode(Request(""&ho&""))&""
			End If
		next
		for each element in objNodes	
			SiteSettingsXMLStrings=SiteSettingsXMLStrings&"<"&element.nodename&">"&element.text&"</"&element.nodename&">"&vbCrlf
		next
		
		Set XMLDOM=nothing
		Rs("SiteSettingsXML")=SiteSettingsXMLStrings
		Rs.update
		Rs.close
		
		'Save OtherPay
		Set Rs = Server.CreateObject("adodb.recordset")
		Sql = "select * from T_Config "
		Rs.Open Sql, Conn, 1, 3
		Rs("OtherPay") 	= OtherPay
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		'���¼���ȫ�ֱ���������ʾ
		'Call loadConfig()
		Dream3CLS.ReloadConfigCache()
		
		gMsgFlag = "S"
		
		Call Main()
		
	End Sub

	
	Sub Main()		
		
		AlipayID =  Dream3CLS.SiteConfig("AlipayID")
		AlipayKey =  Dream3CLS.SiteConfig("AlipayKey")
		AlipayAccount =  Dream3CLS.SiteConfig("AlipayAccount")
		AlipayService =  Dream3CLS.SiteConfig("AlipayService")
		TenpayID =  Dream3CLS.SiteConfig("TenpayID")
		TenpayKey =  Dream3CLS.SiteConfig("TenpayKey")
		TenpayAccount = Dream3CLS.SiteConfig("TenpayAccount")
		ChinaBankID =  Dream3CLS.SiteConfig("ChinaBankID")
		ChinaBankKey =  Dream3CLS.SiteConfig("ChinaBankKey")
		ChinaBankAccount = Dream3CLS.SiteConfig("ChinaBankAccount")
		YeepayID =  Dream3CLS.SiteConfig("YeepayID")
		YeepayKey =  Dream3CLS.SiteConfig("YeepayKey")
		OtherPay = Dream3CLS.Dream3_OtherPay
		
		
	End Sub
%>

<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="../../common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="../../xheditor/xheditor-zh-cn.min.js"></script>

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">֧����ʽ</span><span class="fr">&nbsp;</span></div>
    <div class="say">
    </div>
</div>
<div id="box">
	<div class="sect">
					
					<form name="form" method="post"  action="pay.asp?act=save" onSubmit="return CheckForm(this);">
					
					<div class="field">
						<div class="wholetip clear"><h3>1��֧��������֧�ֵ������ף���û�б���Ϊ�գ�</h3></div>
                        <div class="field">
                            <label>�̻�ID��</label>
                            <input type="text" name="AlipayID" value="<%=AlipayID%>" style="width: 200px;" class="f-input" size="30"><span class="inputtip">�̻�����:<a target="_blank" href="http://act.life.alipay.com/systembiz/junshang/">ǩԼ֧����</a></span>
                        </div>
                        <div class="field">
                            <label>������Կ</label>
                            <input type="password" name="AlipayKey" value="<%=AlipayKey%>" class="f-input" size="30">
                        </div>
                        <div class="field">
                            <label>֧�����˻�</label>
                            <input type="text" name="AlipayAccount" value="<%=AlipayAccount%>" style="width: 200px;" class="f-input"  size="30"><span class="inputtip">֧������¼�ʻ���</span>
                        </div>
						<div class="field">
                            <label>�ӿ�����</label>
							<select name="AlipayService">
                              <option value="0" <%If AlipayService=0 then response.Write("selected") %>>��ʱ���˽���</option>
							  <option value="1" <%If AlipayService=1 then response.Write("selected") %>>��׼˫�ӿڽ���</option>
							  <option value="2" <%If AlipayService=2 then response.Write("selected") %>>��������</option>
                            </select><span class="inputtip">֧�����Ľ�������</span>
                        </div>

						<div class="wholetip clear"><h3>2���Ƹ�ͨ��û�еĻ�������Ϊ�գ�</h3></div>
                        <div class="field">
                            <label>�Ƹ�ͨ�˺�</label>
                            <input type="text" style="width: 200px;" name="TenpayID" value="<%=TenpayID%>" class="f-input" size="30"><span class="inputtip"></span>
                        </div>
                        <div class="field">
                            <label>������Կ</label>
                            <input type="password" name="TenpayKey" value="<%=TenpayKey%>" class="f-input" size="30">
                        </div>
						 <div class="field" style="display:none">
                            <label>�Ƹ�ͨ�˻�</label>
                            <input type="text" name="TenpayAccount" value="<%=TenpayAccount%>" style="width: 200px;" class="f-input"  size="30"><span class="inputtip"></span>
                        </div>
						<!-- ChinaBank -->
						<div class="wholetip clear"><h3>3���������ߣ�û�еĻ�������Ϊ�գ�</h3></div>
						
                        <div class="field">
                            <label>�����˺�</label>
                            <input type="text" style="width: 200px;" name="ChinaBankID" value="<%=ChinaBankID%>" class="f-input" size="30"><span class="inputtip">�ϰ��̻���Ϊ4λ��5λ,�°�Ϊ8λ</span>
                        </div>
                        <div class="field">
                            <label>������Կ</label>
                            <input type="password" name="ChinaBankKey" value="<%=ChinaBankKey%>" class="f-input" size="30">
                        </div>
						 <div class="field">
                            <label>�����˻�</label>
                            <input type="text" name="ChinaBankAccount" value="<%=ChinaBankAccount%>" style="width: 200px;" class="f-input"  size="30"><span class="inputtip">���Բ���</span>
                        </div>
						<!-- YeePay -->
						<div class="wholetip clear"><h3>4���ױ�֧����֧������ֱ�</h3></div>
                        <div class="field">
                            <label>�̻�ID��</label>
                            <input type="text" size="30" name="YeepayID" class="f-input" style="width:200px;" value="<%=YeepayID%>"/><span class="inputtip">�̻�����:<a href="http://www.dream3.cn/sls/value_yeepay.html" target="_blank">ǩԼ�ױ�</a></span>
                        </div>
                        <div class="field">
                            <label>������Կ</label>
                            <input type="password" size="30" name="YeepayKey" class="f-input" value="<%=YeepayKey%>"/>
                        </div>
						<!-- YeePay/End -->
						<div class="wholetip clear"><h3>5������</h3></div>
						<div class="field">
							<label>֧����Ϣ</label>
							<div style="float: left;">
						
							<table>
							<tr>
							<td colspan="3">
							
							</td>
							</tr>
								<TR id=CommonListCell>
                          <TD vAlign=top>
						 
							<span id=UpFile></span>
		    			
						  </TD>
                          <TD height="250" width="650" colSpan=2>
							<textarea id="OtherPay" name="OtherPay" class="xheditor" rows="12" cols="80" style="width: 80%"><%=OtherPay%></textarea>
						  </TD>
                        </TR>
						</table>
						
							</div>
						</div>
						<div class="act">
							<input type="submit" class="formbutton"  value="����">
						</div>
                	</div>
				</form>
				
				
            </div>
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->