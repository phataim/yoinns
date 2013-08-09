<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->

<%
Dim Action
Dim  AllowIPs

	Action = Request.QueryString("act")
	Select Case Action
		   Case "save"
		   		Call SaveRecord()
		   Case Else
				Call Main()
	End Select
	
	Sub SaveRecord()

		AllowIPs =  Request.Form("AllowIPs")

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
		
		'Save OtherPay
		Set Rs = Server.CreateObject("adodb.recordset")
		Sql = "select * from T_Config "
		Rs.Open Sql, Conn, 1, 3
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
		
		AllowIPs =  Dream3CLS.SiteConfig("AllowIPs")		
		
	End Sub
%>

<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">登录IP限定</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">
	<div class="sect">
					
					<form name="form" method="post"  action="?act=save">
					
					<div class="field">
						<div class="wholetip clear"><h3>1、IP配置</h3></div>
                     
                        <div class="field">
                            <label></label>
                            <textarea name="AllowIPs" cols="100" rows="20"><%=AllowIPs%></textarea>
							 <p>多个IP请用英文逗号,隔开</p>
							
                        </div>
                    
						<div class="act">
							<input type="submit" class="formbutton"  value="保存">
						</div>
                	</div>
				</form>
				
				
            </div>
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->