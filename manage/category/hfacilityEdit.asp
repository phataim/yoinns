<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<%
Dim Action
Dim cname,category,seqNo,id, title,operate


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
		category=  Dream3CLS.RParam("category")
		seqno =  Dream3CLS.RNum("seqno")

		id = Request.Form("id")
		'validate Form
		If cname = "" Then
			gMsgArr = "�Ƶ���ʩ���Ʋ���Ϊ�գ�"
		End If

		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		'�ж��Ƿ��Ѿ�������վ����
		Sql = "select id from T_Hfacility Where cname='"&cname&"'"
		If id <> "" Then
			Sql = Sql & " and id<>"&id
		End If
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "�Ƶ���ʩ�����Ѿ����ڣ�"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		

		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_Hfacility Where 1=1"
		If id <> "" and id <> 0 Then
			Sql = Sql & " and ID="&id
		End If
		
		Rs.open Sql,conn,1,2
		If id = "" or id="0" Then
			Rs.AddNew
			Rs("enabled")= "Y"
		End If
		Rs("cname") 	= cname
		Rs("category") 	= category
		Rs("seqNo")= seqNo
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		'gMsgFlag = "S"
		Dream3CLS.showMsg "����ɹ�","S","hotelfacility.asp"
		
	End Sub
	
	Sub ShowEdit()	
		'operate = "�޸�"
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		classifier=  Request.Querystring("classifier")
		sql = "select id,cname,category,seqno from T_Hfacility Where id="&id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
			response.End()
		End If
		cname = Rs("cname")
		category = Rs("category")
		seqNo = Rs("seqNo")
		
		Call Main()
	End Sub

	
	Sub Main()		
	
		title = "�Ƶ���ʩ"
		
		id = Dream3CLS.ChkNumeric(Request("id"))

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
                    <form method="post" action="hfacilityEdit.asp?act=save">
						<div class="wholetip clear"><h3>1��<%=operate%><%=title%>
</h3></div>
                        <div class="field">
                            <label>�������ƣ�</label>
                            <input type="text" name="cname" value="<%=cname%>" class="f-input" size="30">
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
                             <input type="submit" class="formbutton" value="����">
                        </div>
                    </form>
                </div>

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->
