<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<%
Dim Action
Dim siteName,siteUrl,logo,seqNo,linkId, title,operate
title = "��������"

	Action = Request.QueryString("act")
	Select Case Action
		Case "save"
			Call SaveRecord()
		Case "showAdd"
			Call Main()
		Case "showEdit"
			Call ShowEdit()
		Case Else
				Call Main()
	End Select
	
	Sub SaveRecord()
	
		siteName =  Dream3CLS.RParam("siteName")
		siteUrl=  Dream3CLS.RParam("siteUrl")
		logo=  Dream3CLS.RParam("logo")
		seqNo=   Dream3CLS.ChkNumeric(Request.Form("seqNo"))
		linkId = Dream3CLS.ChkNumeric(Request("linkId"))
		'validate Form
		If siteName = "" Then
			gMsgArr = "��վ���Ʋ���Ϊ�գ�"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		'�ж��Ƿ��Ѿ�������վ����
		Sql = "select id from T_FriendLink Where siteName='"&siteName&"'"
		If linkId <> "" Then
			Sql = Sql & " and id<>"&linkId
		End If
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "վ�������Ѿ����ڣ�"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_FriendLink "
		If linkId <> "" and linkId <> 0 Then
			Sql = Sql & " Where ID="&linkId
		End If
		
		Rs.open Sql,conn,1,2
		If linkId = "" or linkId = 0 Then
			Rs.AddNew
		End If
		Rs("siteName") 	= siteName
		Rs("siteUrl") 	= siteUrl
		Rs("logo") 	= logo
		Rs("seqNo")= seqNo
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		'gMsgFlag = "S"
		Dream3CLS.showMsg "����ɹ�","S","friendLink.asp"
		
	End Sub
	
	Sub ShowEdit()	
		operate = "�޸�"
		linkId = Dream3CLS.ChkNumeric(Request("linkId"))
		Sql = "select id,siteUrl,siteName,logo,seqno from T_FriendLink Where Id="&linkId
		Set Rs = Dream3CLS.Exec(Sql)
		siteName = Rs("siteName")
		siteUrl = Rs("siteUrl")
		logo = Rs("logo")
		seqNo = Rs("seqNo")
	End Sub

	
	Sub Main()	
		'linkId = Dream3CLS.ChkNumeric(Request.QueryString("linkId"))
		If linkid <> 0 and  linkid <> "" Then	
			operate = "�޸�"
		Else 
			operate = "����"
			siteUrl = "http://"
		End if
	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">�������ӹ���</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">

                <div class="sect">
                    <form method="post" action="friendlinkEdit.asp?act=save">
						<div class="wholetip clear"><h3>1��<%=operate%>��������
</h3></div>
                        <div class="field">
                            <label>��վ����</label>
                            <input type="text" name="siteName" value="<%=siteName%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>��վ��ַ</label>
                            <input type="text" name="siteUrl" value="<%=siteUrl%>" class="f-input" size="30">
                        </div>
                        <div class="field">
                            <label>Logo</label>
                            <input type="text" name="logo" value="<%=logo%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>�����</label>
                            <input type="text" name="seqNo" value="<%=seqNo%>" class="f-input" size="30">
                        </div>
						
						<div class="act">
							 <input type="hidden" name="linkId" value="<%=linkId%>"/>
                             <input type="submit" class="formbutton" value="����">
                        </div>
                    </form>
                </div>

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->