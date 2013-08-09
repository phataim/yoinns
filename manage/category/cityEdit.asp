<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->

<%
Dim Action
Dim provincecode
Dim cityname,citypinyin,CityPostCode,CitySimple,cityprefix
Dim operate

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
	
		provincecode = Dream3CLS.RParam("provincecode")
		cityname =  Dream3CLS.RParam("cityname")
		citypinyin=  Dream3CLS.RParam("citypinyin")
		CityPostCode=  Dream3CLS.RParam("CityPostCode")
		CitySimple=   Dream3CLS.RParam("CitySimple")
		cityprefix=  Dream3CLS.RParam("cityprefix")
		id = Dream3CLS.ChkNumeric(Request.Form("id"))
		'validate Form
		If cityname = "" Then
			gMsgArr = "�������Ʋ���Ϊ�գ�"
		End If
		If citypinyin = "" Then
			gMsgArr = gMsgArr & "|" & "ƴ������Ϊ�գ�"
		End If
		If CityPostCode = "" Then
			gMsgArr = gMsgArr & "|" & "��Ų���Ϊ�գ�"
		End If
		If CitySimple = "" Then
			gMsgArr = gMsgArr & "|" & "��Ʋ���Ϊ�գ�"
		End If
		If len(cityprefix) <> 1 Then
			gMsgArr = gMsgArr & "|" & "����ĸ����Ϊ1��Ӣ���ַ���"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		
		If Len(CityPostCode) <> 6  Then
			gMsgArr = gMsgArr & "|" & "��ű���Ϊ6λ���֣��Һ��λΪ0��"
		Elseif mid(CityPostCode,5,6) <> "00" Then
			gMsgArr = gMsgArr & "|" & "��ű���Ϊ6λ���֣��Һ��λΪ0��"
		End If
		
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If Left(CityPostCode,2) <> left(provincecode,2) Then
			gMsgArr = gMsgArr & "|" & "���ǰ��λ������ʡ��ǰ��λ��ͬ��"
		End If
		
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		'�ж��Ƿ��Ѿ�������վ����
		Sql = "select cityid from T_City Where citypostcode = '"&citypostcode&"'"
		If id <> 0 Then
			Sql = Sql & " and cityid<>"&id
		End If
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "����Ѿ����ڣ�"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		sql = "select max(cityid) from t_city"
		Set crs = Dream3CLS.Exec(sql)
		
		s_city_id = crs(0) + 1
		
		

		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_City "
		If  id <> 0 Then
			Sql = Sql & " and cityid="&id
		End If
		
		Rs.open Sql,conn,1,2
		If id = "" or id="0" Then
			Rs.AddNew
			Rs("cityid") = s_city_id
			Rs("enabled")= 1
			Rs("depth")= 2
		End If
		Rs("cityname") 	= cityname
		Rs("citypostcode") 	= citypostcode
		Rs("CitySimple") 	= CitySimple
		Rs("cityprefix") 	= cityprefix
		Rs("citypinyin")= citypinyin
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		'gMsgFlag = "S"
		Dream3CLS.showMsg "����ɹ�","S","city.asp?provincecode="&provincecode
		
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
		provincecode = Dream3CLS.RParam("provincecode")
		
		
		id = Dream3CLS.ChkNumeric(Request("id"))
		classifier=  Request("classifier")
		If id <> 0 Then
			operate = "�޸ĳ���"
		else 
			operate = "��������"
		End If
		
	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl">���й���</span>
        <span class="fr">
        	
        </span>
    </div>
    <div class="say">
        �ϼ�ʡ�ݱ�ţ�<%=provincecode%>
    </div>
</div>

<div id="box">

                <div class="sect">
                    <form method="post" action="?act=save">
						<div class="wholetip clear"><h3>1��<%=operate%><%=title%>
</h3></div>
                        <div class="field">
                            <label>�������ƣ�</label>
                            <input type="text" name="cityname" value="<%=cityname%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>ƴ����</label>
                            <input type="text" name="citypinyin" value="<%=citypinyin%>" class="f-input" size="30">
                        </div>
                        <div class="field">
                            <label>��ţ�</label>
                            <input type="text" name="CityPostCode" value="<%=CityPostCode%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>��ƣ�</label>
                            <input type="text" name="CitySimple" value="<%=CitySimple%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>����ĸ��</label>
                            <input type="text" name="cityprefix" value="<%=cityprefix%>" class="f-input" size="30">
                        </div>
						
						<div class="act">
							 <input type="hidden" name="id" value="<%=id%>"/>
							 <input type="hidden" name="provincecode" value="<%=provincecode%>"/>
                             <input type="submit" class="formbutton" value="����">
                        </div>
                    </form>
                </div>

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->
