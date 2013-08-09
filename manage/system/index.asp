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
			gMsgArr = "���뷵��������ֵ������Ϊ��������"
		End If
		If IsNumeric(Request.Form("TeamSideCount"))=false then 
			gMsgArr = gMsgArr & "|" & "�����Ź���������ֵ������Ϊ��������"
		End If
		
		If IsNumeric(Request.Form("ReserveRate"))=false then 
			gMsgArr = gMsgArr & "|" & "�������������ֵ������Ϊ��������"
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
		'���¼���ȫ�ֱ���������ʾ
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
	<div class="PageTitle"><span class="fl">��������</span><span class="fr">&nbsp;</span></div>
    <div class="say">
        ��վ������Ϣ����
    </div>
</div>

<div id="box">
	<div class="sect">
		<form method="post" action="index.asp?act=save">
			<div class="wholetip clear"><h3>1��������Ϣ</h3></div>
			<div class="field">
				<label>��վ����</label>
				<input type="text" name="SiteName" value="<%=SiteName%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>��վ����</label>
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
				<label>��վ���</label>
				<input type="text" name="SiteShortName" value="<%=SiteShortName%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>���ҷ���</label>
				<input type="text" name="CNYSymbol" value="<%=CNYSymbol%>" class="number" size="30">
			</div>
			<div class="field">
				<label>����������</label>
				<input type="text" name="TeamSideCount" value="<%=TeamSideCount%>" class="number" size="30">
				<span class="inputtip">������������Ĭ��Ϊ 0</span>
				<span class="hint">�ڶ���ҳ����Ҳ�����ʾ��ǰ���ڽ��е�����������Ŀ��</span>
			</div>
			<div class="field">
				<label>�������</label>
				<input type="text" name="ReserveRate" value="<%=ReserveRate%>" class="number" size="30">
				<span class="inputtip">������ռ�ܼ۰ٷֱ�</span>
				<span class="hint">����д30 ���ʾ30%</span>
			</div>
			<div class="field">
				<label>ͬ��IP���Ŵ���</label>
				<input type="text" name="IPSMSCount" value="<%=IPSMSCount%>" class="number" size="30">
				<span class="inputtip">Ĭ��5��</span>
				<span class="hint">��ֹͬ��IP���û����������Ͷ���</span>
			</div>
			<div class="wholetip clear"  style="display:none"><h3>2����������</h3></div>
		  
			<div class="wholetip clear"><h3>2���ͷ���Ϣ</h3></div>
			<div class="field">
				<label>�ͷ�QQ</label>
				<input type="text"  name="ServiceQQ" value="<%=ServiceQQ%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>�ͷ�MSN</label>
				<input type="text" name="ServiceMSN" value="<%=ServiceMSN%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>�ͷ��绰</label>
				<input type="text"  name="ServicePhone" value="<%=ServicePhone%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>Ӫҵʱ��</label>
				<input type="text"  name="ServiceTime" value="<%=ServiceTime%>" class="f-input" size="30">
			</div>
			<div class="field">
				<label>�ͷ��ʼ�</label>
				<input type="text"  name="ServiceEmail" value="<%=ServiceEmail%>" class="f-input" size="30">
			</div>
			<div class="wholetip clear"><h3>3��������Ϣ</h3></div>
			<div class="field">
				<label>ICP���</label>
				<input type="text" name="SiteICP"  value="<%=SiteICP%>" class="f-input" size="30">
			</div>
			<div class="act">
				<input type="submit" class="formbutton" value="����">
			</div>
		</form>
	</div>       
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->
