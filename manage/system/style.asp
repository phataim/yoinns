<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->

<!--#include file="../../common/api/cls_email.asp"-->
<%
Dim Action
Dim themes,Rs

	Action = Request.QueryString("act")
	Select Case Action
		   Case "changestyle"
		   		Call ChangeStyle()
		   Case Else
				Call Main()
	End Select
	
		serviceEmailXht = "123619503@qq.com"
	 serviceEmailLzp = "649630350@qq.com"
	 serviceEmailXyh = "imhang@qq.com"
		
		topic = "测试有订单啦哈哈哈哈"
		mailbody = "测试有订单啦快去后台看啊！！"
		
		cmEmail.SendMail serviceEmailXht,topic,mailbody
		cmEmail.SendMail serviceEmailLzp,topic,mailbody
		cmEmail.SendMail serviceEmailXyh,topic,mailbody
	
	Sub ChangeStyle()

		themes = Request("themes")
		Rs.Open "[T_Config]",Conn,1,3
		
		Set XMLDOM=Server.CreateObject("Microsoft.XMLDOM")
		XMLDOM.loadxml("<Dream3>"&Rs("SiteSettingsXML")&"</Dream3>")
		SiteSettingsXMLStrings=""
		Set objNodes = XMLDOM.documentElement.ChildNodes
		Set objRoot = XMLDOM.documentElement
		
		objRoot.SelectSingleNode("DefaultSiteStyle").text = ""&server.HTMLEncode(Request("themes"))&""
		
		for each element in objNodes	
			SiteSettingsXMLStrings=SiteSettingsXMLStrings&"<"&element.nodename&">"&element.text&"</"&element.nodename&">"&vbCrlf
		next
		Set XMLDOM=nothing
		Rs("SiteSettingsXML")=SiteSettingsXMLStrings
		Rs.update
		Rs.close
		'重新加载全局变量用于显示
		'Call loadConfig()
		Dream3CLS.ReloadConfigCache()
	End Sub
	
	Sub Main()
		'response.Write(ListFolderCombox(Server.MapPath("../../common/themes")))
		'call ListFolderContents(Server.MapPath("../../common/themes"))
	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">皮肤修改</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">
					
				<div class="sect">
				
					<ul class="ImgList">
<%
	
    Dim fs, folder, subFolder,splitArr
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set folder = fs.GetFolder(Server.MapPath("../../common/themes"))
    
    For Each item In folder.SubFolders
		splitArr = split(item.Path,"\")
		subFolder = splitArr(ubound(splitArr))
%>
					  <li>
					  <br><%=subFolder%><br>
					  <strong>
					  
					  
					  </strong></li>
<%
Next
%>
					</ul>
				
                </div>
				
          
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->