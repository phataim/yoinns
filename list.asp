<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->
<!--#include file="common/inc/city_common.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo,strTotalRecord
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim sitename,group_id,enabled,to_group_id,city_id
Dim starttime,sitetitle
Dim groupComboItem,cityComboItem

Dim fromDate,toDate,fromdate_str,todate_str
Dim citycode ,cityname,keyword
Dim orderby
Dim leaseType ,lodgeType,district

Dim p  ' �۸�
Dim l ' ��������


Dim userIdArr()

'��ҳ��ͷ������¼�����
Dim searchname,price,service,facilities ,searchp

'�¼����ݽ���

Set groupMap = new AspMap
Set cityMap = new AspMap
Set userMap = new AspMap


	Action = Request.QueryString("act")
	Select Case Action
		Case Else
			Call Main()
	End Select
	
	
	
	Sub Main()		

		' ����
		l = Dream3CLS.RSQL("l")
		
		'��ʼ������
		fromdate_str=Dream3CLS.RParam("fromDate")
		todate_str =Dream3CLS.RParam("toDate")
		if fromdate_str = "" Then
			fromDate=date()
		else
			fromDate=CDate(fromdate_str)
		end if
		
		if (todate_str = ""  or fromdate_str>=todate_str) Then
			toDate=fromDate+1
		else
			toDate=CDate(todate_str)
		end if
		
		
		'===================================================================== mike
		service_m=Dream3CLS.RParam("service_m") '�������׼��� mike
		session("service_m")="" '���ֵ
		session("i_t")=""
		
		if (not Instr(service_m,"|")>0) then '������| ��ʼֵ ����
			Set tRs = Server.CreateObject("adodb.recordset")			
			Sql = "select id from T_Facility Where enabled='Y'" '��ȡ���ݿ����ж�����
			tRs.open Sql,conn,1,1
				i_t=tRs.recordcount-1
			tRs.Close
			Set tRs = Nothing			
			service_m=1
			for i=0 to i_t
				service_m=service_m&"|0"
			next
		end if
		session("service_m")=service_m
		session("i_t")=i_t
 'response.Write service_m
' response.end
 'response.Write "<br>"
 'response.Write service_m
 'response.Write "<br>"
 'response.Write len(session("service_m"))
	'response.Write len(service_m)
		'===================================================================== mike

		'��������
		searchname=Dream3CLS.RParam("searchname")'�����õ�����
			session("searchname")=searchname 'mike
		keyword = Dream3CLS.RParam("keyword")'    index����û������
		orderby  = Dream3CLS.RParam("orderby")'    index����û������
		leaseType  = Dream3CLS.RParam("leaseType")'    index����û������
		lodgeType  = Dream3CLS.RParam("lodgeType")'    index����û������
		district =  Dream3CLS.RParam("district")'
		cityname=Dream3CLS.RParam("cityname")'    index����û������
		citycode = Dream3CLS.RParam("city")'�˴�citycodeΪ�� index����û������
		price= Dream3CLS.RParam("price")'    index����û������
		service=Dream3CLS.RParam("service")'    index����û������
		if price="" then
		   price=0
		  
		else
			price=cint(price)
		end if
		'������
		Select Case price
			Case 0
			
				searchp = ""
			Case 40
				searchp = " and dayrentprice<50"
			Case 80
				searchp = " and (dayrentprice<100 and dayrentprice>=50)"
			Case 120
				searchp = " and (dayrentprice<150 and dayrentprice>=100)"
			Case 160
				searchp = " and (dayrentprice<200 and dayrentprice>=150)"
			Case 230
				searchp = " and (dayrentprice<250 and dayrentprice>=200)"
			Case 280
				searchp = " and (dayrentprice<300 and dayrentprice>=250)"
			Case 320
				searchp = " and dayrentprice>=300"
			Case else
				Call Dream3CLS.MsgBox2("��������",0,"0")
		End Select
		
		'If (fromDate <> "yyyy-mm-dd") and (toDate <> "yyyy-mm-dd") then
		 	'if DateDiff("d",fromDate,toDate)<1 then
				'Call Dream3CLS.MsgBox2("�˷�����Ҫ������ס����",0,"0")
			
			'end if
		'end if
		
		If fromDate <> "yyyy-mm-dd" Then
		
			If IsSQLDataBase = 1 Then
				searchp = searchp &" and Datediff(s,startDate,'"&fromDate&"') >= 0 "
			Else
				searchp = searchp &" and Datediff('s',startDate,'"&fromDate&"') >= 0 "
			End If

		End If

		If toDate <> "yyyy-mm-dd" Then
		
			endTimeTomrrow = Dream3CLS.GetStartTime(dateadd("d",1,CDate(toDate)))
			
			If IsSQLDataBase = 1 Then
				searchp = searchp &"and Datediff(s,expireDate,'"&endTimeTomrrow&"') <= 0 "
			Else
				searchp = searchp &"and Datediff('s',expireDate,'"&endTimeTomrrow&"') <= 0 "
			End If
			
		End If

		Sqlp = "Select distinct hid,facilities from T_Product Where  1=1 and state='normal' "
		sqlp = sqlp & searchp 
		
		Set pRs = Dream3CLS.Exec(Sqlp)
		Do While Not pRs.EOF
		facilities = ","&pRs("facilities")&","
		if service<>"" then
			If instr(facilities,","&service&",") Then
				prid = prid&pRs("hid")&","
			End If
		else
			prid = prid&pRs("hid")&","
		end if
		pRs.Movenext
		Loop
		if right(prid,1)="," then 
			prid=left(prid,len(prid)-1) 
		end if 
		if prid<>"" then
			searchStr=" and h_id in ("&prid&")"
		else
			searchStr=" and h_id in (-1)"
		end if



	'======================= '����  mike
		service_m=right(service_m,len(service_m)-2) '�ų���һ��ѡ��, Ҳ��������
		service_no=Split(service_m,"|") '����

		ij=0
		f_id=""
		Set tRs = Server.CreateObject("adodb.recordset")			
		Sql = "select id from T_Facility Where enabled='Y'" '��ȡ���ݿ����ж�����
		tRs.open Sql,conn,1,1
			i_t=tRs.recordcount-1
		Do While Not tRs.EOF
			if cint(service_no(ij))=1 then '����е���1��, �ͼ�¼��T_Facility���IDֵ
				f_id=f_id&","&tRs("id")
			end if
			
			ij=ij+1
		tRs.Movenext
		Loop
		tRs.Close
		Set tRs = Nothing
		if left(f_id,1)="," then 'ȥ�����ය��
			f_id=right(f_id,len(f_id)-1) 
		end if 
		'response.Write f_id
		'response.end
		'f_id="10,12,13"
		'facilities="6,7,14"
	
		f_id_no=Split(f_id,",") '����
		prid=""

		Sqlp = "Select distinct hid,facilities from T_Product Where  1=1 and state='normal' "
		sqlp = sqlp & searchp 
	
		Set pRs = Dream3CLS.Exec(Sqlp)
		Do While Not pRs.EOF
		
			facilities = ","&pRs("facilities")&","
			'facilities="6,7,14"
			facilities_no=Split(facilities,",") '����
			same_id=0
			for i=0 to Ubound(f_id_no) 'ѭ����ѡ��õ�����
				for j=0 to Ubound(facilities_no) 'ѭ�����ӵ���������
					if f_id_no(i)=facilities_no(j) then
						same_id=same_id+1
					end if
				next		
			next
	
			if same_id=Ubound(f_id_no)+1 then '������ѡ��ʱ 
				'If instr(facilities,","&service&",") Then '��ѡ�е����������ݶԱ�, ����, �ѷ��ӵ�id������
					prid = prid&pRs("hid")&","
				'End If
			end if
			
			'response.Write f_id
			'response.Write "<br>"
			'response.Write facilities
			'response.Write "<br>"
			'response.Write same_id
			'response.Write "<br>"
			'response.Write Ubound(f_id_no)+1
			'response.Write "<br>-------<br>"
			
			'response.end
			pRs.Movenext
		
		Loop

		
		'session("prid")=prid
		'response.Write facilities 
		'response.end	
		if right(prid,1)="," then 'ȥ������
			prid=left(prid,len(prid)-1) 
		end if 
		if prid<>"" then
			searchStr=" and h_id in ("&prid&")"
		else
			searchStr=" and h_id in (-1)"
		end if
		'response.Write "<br>"
		'response.Write searchStr
		'response.end
	'========================== mike

		
		'�����ݽ���
		If cityname <> "" Then
			Sql = "Select cityname,citypostcode from T_City Where 1=1 and (depth = 2 or zxs = 1) and cityname like '%"&cityname&"%' "
			Set Rs = Dream3CLS.Exec(sql)
			If Rs.EOF Then
				Call Dream3CLS.MsgBox2("��ѡ���ѿ�ͨ�ĳ��У�",0,"0")
				Response.End()
			End If
			citycode = Rs("citypostcode")
			G_City_NAME=cityname
		End If
		if citycode <> "" Then
			'����ȫ��citycodeΪcitycode
			'ȫ�ֳ���ID
			G_City_ID = citycode
			G_City_NAME = cityname
			Response.Cookies(DREAM3C).Expires = Date + 365
			Response.Cookies(DREAM3C)("_UserCityID") = citycode
			Call GetCityName()
		End if
		If district = "" Then
			If citycode <> "" Then
				If Right(citycode,4) = "0000" Then
						searchStr =searchStr&" and h_citycode like '%"&Left(citycode,2)&"%'" 'mike
					Else
						searchStr = searchStr&" and h_citycode like '%"&Left(citycode,4)&"%'" 'mike
					End If
				
			End If
		Else
			searchStr = searchStr& " and h_citycode =  '"&district&"'"
		End If
		
		If searchname = "�õ�����" or searchname = "����Ƶ�����" Then
			searchname = ""
		End If
		
		If searchname <> "" Then
			searchStr = searchStr &" and h_hotelname like '%"&searchname&"%' "
		End If
		
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl & "?city="&citycode&"&fromDate="&Dream3CLS.TimeFormateToTwoBits(fromDate)&"&toDate="&Dream3CLS.TimeFormateToTwoBits(toDate)&"&orderby="&orderby&"&leaseType="&leaseType&"&lodgeType="&lodgeType&"&price="&price&"&service="&service
		
		intPageNow = request.QueryString("page")

		intPageSize = 6
		
		Select Case orderby
			'Case "default"
				'sqlOrder = "order by id desc"
			'Case "price_low2high"
				'sqlOrder = " order by dayrentprice asc"
			'Case "price_high2low"
				'sqlOrder = " order by dayrentprice desc"
			Case else
				sqlOrder = " order by h_ordertime desc"
		End Select
		
		sql = "select * from T_hotel Where 1=1 "
		sql = sql & searchStr &sqlOrder
		't(sql)
		'response.write sql

		sqlCount = "SELECT Count([h_id]) FROM [T_hotel] where 1=1"&searchStr
		
	
		Set clsRecordInfo = New Cls_PageView
			clsRecordInfo.intRecordCount = 2816
			clsRecordInfo.strSqlCount = sqlCount
			clsRecordInfo.strSql = sql
			clsRecordInfo.intPageSize = intPageSize
			clsRecordInfo.intPageNow = intPageNow
			clsRecordInfo.strPageUrl = strLocalUrl
			clsRecordInfo.strPageVar = "page"
		clsRecordInfo.objConn = Conn		
		arrU = clsRecordInfo.arrRecordInfo
		strPageInfo = clsRecordInfo.strPageInfo
		strTotalRecord  = clsRecordInfo.strTotalRecord
		Set clsRecordInfo = nothing
	
	End Sub
	
	
%>
<%
'
G_Title_Content = G_City_NAME & "ס��_"&G_City_NAME&"�ù�_"&G_City_NAME&"�Ƶ�_"&G_City_NAME&"���϶���"&" "&"���ݴ�ѧ��ס��|" & Dream3CLS.SiteConfig("SiteName")

G_Keywords_Content = G_City_NAME & "ס��,"&G_City_NAME&"�ù�,"&G_City_NAME&"�ⷿ,"&G_City_NAME&"�Ƶ�,"&G_City_NAME&"���϶���,"&G_City_NAME
G_Description_Content = "���ùݴ�ѧ��"&G_City_NAME&"վ,ÿ�췢������"&G_City_NAME&"�ùݡ��Ƶꡢ�ⷿ��ס����Ϣ�����������������ɶ���"&G_City_NAME&"���ˡ��ɿ������ʵķ��䡣����"&G_City_NAME&"���õ�,�������ù�"&G_City_NAME&"վ��"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<style>
*{padding:0; margin:0}

#totop{position:fixed;bottom:40px;right:10px;z-index:999;width:71px; cursor:pointer; display:none;}
*html #totop{position:absolute;cursor:pointer;right:10px; display:none;top:expression(eval(document.documentElement.scrollTop+document.documentElement.clientHeight)-112+"px")}
#totop a{display:block;width:71px;height:24px;padding-top:48px;background:url(../images/toTop.gif) no-repeat;text-align:center;color:#888}
#totop a.cur{background-position:-88px 0;text-decoration:none;color:#3a9}
</style>
<script language="javascript" src="<%=VirtualPath%>/common/js/inad_duice.js"></script>
<script language="javascript" src="<%=VirtualPath%>/common/js/time.js"></script>

<script type="text/javascript">
function nTabs(thisObj,Num){
if(thisObj.className == "active")return;
var tabObj = thisObj.parentNode.id;
var tabList = document.getElementById(tabObj).getElementsByTagName("li");
for(i=0; i <tabList.length; i++)
{
if (i == Num)
{
   thisObj.className = "active"; 
      document.getElementById(tabObj+"_Content"+i).style.display = "block";
}else{
   tabList[i].className = "normal"; 
   document.getElementById(tabObj+"_Content"+i).style.display = "none";
}
} 
}
</script>

<div class="content_wrapper">
	
	<div>
		<div style=" position : absolute;margin-top:40px; margin-left:50px;">
			<a href="#"><img src="../images/bannerBtn.png" onclick="countAppDownload();"></a>
		</div>
		<div style=" position : absolute;margin-top:40px; margin-left:250px;">
			<img src="../images/bannerBtn2.png" >
		</div>
		<img src="../images/mobilebanner.png" >
	</div>

	<form method="post" name="searchForm" action="list.asp">
    <div class="list_search">
    	<div class="search_bg">
        	<select id="city" name="city" class="search_input2">
			
			<option value="0" selected="selected">����</option><!-- mike-->
			<%
			
			Sql = "Select cityname,citypostcode from T_City Where  depth=2 and enabled = 1 Order By cityname,citypostcode" 
			Set hCityRs = Dream3CLS.Exec(Sql)
			If Not hCityRs.EOF Then
			hCityRs.MoveFirst
			Do While Not hCityRs.EOF
			%>
              <option value="<%=hCityRs("citypostcode")%>" <%if citycode=hCityRs("citypostcode") then %>selected="selected"<%end if %>><%=hCityRs("cityname")%></option>
			<%
			hCityRs.Movenext
			Loop
			End If
			if fromDate="" or fromDate="yyyy-mm-dd" then fromDate=Date() 'mike
			if toDate="" or toDate="yyyy-mm-dd" then toDate=Date()+1 'mike
			%>
            </select>
			
			<input type="text" value="<%if session("searchname")="" then%>����Ƶ�����<%else%><%=session("searchname")%><%end if%>" autocomplete="off"  name="searchname" id="searchname" class="search_input" onFocus="if(this.value == '����Ƶ�����') this.value = ''" onblur="if(this.value == '') this.value = '����Ƶ�����'"> 
            <input type="text" readonly="readonly" value="<%=Dream3CLS.TimeFormateToTwoBits(fromDate)%>" id="fromDate" name="fromDate" class="input2 " onclick="WdatePicker({minDate:'%y-%M-%d',onpicked:function(){former_select('fromDate','toDate')}})"/>
			<!---- onclick="return showCalendar('fromDate', 'y-m-dd');"  />--->
            <input type="text" readonly="readonly" value="<%=Dream3CLS.TimeFormateToTwoBits(toDate)%>" id="toDate" name="toDate" class="input2 "  onclick="WdatePicker({minDate:'#F{$dp.$D(\'fromDate\',{d:+1})}'})"/>
			<!----onclick="return showCalendar('toDate', 'y-m-dd');"  />----->      
        </div>
        <div class="searh_right">
        <input type="button" value=""  class="input3" id="searchbtn" onclick="seach_go()">
        </div>
    </div>
    </form>
    <div class="cates_list">
<% 
 '===========================mike
	service_no=Split(session("service_m"),"|") '����
	i_t=Ubound(service_no)+1 

 '===========================mike
%>   	
  <!-- mike start-->
      
		<div class="line clearfix" style="display:block ">
            <span class="item s_fc2">����۸�</span>
			<%If price = 0 Then%>
            <span class="item item_sel">����</span>
			<%Else%>
			<a href='javascript:is_pr("0");' class="s_fc4 item">����</a> 
			<%End If%>
			<%If price < 50 and price>0 Then%>
            <a href="#" class="item item_sel">50Ԫ����</a> 
			<%Else%>
			<a href='javascript:is_pr("40");' class="s_fc4 item">50Ԫ����</a> 
			<%End If%>
			<%If price < 100 and price>=50 Then%>
            <a href="#" class="item item_sel">50-100Ԫ</a> 
			<%Else%>
			<a href='javascript:is_pr("80");' class="s_fc4 item">50-100Ԫ</a> 
			<%End If%>
			<%If price < 150 and price>=100 Then%>
            <a href="#" class="item item_sel">100-150Ԫ</a> 
			<%Else%>
			<a href='javascript:is_pr("120");' class="s_fc4 item">100-150Ԫ</a> 
			<%End If%>
			<%If price < 200 and price>=150 Then%>
            <a href="#" class="item item_sel">150-200Ԫ</a> 
			<%Else%>
			<a href='javascript:is_pr("160");' class="s_fc4 item">150-200Ԫ</a> 
			<%End If%>
			<%If price < 250 and price>=200 Then%>
            <a href="#" class="item item_sel">200-250Ԫ</a> 
			<%Else%>
			<a href='javascript:is_pr("230");' class="s_fc4 item">200-250Ԫ</a> 
			<%End If%>
			<%If price < 300 and price>=250 Then%>
            <a href="#" class="item item_sel">250-300Ԫ</a> 
			<%Else%>
			<a href='javascript:is_pr("280");' class="s_fc4 item">250-300Ԫ</a> 
			<%End If%>
			<%If price>=300 Then%>
            <a href="#" class="item item_sel">300Ԫ����</a> 
			<%Else%>
			<a href='javascript:is_pr("320");' class="s_fc4 item">300Ԫ����</a> 
			<%End If%>
        </div> 
            <div class="line clearfix" style="display:block ">
            <span class="item s_fc2">�������</span>
			<%
			'============================= mike
				If cint(service_no(0))=1 Then%>
				<a href='javascript:is_pt("0");' class="item item_sel">����</a> 
				<%Else%>
				<a href='javascript:is_pt("0");'  class="s_fc4 item">����</a> 
				<%End If%>
                <input type="text" value="<%=service_no(0)%>" id=pt_<%=0%> style="display:none;"/>
			<%
			Sqls = "select id,cname from T_Facility Where enabled='Y' order by seqno desc"		
			Set f_Rs = Dream3CLS.Exec(sqls)
			i=1
			Do While Not f_Rs.EOF
			
				If cint(service_no(i))=1 Then%>
                <a href='javascript:is_pt("<%=i%>");' class="item item_sel"><%=f_Rs("cname")%></a> 
                <%Else%>
                <a href='javascript:is_pt("<%=i%>");'  class="s_fc4 item"><%=f_Rs("cname")%></a> 
				<%End If%>
                <input type="text" value="<%=service_no(i)%>" id=pt_<%=i%> style="display:none;" /><%
			f_Rs.MoveNext
			i=i+1
			Loop
			'============================= mike

			%>
        </div>

 <script type="text/javascript">
 
function is_pr(aa)  //�۸�
{    

	var m; //���� Ŀǰ����״̬
	for(var i=0;i<<%=i_t%>;i++) {
		if (i==0) {
			m=document.getElementById("pt_"+i).value;
		}
		else{
			m=m+'|'+document.getElementById("pt_"+i).value
		}
	}
	
	//location.href='district
	var url='list.asp?service_m='+m;
	url=url+'&searchname='+document.getElementById("searchname").value;
	url=url+'&citycode='+document.getElementById("city").value;
	url=url+'&city='+document.getElementById("city").value;
	url=url+'&price='+aa
	url=url+'&fromDate='+document.getElementById("fromDate").value;
	url=url+'&toDate='+document.getElementById("toDate").value;

	location.href=url
		//alert(url)
	//alert(m)
}

function is_pt(aa)  //����
{    
	if (aa==0){ //
		for(var i=0;i<<%=i_t%>;i++) {
			if (i!=0) //����һ����
			{ document.getElementById("pt_"+i).value=0;}
		}
	}
	else 
	{
		if (document.getElementById("pt_"+aa).value==1) //��Ǹı�������
		{document.getElementById("pt_"+aa).value=0}
		else
		{document.getElementById("pt_"+aa).value=1}
	
		//������ʱ�Ĵ���
		var mm=0; 
		for(var i=0;i<<%=i_t%>;i++) {
			mm=mm+document.getElementById("pt_"+i).value;
		}
		if (mm==0)
		{document.getElementById("pt_"+aa).value=1
		alert("����ѡ��һ������!");
		} //���ո��Ǹ����1
		else (mm!=0)
		{document.getElementById("pt_0").value=0;} //����һ����ûɫ
		// end
		
		var m; //���� Ŀǰ����״̬
		for(var i=0;i<<%=i_t%>;i++) {
		
			if (i==0) {
				m=document.getElementById("pt_"+i).value;
			}
			else{
				m=m+'|'+document.getElementById("pt_"+i).value
			}
		}
	}

	var url='list.asp?service_m='+m;
	url=url+'&searchname='+document.getElementById("searchname").value;
	url=url+'&citycode='+document.getElementById("city").value;
	url=url+'&city='+document.getElementById("city").value;
	url=url+'&price=<%=price%>'
	url=url+'&fromDate='+document.getElementById("fromDate").value;
	url=url+'&toDate='+document.getElementById("toDate").value;

	location.href=url
		//alert(url)
	//alert(m)
}
function seach_go()  //����
{    
	var m; //���� Ŀǰ����״̬
	for(var i=0;i<<%=i_t%>;i++) {
	
		if (i==0) {
			m=document.getElementById("pt_"+i).value;
		}
		else{
			m=m+'|'+document.getElementById("pt_"+i).value
		}
	}
	var url='list.asp?service_m='+m;
	url=url+'&searchname='+document.getElementById("searchname").value;
	url=url+'&citycode='+document.getElementById("city").value;
	url=url+'&city='+document.getElementById("city").value;
	url=url+'&price=<%=price%>'
	url=url+'&fromDate='+document.getElementById("fromDate").value;
	url=url+'&toDate='+document.getElementById("toDate").value;

	location.href=url
}
</script>
<!-- mike end-->
    </div>
    
    <div id="room_list">
    	
        <div class="con_left">
        	
            <div class="room_nav">
            	<div class="menu_tit">
                	<h1><%If  IsNull(citycode) or citycode="" Then Response.write("���е�")  Else Response.write(G_City_NAME)  End If%>ס����Ϣ</h1>
                    <span>����<b><%=strTotalRecord%></b>�����������Ľ��</span>
                </div>
                <select name="orderby" style="display:none ">
                <option <%If orderby = "default" Then%>selected<%End If%> value="default">�Ƽ�����</option>
                <option <%If orderby = "price_low2high" Then%>selected<%End If%> value="price_low2high">�۸��ɵ͵���</option>
                <option<%If orderby = "price_high2low" Then%>selected<%End If%>  value="price_high2low">�۸��ɸߵ���</option>
                </select>
            </div>
            
            <div class="room_con">
			<%
					'seq = 1
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
							s_id = arrU(0,i)
							h_hotelname = arrU(1,i)
							h_img = arrU(6,i)
							If h_img <> "" Then 
								image = "../../"&h_img
							Else
								image = "/images/noimage.gif"
							End If
							h_citycode=arrU(4,i)
							h_address=arrU(5,i)
							h_line=arrU(9,i)
					%>
            	<DIV class=hotelList>
            		<DIV class=hotelInfo>
						<DIV class=picwk>
			<A title="<%=h_hotelname%>" href="show.asp?hid=<%=s_id%>&fromdate=<%=Dream3CLS.TimeFormateToTwoBits(fromDate)%>&todate=<%=Dream3CLS.TimeFormateToTwoBits(toDate)%>" target=_blank><IMG class=pic title="<%=h_hotelname%>" alt="<%=h_hotelname%>" src="<%If IsNull(image) or image="" Then response.Write("images/noimage.gif") else response.Write(image)%>" width="121" height="121"></A>
			            </DIV>
						<DIV class=inftop>
							<h2>
							<DT>
							<A class=crown title=<%=h_hotelname%> href="show.asp?hid=<%=s_id%>&fromdate=<%=Dream3CLS.TimeFormateToTwoBits(fromDate)%>&todate=<%=Dream3CLS.TimeFormateToTwoBits(toDate)%>" target=_blank><%=h_hotelname%></A>
  							</DT></h2>
  							<DD>����<%=Dream3Product.GetCityAdd(h_citycode)%> </DD>
 							 <DD>��ַ��<%=h_address%></DD>
 							 <DD>��ͨ·�ߣ� <%=h_line%></DD>
  						</DIV>
					</DIV>
					<DIV class=houseInfo>
						<div class="housetitle">
							<li>����</li>
							<li>��ס����</li>
							<li>���</li>
							<li>������</li>
							<li>ƽ�ռ�</li>
							<li>��ĩ��</li>
							
						</div>
						<%
						if s_id<>"" then 
					sql2 = "Select * From T_Product where state='normal' and online='Y' and enabled='Y' and hid="&s_id
					sql2=sql2&searchp
					Set Rs2 = Dream3CLS.Exec(sql2)
					Do While Not Rs2.EOF
					%>
						<div class="housetext">
							<li><%=Rs2("houseTitle")%></li>
							<li><%=Rs2("guestnum")%></li>
							<li><%=Rs2("area")%></li>
							<li><%=Rs2("roomsnum")%></li>
							<li><%=Rs2("dayrentprice")%></li>
							<li><%=Rs2("weekrentprice")%></li>
							<li><a href="detail.asp?pid=<%=Rs2("id")%>&fromdate=<%=Dream3CLS.TimeFormateToTwoBits(fromDate)%>&todate=<%=Dream3CLS.TimeFormateToTwoBits(toDate)%>" target=_blank>�鿴</a></li>
						</div>
					<%
					Rs2.Movenext
					Loop
					end if
					%>
				 </DIV>
				 <div class="more"><a href="show.asp?hid=<%=s_id%>&fromdate=<%=Dream3CLS.TimeFormateToTwoBits(fromDate)%>&todate=<%=Dream3CLS.TimeFormateToTwoBits(toDate)%>" target=_blank>�鿴����</a></div>
		</DIV>
		<%
						Next
						
					  End If
					 %>
		
		
            </div>
            
			<%If IsArray(arrU) Then%>
            <div>
                <%= strPageInfo%>
            </div>
            <%End If%>
        </div>
        
        <div class="con_right">
        	
           <!--#include file="common/inc/flow_common.asp"--> 
        
           <!--#include file="common/inc/service_common.asp"--> 
            
        </div>
        
    </div>
    
</div>
<script type="text/javascript" src="<%=VirtualPath%>/common/js/manhuatoTop.1.0.js"></script>
<script type="text/javascript" src="<%=VirtualPath%>/common/js/common.js"></script>
<script type="text/javascript" src="<%=VirtualPath%>/common/js/city_jquery.js"></script>
<script type="text/javascript" src="<%=VirtualPath%>/common/js/jquery.autocomplete.min.js"></script>


<script type="text/javascript">
$("#cityname").click(function (){
	$("#cityBox").removeClass('hidden');
});
$("#close").click(function (){
	$("#cityBox").addClass('hidden');
});
function setCity(en,city){
	if (en){
		$("#cityname").val(city);
		$("#city").val(en);
		$("#cityBox").addClass('hidden');
	}
}
var date = new Date();
var dateY = date.getFullYear();
var dateM = (date.getMonth()+1) > 9 ? (date.getMonth()+1) : '0' + (date.getMonth()+1);
var dateD = date.getDate() > 9 ? date.getDate() : '0' + date.getDate();
date.setDate(date.getDate() + 1);
var tY = date.getFullYear();
var tM = (date.getMonth()+1) > 9 ? (date.getMonth()+1) : '0' + (date.getMonth()+1);
var tD = date.getDate() > 9 ? date.getDate() : '0' + date.getDate();
var today = dateY + '-' + dateM + '-' + dateD;
$("#from").val(today);
var tomorrow = tY + "-" + tM + "-" + tD;
$("#to").val(tomorrow);
$("#from").focus(function (){
	if ($("#from").val() == today){
		$("#from").val('');
	}
});
$("#from").blur(function (){
	if (!$("#from").val()){
		$("#from").val(today);
	}
});
$("#to").focus(function (){
	if ($("#to").val() == tomorrow){
		$("#to").val('');
	}
});
$("#to").blur(function (){
	if (!$("#to").val()){
		$("#to").val(tomorrow);
	}
});



$("#cityname").focus(function (){
	if ($("#cityname").val() == '��������Ҫ��ס�ĳ���'){
		$("#cityname").val('');
	}
});
$("#cityname").blur(function (){
	if (!$("#cityname").val()){
		$("#cityname").val('��������Ҫ��ס�ĳ���');
	}
});
$("#cityname").result(function (event, data, formatted){
	$("#city").val(data.en);
});


$("#sForm").submit(function (){

	if ($("#city").val()){
		var url = '';
		if ($("#from").val()){
			url = 'date-' + $("#from").val();
			if ($("#to").val()){
				url += '--' + $("#to").val();
			}else {
				url += '--' + $("#from").val();
			}
			url += '.html';
		}
		window.location.href = "/city/" + $("#city").val() + '/' + url;
		return false;
	}
	alert('��ѡ�����');
	return false;
});
$("#getHdata").submit(function (){
	if ($("#getHid").val() && /^\d+$/.test($("#getHid").val())){
		window.location.href = "/house/" + $("#getHid").val() + ".html";
		return false;
	}
	$("#getHid").val('');
	alert('�����뷿����');
	return false;
});
$("#getHousePic li a").mouseover(function (){
	$("#changePic").attr('src',$(this).attr('rel'));
});

function checkTab(id,obj,self,classname){
	$(obj).addClass('hidden');
	$(obj[id]).removeClass('hidden');
	$(self).attr('class',classname);
}
</script>

<script type="text/javascript">
//$(function (){
//	$(window).manhuatoTop({
//		showHeight : 100,//���ù����߶�ʱ��ʾ
//		speed : 500 //���ض������ٶ��Ժ���Ϊ��λ
//	});
//});
</script>
<div><!--#include file="common/inc/footer_user.asp"--></div>