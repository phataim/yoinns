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
		
		'重新加载全局变量用于显示
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
	<div class="PageTitle"><span class="fl">支付方式</span><span class="fr">&nbsp;</span></div>
    <div class="say">
    </div>
</div>
<div id="box">
	<div class="sect">
					
					<form name="form" method="post"  action="pay.asp?act=save" onSubmit="return CheckForm(this);">
					
					<div class="field">
						<div class="wholetip clear"><h3>1、支付宝（仅支持担保交易，如没有保留为空）</h3></div>
                        <div class="field">
                            <label>商户ID号</label>
                            <input type="text" name="AlipayID" value="<%=AlipayID%>" style="width: 200px;" class="f-input" size="30"><span class="inputtip">商户申请:<a target="_blank" href="http://act.life.alipay.com/systembiz/junshang/">签约支付宝</a></span>
                        </div>
                        <div class="field">
                            <label>交易密钥</label>
                            <input type="password" name="AlipayKey" value="<%=AlipayKey%>" class="f-input" size="30">
                        </div>
                        <div class="field">
                            <label>支付宝账户</label>
                            <input type="text" name="AlipayAccount" value="<%=AlipayAccount%>" style="width: 200px;" class="f-input"  size="30"><span class="inputtip">支付宝登录帐户名</span>
                        </div>
						<div class="field">
                            <label>接口类型</label>
							<select name="AlipayService">
                              <option value="0" <%If AlipayService=0 then response.Write("selected") %>>即时到账交易</option>
							  <option value="1" <%If AlipayService=1 then response.Write("selected") %>>标准双接口交易</option>
							  <option value="2" <%If AlipayService=2 then response.Write("selected") %>>担保交易</option>
                            </select><span class="inputtip">支付宝的交易类型</span>
                        </div>

						<div class="wholetip clear"><h3>2、财付通（没有的话，保留为空）</h3></div>
                        <div class="field">
                            <label>财付通账号</label>
                            <input type="text" style="width: 200px;" name="TenpayID" value="<%=TenpayID%>" class="f-input" size="30"><span class="inputtip"></span>
                        </div>
                        <div class="field">
                            <label>交易密钥</label>
                            <input type="password" name="TenpayKey" value="<%=TenpayKey%>" class="f-input" size="30">
                        </div>
						 <div class="field" style="display:none">
                            <label>财付通账户</label>
                            <input type="text" name="TenpayAccount" value="<%=TenpayAccount%>" style="width: 200px;" class="f-input"  size="30"><span class="inputtip"></span>
                        </div>
						<!-- ChinaBank -->
						<div class="wholetip clear"><h3>3、网银在线（没有的话，保留为空）</h3></div>
						
                        <div class="field">
                            <label>网银账号</label>
                            <input type="text" style="width: 200px;" name="ChinaBankID" value="<%=ChinaBankID%>" class="f-input" size="30"><span class="inputtip">老版商户号为4位或5位,新版为8位</span>
                        </div>
                        <div class="field">
                            <label>交易密钥</label>
                            <input type="password" name="ChinaBankKey" value="<%=ChinaBankKey%>" class="f-input" size="30">
                        </div>
						 <div class="field">
                            <label>网银账户</label>
                            <input type="text" name="ChinaBankAccount" value="<%=ChinaBankAccount%>" style="width: 200px;" class="f-input"  size="30"><span class="inputtip">可以不填</span>
                        </div>
						<!-- YeePay -->
						<div class="wholetip clear"><h3>4、易宝支付（支持网银直达）</h3></div>
                        <div class="field">
                            <label>商户ID号</label>
                            <input type="text" size="30" name="YeepayID" class="f-input" style="width:200px;" value="<%=YeepayID%>"/><span class="inputtip">商户申请:<a href="http://www.dream3.cn/sls/value_yeepay.html" target="_blank">签约易宝</a></span>
                        </div>
                        <div class="field">
                            <label>交易密钥</label>
                            <input type="password" size="30" name="YeepayKey" class="f-input" value="<%=YeepayKey%>"/>
                        </div>
						<!-- YeePay/End -->
						<div class="wholetip clear"><h3>5、其他</h3></div>
						<div class="field">
							<label>支付信息</label>
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
							<input type="submit" class="formbutton"  value="保存">
						</div>
                	</div>
				</form>
				
				
            </div>
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->