<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->

<%
Dim Action
Dim id,title,image,url,seqNo,operate,adtitle,enabled
title = "������"

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
	
		adTitle =  Dream3CLS.RParam("adTitle")
		url=  Dream3CLS.RParam("url")
		image=  Dream3CLS.RParam("src_img_h1")
		seqNo=   Dream3CLS.ChkNumeric(Request.Form("seqNo"))
		id = Dream3CLS.ChkNumeric(Request("id"))
		enabled = Dream3CLS.RParam("enabled")

		'validate Form
		If  adTitle = ""   Then
			gMsgArr = gMsgArr&"|�����ⲻ��Ϊ�գ�"
		End If
		If  image = ""   Then
			gMsgArr = gMsgArr&"|���ϴ����ͼƬ��"
		End If
		If  url = ""   Then
			gMsgArr = gMsgArr&"|����д���ӵ�ַ��"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_AD "
		If id <> "" and id <> 0 Then
			Sql = Sql & " Where ID="&id
		End If
		
		Rs.open Sql,conn,1,2
		If id = "" or id = 0 Then
			Rs.AddNew
			Rs("enabled") = "Y"
		End If
		Rs("title") 	= adTitle
		Rs("url") 	= url
		Rs("image") 	= image
		Rs("seqNo")= seqNo
		Rs("enabled") = enabled
		Rs("Create_time") = Now()
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		'gMsgFlag = "S"
		Dream3CLS.showMsg "����ɹ�","S","ad.asp"
		
	End Sub
	
	Sub ShowEdit()	
		operate = "�޸�"
		id = Dream3CLS.ChkNumeric(Request("id"))
		Sql = "select * from T_ad Where Id="&id
		Set Rs = Dream3CLS.Exec(Sql)
		adTitle = Rs("Title")
		url = Rs("url")
		image = Rs("image")
		seqNo = Rs("seqNo")
		enabled= Rs("enabled")
	End Sub

	
	Sub Main()	
		'linkId = Dream3CLS.ChkNumeric(Request.QueryString("linkId"))
		If id <> 0 and  id <> "" Then	
			operate = "�޸�"
		Else 
			operate = "����"
			url = "http://"
		End if
	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">������</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">

                <div class="sect">
                    <form id="adForm" name="adForm" method="post" action="?act=save">
						<div class="wholetip clear"><h3>1��<%=operate%>���
</h3></div>
                        <div class="field">
                            <label>������</label>
                            <input type="text" name="adtitle" value="<%=adtitle%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>���ӵ�ַ</label>
                            <input type="text" name="url" value="<%=url%>" class="f-input" size="30">
                        </div>
                        <div class="field">
                            <label>�ϴ�ͼƬ</label>
                            <IMG src="<%If IsNull(image) or image="" Then response.Write("../../images/noimage.gif") else response.Write("../../"&image)%>" height=80 align=left name='src_img_1'>
						<span style=cursor:hand onclick="window.open('../../common/upload/upload_image.asp?formname=adForm&amp;ImgSrc=src_img_1&amp;editname=src_img_h1','','status=no,scrollbars=no,top=200,left=310,width=420,height=165')" >&gt;&gt;�ϴ����ͼƬ......</span> 
                              <INPUT type=hidden name=src_img_h1 value="<%=image%>">
                        </div>
						<div class="field">
                            <label>�����</label>
                            <input type="text" name="seqNo" value="<%=seqNo%>" class="f-input" size="30">
                        </div>
						<div class="field">
                        <label>״̬</label>
						<select name="enabled">
                              <option value="Y" <%If enabled="Y" then response.Write("selected") %>>����</option>
							  <option value="N" <%If enabled="N" then response.Write("selected") %>>����</option>
                            </select>
						 </div>
						<div class="act">
							 <input type="hidden" name="id" value="<%=id%>"/>
                             <input type="submit" class="formbutton" value="����">
                        </div>
                    </form>
                </div>
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->