<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->
<!--#include file="common/inc/city_common.asp"-->
<!--#include file="common/inc/index_ad_show.asp"-->
<!--#include file="common/api/cls_quartz.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim sitename,group_id,enabled,to_group_id,city_id
Dim starttime,sitetitle
Dim groupComboItem,cityComboItem

Dim  totalCitys, totalOwners, totalProducts

Dim p  ' �۸�
Dim l ' ��������
Dim fromDate ,toDate

Dim userIdArr()

'��ҳ��ͷ������¼�����
Dim  s_citycode,ad_image,ad_url,ad_title,datenow
datenow=date()
'�¼����ݽ���
Set userMap = new AspMap


	Action = Request.QueryString("act")
	Select Case Action
		Case Else
			Call Main()
	End Select
	
	
	
	Sub Main()		
		'����
		Dream3Quartz.InvokeProductState()
		
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		
		intPageNow = request.QueryString("page")

		intPageSize = 6
		
		
		endTimeTomrrow = Dream3CLS.GetStartTime(now())
					
		If IsSQLDataBase = 1 Then
			searchStr = searchStr &" and Datediff(d,startDate,'"&endTimeTomrrow&"') >= 0 "
		Else
			searchStr = searchStr &" and Datediff('d',startDate,'"&endTimeTomrrow&"') >= 0 "
		End If

		sqlOrder = sqlOrder & " Order By id desc"
		
		Sql = "Select top 6 id,state,housetitle,lodgetype,leasetype,roomtitle,image,create_time,address,dayrentprice,weekrentprice,monthrentprice,user_id,guestnum,city_code from T_Product Where 1=1  and state ='normal' and recommend='Y' and online = 'Y' "
		sql = sql & searchStr & sqlOrder
		
		sqlCount = "SELECT Count([id]) FROM [T_Product] where 1=1"&searchStr
		
	
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
		
		
		'ѭ�����飬��Ѱid����������
		If IsArray(arrU) Then
			For i = 0 to UBound(arrU, 2)
				ReDim Preserve userIdArr(i)
				userIdArr(i) = arrU(12,i)
			Next
			
			Call Dream3Product.getUserMap(userIdArr,userMap)
			
		End If
	End Sub
	
	'totalCitys, totalOwners, totalProducts
	sql = "Select count(*) From T_city where (depth =2 Or zxs = 1)"
	Set totalRs = Dream3CLS.Exec(sql)
	totalCitys = totalRs(0)
	
	sql = "Select count(*) From T_User where state=2"
	Set userRs = Dream3CLS.Exec(sql)
	totalOwners = userRs(0)
	
	'sql = "Select count(*) From T_Product where state='normal'"
	'Set totalProductRs = Dream3CLS.Exec(sql)
	'totalProducts = totalProductRs(0)
	
	'orange��������
	sql = "Select * From T_Product where state='normal'"
	Set totalProductRs = Dream3CLS.Exec(sql)
	totalProducts=0
	Do While Not totalProductRs.EOF
		temp=totalProductRs("roomsnum")
		totalProducts=totalProducts+temp
		totalProductRs.Movenext
	Loop
	
%>



<%
G_Title_Content = Dream3CLS.SiteConfig("SiteName") &""
G_Keywords_Content = "���ù�,���ݴ�ѧ��ס��,���ݴ�ѧ�ǾƵ�,���ݴ�ѧ���ù�,���ݴ�ѧ�����϶���,���ݴ�ѧ�Ǹ���ס��,��ѧ��ס��,��ѧ�ǾƵ� ,���ݴ�ѧ�Ǹ����Ƶ�,���ݴ�ѧ�Ǹ����ù�,��ѧ���ù�,��ѧ���õ�"
G_Description_Content = "���ù���רע�ڹ��ݴ�ѧ�ǾƵꡢס�ޡ��ⷿ����վ��Ϊ��Ҫ�ڹ��ݴ�ѧ����ס�޺��ⷿ�����ṩ�����ˡ�����š����б��ϵĶ����������߶���ƽ̨���������������ҵ����ݴ�ѧ��ʮ���У��������������֤���ùݻ�Ƶꡣ"
%>

<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<meta name="baidu-tc-verification" content="e99f6bf15cc32fe95af53e662555fa27" />

<script language="javascript" src="<%=VirtualPath%>/common/js/inad_duice.js"></script>
<!--<script language="javascript" src="<%=VirtualPath%>/common/js/time.js"></script>-->
<script language="javascript" src="<%=VirtualPath%>/common/js/mayi.js"></script>
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



<style type="text/css">
<!--
.STYLE1 {
	font-size: 14px;
	font-family: "΢���ź�";
}
-->
</style>
<div class="mayi_wrapper">
	<form method="post" name="searchForm" action="list.asp">
    <div class="search-room">
        <div class="callout">
            <h1 data-text="רע���ݴ�ѧ��ס��">רע���ݴ�ѧ��ס��</h1>
          <p>���ݴ�ѧ�Ǽ��ܱ�<b><%=totalOwners%></b>���õ꣬<b><%=totalProducts%></b>����෿�ݵȴ���</p>
        </div>
        <div class="search">
        <!--<input type="text" id="cityname" name="cityname" class="location" value="����ס�ĸ��ط�" autocomplete="off">
        <input type="submit" id="search_btn" class="search_btn" value="">-->
        <input type="text" value="����Ƶ�����" autocomplete="off"  name="searchname" id="searchname" class="location" onFocus="if(this.value == '����Ƶ�����') this.value = ''" onblur="if(this.value == '') this.value = '����Ƶ�����'"> 
        <input type="submit" id="search_btn" class="search_btn" value="">
		<!--<input type="hidden" name="city" id="city" value="<%=citycode%>">-->
        </div>
       
       <div class="search-date">
            <p>��ס����</p>
           <input type="text" id="fromDate" readOnly="" name="fromDate" onclick="WdatePicker({minDate:'%y-%M-%d',onpicked:function(){former_select('fromDate','toDate')}})" value="<%=Dream3CLS.TimeFormateToTwoBits(datenow) %>"/>
		   <!----  class="hasDatepicker" onclick="return showCalendar('fromDate', 'y-m-dd');"  />----->
      </div>
        <div class="search-date">
            <p>�˷�����</p>
            <input type="text"  id="toDate" readOnly="" name="toDate" onclick="WdatePicker({minDate:'#F{$dp.$D(\'fromDate\',{d:+1})}'})" value="<%=Dream3CLS.TimeFormateToTwoBits(datenow+1)%>"/>
			<!--- class="hasDatepicker" onclick="return showCalendar('toDate', 'y-m-dd');"  />--->
        </div>
		<!--<div class="search-name">  <input name="searchname" type="text" value="�õ�����" onFocus="if(this.value == '�õ�����') this.value = ''"/>  </div>-->


        <div class="search-name-vallege STYLE1"><h3>����Ѱ�ң�</h3><h4>
          <p><a href="javascript:quick_search('list.asp?city=120101')">����</a> |<a href="javascript:quick_search('list.asp?city=140101')"> ��ͤ </a><br> <a href="javascript:quick_search('list.asp?city=130101')">��ͤ </a>| <a href="javascript:quick_search('list.asp?city=150101')"> ��ʯ</a>        </p></h4>
        </div>
        <div class="search-name STYLE1">
          <h3>ѧУѰ�ң�</h3>
          <h4><p><a href="javascript:quick_search('list.asp?city=120101')">�д�</a> | <a href="javascript:quick_search('list.asp?city=120101')">����</a> |<a href="javascript:quick_search('list.asp?city=140101')"> ��� </a>| <a href="javascript:quick_search('list.asp?city=140101')">�Ǻ�</a> |<a href="javascript:quick_search('list.asp?city=140101')"> ��ʦ </a>| <br><a href="javascript:quick_search('list.asp?city=130101')">�㹤 </a>|<a href="javascript:quick_search('list.asp?city=130101')"> ���� </a>| <a href="javascript:quick_search('list.asp?city=150101')">��ҩ</a> | <a href="javascript:quick_search('list.asp?city=150101')"> ����</a> |<a href="javascript:quick_search('list.asp?city=150101')"> ����ҽ</a>|</p></h4>
        </div>



    <!--tips������ -->
    <div class="search-name-tips-bg" style="background-image:url(../../../images/tips.png)" >
        <div   style="margin-left: 20px;margin-top: 10px;margin-bottom: 15px" >
		  <marquee   width="400"   height="90"   direction="up"   class="9pointblack1"   onmouseover="this.stop()"   onmouseout="this.start()"  
		     scrollamount="1"   scrolldelay="1" >  
			 <h2>��������</h2>
			
                       <%
						msql = "Select * From T_notice order by m_id desc"
							Set rs = Dream3CLS.Exec(msql)
						do while not rs.eof
						    m_id=rs("m_id")
							m_title=left(rs("m_title"),15)
							m_content=rs("m_content")
							m_time=left(rs("m_date"),10)
						%>
						<div style="width:270px;float:left"><a href="notice.asp?id=<%=m_id%>" target="_blank"><%=m_title%></a></div>
						<div style="width:80px;float:right"><%=m_time%></div>
						<br>
						<%
						rs.movenext
						loop
						%>
  
          	</marquee>   
          </div>
	</div>


    </div>
	</form>
   	
<div id="pic_container" class="room-pic" style="height:440px;">
    
		<%
		If IsArray(arrU) Then
			For i = 0 to UBound(arrU, 2)
				s_id = arrU(0,i)
				s_address = arrU(8,i)
				s_image = arrU(6,i)
				s_house_title = arrU(5,i)
				dayrentprice  = arrU(9,i)
				s_user_id = arrU(12,i)
				s_citycode=arrU(14,i)
				s_userface = userMap.getv(CStr(s_user_id))(3)
				If ( IsNull(s_userface) or s_userface = "") Then
					s_userface = VirtualPath & "/images/user_normal.jpg"
				End If
				s_username = userMap.getv(CStr(s_user_id))(0)
				
			Sql = "select * from T_Product where id = "&s_id
			Set Rs = Dream3CLS.Exec(Sql)
				h_id = Rs("hid")
			Rs.close
			set Rs = nothing
			
			Sql = "select * from T_hotel where h_id = "&h_id
			Set Rs = Dream3CLS.Exec(Sql)
				h_img = Rs("h_img")
			Rs.close
			set Rs = nothing
		%>
		<div style="" class="picture">
			<div class="picture_box">
				<a href="show.asp?hid=<%=h_id%>">
				<img width="477" height="358" title="<%=s_house_title%>" id="idxRoomPic<%=s_id%>" src="<%=s_image%>" class="picture_img" alt="<%=s_house_title%>">
				</a>
			</div>
			<div class="room-price">
				<dl class="room-con">
					<img width="57px" height="57px" id="idxUserPic<%=s_id%>" src="<%=h_img%>" alt="<%=s_username %>">
					<dt><a href="detail.asp?pid=<%=s_id%>" title="<%=s_house_title%>"><%=s_house_title%></a></dt>
					
					
					<dd>&nbsp;<%=s_username%> </dd>
					<dd></dd>
				</dl>
				<dl class="price2">
					<dt><span>��&nbsp;</span><span class="ft01"><%=dayrentprice%></span><span class="ft02">/��</span></dt>
				</dl>
			</div>
		</div>
		
		<%
			Next
		End If
		%>
    
        <div style="DISPLAY: none" class="picture_page">
            <div onMouseOut="$(this).removeClass('prev_selected');$(this).addClass('prev');" onMouseOver="$(this).removeClass('prev');$(this).addClass('prev_selected');" class="prev"></div>
            <div class="middle_stop"></div>
            <div onMouseOut="$(this).removeClass('next_selected');$(this).addClass('next');" onMouseOver="$(this).removeClass('next');$(this).addClass('next_selected');" class="next"></div>
        </div>
    
    </div>
	
	<div>
		<div style=" position : absolute;margin-top:490px; margin-left:50px;">
			<a href="#"><img src="../images/bannerBtn.png" onclick="countAppDownload();"></a>
		</div>
		<div style=" position : absolute;margin-top:490px; margin-left:250px;">
			<img src="../images/bannerBtn2.png" >
		</div>
		<img src="../images/mobilebanner.png" >
	</div>
	
	
	
		
    <!--��ҳ�������� -->
	<DIV class=zinan-area>

		<UL>
	<%
				Sql = "Select top 4 * from T_AD Where 1=1  and enabled ='Y' order by seqno desc,id desc"
				
				Set adRs = Dream3CLS.Exec(Sql)
				If Not adRs.EOF Then
					adRs.MoveFirst
				End If
				Do While Not adRs.EOF 
					ad_image = adRs("image")
					ad_url = adRs("url")
					ad_title = adRs("title")
				%>
				<LI><A href="<%=ad_url%>" target=_blank><IMG title="<%=ad_title%>" src="<%=ad_image%>" width=236 height=160></A></LI>
				<%
					adRs.Movenext
					Loop
				%>
				</UL></DIV>
	<!-- ��ҳ�������ݽ���-->
    
    
    <!--#include file="common/inc/footer_friendlink.asp"--> 
    
</div> 

<script type="text/javascript" src="<%=VirtualPath%>/common/js/city_jquery.js"></script>
<script type="text/javascript" src="<%=VirtualPath%>/common/js/jquery.autocomplete.min.js"></script>

<!--��֪��������,ע��һ��ʱ��,��bug��ɾ��


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
	if ($("#cityname").val() == '��������Ҫ��ס�ĵط�'){
		$("#cityname").val('');
	}
});

$("#cityname").blur(function (){
	if (!$("#cityname").val()){
		$("#cityname").val('��������Ҫ��ס�ĵط�');
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
	alert('��ѡ��ط�');
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
-->
<script type="text/javascript">
function quick_search(e)
{
	var f=document.getElementById('fromDate');
	var n=document.getElementById('toDate');
	window.location.href=e+'&fromDate='+f.value+'&toDate='+n.value;
}
</script>


	
<!--#include file="common/inc/footer_user.asp"-->