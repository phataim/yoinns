<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<%
Dim Action
Dim SiteName,SiteTitle,SiteShortName,CNYSymbol,Preferential,TeamSideCount,TeamCondition,InviteBonus,PreferentialDown,CompactExport,SiteICP,ServiceMSN,ServiceQQ,ServicePhone,ServiceTime,ServiceEmail,IPSMSCount
Dim MetaDescription,MetaKeywords
Dim DeductRate,ReserveRate

	Action = Request.QueryString("act")
	Select Case Action
		   Case "save"
		   		Call save()
		   Case Else
				Call Main()
	End Select
	
	Sub Save()
		SiteName =  Request.Form("SiteName")
		SiteTitle=  Request.Form("SiteTitle")
		SiteShortName=  Request.Form("SiteShortName")
		CNYSymbol=  Request.Form("CNYSymbol")
		Preferential=  Request.Form("Preferential")
		TeamSideCount=  Request.Form("TeamSideCount")
		TeamCondition=  Request.Form("TeamCondition")
		InviteBonus=  Request.Form("InviteBonus")
		PreferentialDown=  Request.Form("PreferentialDown")
		CompactExport=  Request.Form("CompactExport")
		SiteICP=  Request.Form("SiteICP")
		ServiceMSN=  Request.Form("ServiceMSN")
		ServiceQQ=  Request.Form("ServiceQQ")
		ServicePhone=  Request.Form("ServicePhone")
		ServiceTime=  Request.Form("ServiceTime")
		ServiceEmail = Request.Form("ServiceEmail")
		MetaKeywords = Request.Form("MetaKeywords")
		MetaDescription = Request.Form("MetaDescription")
		IPSMSCount = Request.Form("IPSMSCount")
		DeductRate = Request.Form("DeductRate")
		ReserveRate = Request.Form("ReserveRate")
		
		If IsNumeric(Request.Form("InviteBonus"))=false then 
			gMsgArr = "邀请返利输入框的值，必须为数字类型"
		End If
		If IsNumeric(Request.Form("TeamSideCount"))=false then 
			gMsgArr = gMsgArr & "|" & "侧栏团购数输入框的值，必须为数字类型"
		End If
		
		If IsNumeric(Request.Form("ReserveRate"))=false then 
			gMsgArr = gMsgArr & "|" & "定金比例输入框的值，必须为数字类型"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
	
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
		'重新加载全局变量用于显示
		'Call loadConfig()
		Dream3CLS.ReloadConfigCache()
		
		gMsgFlag = "S"
		
	End Sub

	
	Sub Main()
		SiteName = Dream3CLS.SiteConfig("SiteName")
		SiteTitle= Dream3CLS.SiteConfig("SiteTitle")
		SiteShortName= Dream3CLS.SiteConfig("SiteShortName")
		CNYSymbol= Dream3CLS.SiteConfig("CNYSymbol")
		Preferential= Dream3CLS.SiteConfig("Preferential")
		TeamSideCount= Dream3CLS.SiteConfig("TeamSideCount")
		TeamCondition= Dream3CLS.SiteConfig("TeamCondition")
		InviteBonus= Dream3CLS.SiteConfig("InviteBonus")
		PreferentialDown= Dream3CLS.SiteConfig("PreferentialDown")
		CompactExport= Dream3CLS.SiteConfig("CompactExport")
		SiteICP= Dream3CLS.SiteConfig("SiteICP")
		ServiceMSN= Dream3CLS.SiteConfig("ServiceMSN")
		ServiceQQ= Dream3CLS.SiteConfig("ServiceQQ")
		ServicePhone = Dream3CLS.SiteConfig("ServicePhone")
		ServiceEmail = Dream3CLS.SiteConfig("ServiceEmail")
		ServiceTime= Dream3CLS.SiteConfig("ServiceTime")
		MetaKeywords= Dream3CLS.SiteConfig("MetaKeywords")
		MetaDescription= Dream3CLS.SiteConfig("MetaDescription")
		IPSMSCount= Dream3CLS.SiteConfig("IPSMSCount")
		DeductRate = Dream3CLS.SiteConfig("DeductRate")
		ReserveRate = Dream3CLS.SiteConfig("ReserveRate")
	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">基本设置</span><span class="fr">&nbsp;</span></div>
    <div class="say">
        网站基本信息设置
    </div>
</div>

<div id="box">
	<div class="sect">
		<form method="post" action="index.asp?act=save">
			<div class="wholetip clear"><h3>1、基本信息</h3></div>
			<div class="field">
				<label>网站名称</label>
				<input type="text" name="SiteName" value="<%=SiteName%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>网站标题</label>
				<input type="text" name="SiteTitle" value="<%=SiteTitle%>" class="f-input" size="30">
			</div>
			 <div class="field">
				<label>Keywords</label>

				<textarea id="MetaKeywords" name="MetaKeywords" class="xheditor" rows="5" cols="50" style="width: 55%"><%=MetaKeywords%></textarea>
			</div>
			<div class="field">
				<label>Description</label>

				<textarea id="MetaDescription" name="MetaDescription" class="xheditor" rows="5" cols="50" style="width: 55%"><%=MetaDescription%></textarea>
			</div>
			<div class="field">
				<label>网站简称</label>
				<input type="text" name="SiteShortName" value="<%=SiteShortName%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>货币符号</label>
				<input type="text" name="CNYSymbol" value="<%=CNYSymbol%>" class="number" size="30">
			</div>
			<div class="field">
				<label>侧栏短租数</label>
				<input type="text" name="TeamSideCount" value="<%=TeamSideCount%>" class="number" size="30">
				<span class="inputtip">侧栏短租数，默认为 0</span>
				<span class="hint">在短租页面的右侧栏显示当前正在进行的其他短租项目？</span>
			</div>
			<div class="field">
				<label>定金比例</label>
				<input type="text" name="ReserveRate" value="<%=ReserveRate%>" class="number" size="30">
				<span class="inputtip">定金所占总价百分比</span>
				<span class="hint">如填写30 则表示30%</span>
			</div>
			<div class="field">
				<label>同个IP短信次数</label>
				<input type="text" name="IPSMSCount" value="<%=IPSMSCount%>" class="number" size="30">
				<span class="inputtip">默认5次</span>
				<span class="hint">防止同个IP的用户恶意请求发送短信</span>
			</div>
			<div class="wholetip clear"  style="display:none"><h3>2、杂项设置</h3></div>
		  
			<div class="wholetip clear"><h3>2、客服信息</h3></div>
			<div class="field">
				<label>客服QQ</label>
				<input type="text"  name="ServiceQQ" value="<%=ServiceQQ%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>客服MSN</label>
				<input type="text" name="ServiceMSN" value="<%=ServiceMSN%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>客服电话</label>
				<input type="text"  name="ServicePhone" value="<%=ServicePhone%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>营业时间</label>
				<input type="text"  name="ServiceTime" value="<%=ServiceTime%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>客服邮件</label>
				<input type="text"  name="ServiceEmail" value="<%=ServiceEmail%>" class="f-input" size="30">
			</div>
			<div class="wholetip clear"><h3>3、其他信息</h3></div>
			<div class="field">
				<label>ICP编号</label>
				<input type="text" name="SiteICP"  value="<%=SiteICP%>" class="f-input" size="30">
			</div>
			<div class="act">
				<input type="submit" class="formbutton" value="保存">
			</div>
		</form>
	</div>       
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->
