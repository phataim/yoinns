<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->

<%
Dim Action
Dim provincecode,citycode
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
	
		citycode = Dream3CLS.RParam("citycode")
		cityname =  Dream3CLS.RParam("cityname")
		citypinyin=  Dream3CLS.RParam("citypinyin")
		CityPostCode=  Dream3CLS.RParam("CityPostCode")
		CitySimple=   Dream3CLS.RParam("CitySimple")
		cityprefix=  Dream3CLS.RParam("cityprefix")
		id = Dream3CLS.ChkNumeric(Request.Form("id"))
		'validate Form
		If cityname = "" Then
			gMsgArr = "中文名称不能为空！"
		End If
		If citypinyin = "" Then
			gMsgArr = gMsgArr & "|" & "拼音不能为空！"
		End If
		If CityPostCode = "" Then
			gMsgArr = gMsgArr & "|" & "编号不能为空！"
		End If
		If CitySimple = "" Then
			gMsgArr = gMsgArr & "|" & "简称不能为空！"
		End If
		If len(cityprefix) <> 1 Then
			gMsgArr = gMsgArr & "|" & "首字母必须为1个英文字符！"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		
		If Len(CityPostCode) <> 6  Then
			gMsgArr = gMsgArr & "|" & "编号必须为6位数字！"
		End If
		
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		If Left(CityPostCode,4) <> left(citycode,4) Then
			gMsgArr = gMsgArr & "|" & "编号前四位必须与城市前四位相同！"
		End If
		
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If
		
		'判断是否已经存在网站名称
		Sql = "select cityid from T_City Where citypostcode = '"&citypostcode&"'"
		If id <> 0 Then
			Sql = Sql & " and cityid<>"&id
		End If
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Not Rs.EOF Then
			gMsgArr = "编号已经存在！"
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
			Rs("depth")= 3
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
		Dream3CLS.showMsg "保存成功","S","district.asp?citycode="&citycode
		
	End Sub
	
	Sub ShowEdit()	
		'operate = "修改"
		id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		classifier=  Request.Querystring("classifier")
		sql = "select id,cname,ename,category,seqno from T_Category Where classifier='"&classifier&"' and id="&id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			response.End()
		End If
		cname = Rs("cname")
		ename = Rs("ename")
		category = Rs("category")
		seqNo = Rs("seqNo")
		
		Call Main()
	End Sub

	
	Sub Main()		
		citycode = Dream3CLS.RParam("citycode")
		
		
		id = Dream3CLS.ChkNumeric(Request("id"))
		classifier=  Request("classifier")
		If id <> 0 Then
			operate = "修改地区"
		else 
			operate = "新增地区"
		End If
		
	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl">地区管理</span>
        <span class="fr">
        	
        </span>
    </div>
    <div class="say">
        上级城市编号：<%=citycode%>
    </div>
</div>

<div id="box">

                <div class="sect">
                    <form method="post" action="?act=save">
						<div class="wholetip clear"><h3>1、<%=operate%><%=title%>
</h3></div>
                        <div class="field">
                            <label>中文名称：</label>
                            <input type="text" name="cityname" value="<%=cityname%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>拼音：</label>
                            <input type="text" name="citypinyin" value="<%=citypinyin%>" class="f-input" size="30">
                        </div>
                        <div class="field">
                            <label>编号：</label>
                            <input type="text" name="CityPostCode" value="<%=CityPostCode%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>简称：</label>
                            <input type="text" name="CitySimple" value="<%=CitySimple%>" class="f-input" size="30">
                        </div>
						<div class="field">
                            <label>首字母：</label>
                            <input type="text" name="cityprefix" value="<%=cityprefix%>" class="f-input" size="30">
                        </div>
						
						<div class="act">
							 <input type="hidden" name="id" value="<%=id%>"/>
							 <input type="hidden" name="citycode" value="<%=citycode%>"/>
                             <input type="submit" class="formbutton" value="保存">
                        </div>
                    </form>
                </div>

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->
