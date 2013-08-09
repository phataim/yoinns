<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->

<%
Dim Action
Dim cname,ename,category,seqNo,id, title,classifier,operate


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
	
		cname =  Dream3CLS.RParam("cname")
		ename=  Dream3CLS.RParam("ename")
		category=  Dream3CLS.RParam("category")
		seqNo=   Dream3CLS.ChkNumeric(Request.Form("seqNo"))
		classifier=  Dream3CLS.RParam("classifier")
		id = Request.Form("id")
		'validate Form
		If cname = "" Then
			gMsgArr = "�������Ʋ���Ϊ�գ�"
		End If
		If ename = "" Then
			gMsgArr = gMsgArr & "|" & "Ӣ�����Ʋ���Ϊ�գ�"
		End If
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		'�ж��Ƿ��Ѿ�������վ����
		Sql = "select id from T_Category Where (cname='"&cname&"' or ename='"&ename&"') and classifier='"&classifier&"'"
		If id <> "" Then
			Sql = Sql & " and id<>"&id
		End If
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "�������ƻ�Ӣ�������Ѿ����ڣ�"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		

		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_Category Where classifier='"&classifier&"'"
		If id <> "" and id <> 0 Then
			Sql = Sql & " and ID="&id
		End If
		
		Rs.open Sql,conn,1,2
		If id = "" or id="0" Then
			Rs.AddNew
			Rs("enabled")= "Y"
		End If
		Rs("cname") 	= cname
		Rs("ename") 	= ename
		Rs("category") 	= category
		Rs("classifier") 	= classifier
		Rs("seqNo")= seqNo
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		'gMsgFlag = "S"
		Dream3CLS.showMsg "����ɹ�","S","index.asp?classifier="&classifier
		
	End Sub
	
	Sub ShowEdit()	
		'operate = "�޸�"
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		classifier=  Request.Querystring("classifier")
		sql = "select id,cname,ename,category,seqno from T_Category Where classifier='"&classifier&"' and id="&id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
			response.End()
		End If
		cname = Rs("cname")
		ename = Rs("ename")
		category = Rs("category")
		seqNo = Rs("seqNo")
		
		Call Main()
	End Sub

	
	Sub Main()		
		classifier = Request("classifier")
		If classifier <> "express" and  classifier <> "grade" and classifier <> "group"   Then classifier = "city"
		'operate = "����"
		Select Case classifier
			Case "express"
		   		title = "��ݹ�˾"
			Case "group"
		   		title = "�Ź�����"
			Case "grade"
		   		title = "�û��ȼ�"
		    Case Else
				title = "�����б�"
		End Select
		
		id = Dream3CLS.ChkNumeric(Request("id"))
		classifier=  Request("classifier")
		If id <> 0 Then
			operate = "�޸�"
		else 
			operate = "����"
		End If
		
	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl"><%=title%>����</span><span class="fr">&nbsp;</span></div>
    <div class="say">

    </div>
</div>

<div id="box">

                <div class="sect">
                    <form method="post" action="categoryEdit.asp?act=save">
						<div class="wholetip clear"><h3>1��<%=operate%><%=title%>
</h3></div>
                        <div class="field">
                            <label>�������ƣ�</label>
                            <input type="text" name="cname" value="<%=cname%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>Ӣ�����ƣ�</label>
                            <input type="text" name="ename" value="<%=ename%>" class="f-input" size="30">
                        </div>
                        <div class="field">
                            <label>�Զ�����飺</label>
                            <input type="text" name="category" value="<%=category%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>����(����)��</label>
                            <input type="text" name="seqNo" value="<%=seqNo%>" class="f-input" size="30">
                        </div>
						
						<div class="act">
							 <input type="hidden" name="id" value="<%=id%>"/>
							 <input type="hidden" name="classifier" value="<%=classifier%>"/>
                             <input type="submit" class="formbutton" value="����">
                        </div>
                    </form>
                </div>
           
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->
