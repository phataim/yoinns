<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount

Dim hid,h_hotelname,h_headname,h_citycode,h_address,h_img,h_discription,h_star,h_line,t_name,h_mapx,h_mapy,imgsum,show_id,typeid

Dim RoomDesc '��������
Dim lodgeType '��������
Dim leaseType '��������
Dim area '���
Dim guestnum '��ס����
Dim roomsnum '������ 
Dim bednum '��λ��
Dim bedtype '���� 
Dim toiletnum  '��������
Dim checkouttime '�˷�ʱ��
Dim checkintime '��סʱ��
Dim minday  '��������
Dim maxday '�������
Dim invoice ' ��Ʊ
Dim facilities '��ʩ
Dim address ' ��ַ
Dim housetitle ' ���ݱ���
Dim userule 'ʹ�ù���
Dim expiredate  '��Ч��
Dim order_days '��Ԥ�������ڴ�

Dim dayrentprice,weekrentprice,monthrentprice

Dim  map_x,map_y

Dim img1,img2,img3,img4,img5,img6,img7,img8,img9,img10
Dim userid,detail_id
Dim userIdArr(0) ,userMap
Dim userface,mobile

Dim leftDays 'չʾʣ�������ķ�Դ
Dim vallege,vallegeCode '�õ������Ĵ���

Dim fromdate,todate,fromdate_str,todate_str

Set userMap = new AspMap

Action = Request.QueryString("act")
Select Case Action
	Case "saveMsg"
		Call SaveMsg()
	Case Else
		Call Main()
End Select

Sub Main()		
	
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
	
	'�õ����е�ID������Ҳ�������Ĭ��Ϊȫ��
		show_id = Dream3CLS.ChkNumeric(Request.QueryString("hid"))
		
		Sql = "Select * from T_hotel Where h_id="&show_id
		
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Dream3CLS.showMsg "��Ҫ��ѯ����Ϣ�����ڣ�","S","error.asp"
			Response.End()
		End If
		
		Set cityMap = new AspMap
		Call Dream3Product.getCategoryMap("city",cityMap)
		
		hid= Rs("h_id")
		h_hotelname = Rs("h_hotelname")
		h_address = Rs("h_address")
		h_star= Rs("h_star")
		h_img= Rs("h_img")
		facilities = Rs("h_facility")
		facilities = ","&facilities&","
		h_discription= Rs("h_discription")
		h_line= Rs("h_line")
		vallegeCode= Rs("h_citycode")
		
		'userule = Rs("userule")
		'RoomDesc = Rs("RoomDesc")
		'lodgeType = Rs("lodgeType")
		'leaseType = Rs("leaseType")
		
		'guestnum = Rs("guestnum")
		
		'If roomsnum = 11 then roomsnum = "����10"
		'bednum = Rs("bednum")
		'If bednum = 11 then bednum = "����10"
		
		
		
		'toiletnum = Rs("toiletnum")
		'If toiletnum = 11 then toiletnum = "����10"
		'checkouttime= Rs("checkouttime")
		'checkintime  = Rs("checkintime")
		'minday = Rs("minday")
		'maxday  = Rs("maxday")
		'if maxday = 0 then maxday = "������"
		'invoice = Rs("invoice")
		'address = Rs("address")
		
		
		
		'img1 = Rs("image")  
		'img2 = Rs("image1")  
		'img3 = Rs("image2")  
		'img4 = Rs("image3")  
		'img5 = Rs("image4")  
		'img6 = Rs("image5")  
		'img7 = Rs("image6")  
		'img8 = Rs("image7")  
		'img9 = Rs("image8")  
		'img10 = Rs("image9") 
		
		h_mapx = Rs("h_mapx") 
		h_mapy = Rs("h_mapy") 
		
		'===============================mike
		map_x=h_mapx 
		map_y=h_mapy 
		If IsNull(map_x) Or map_x = "" Then '���Ϊ�վ���Ĭ��λ��
			map_x = "113.400961" '�ٶ����� x 
			map_y = "23.057637" '�ٶ����� y 
			is_empty_map=1 'û������
		End If 
		'===============================mike

		'weekrentprice = Rs("weekrentprice") 
		'monthrentprice = Rs("monthrentprice") 
		'expiredate = Rs("expiredate")
		'order_days = Rs("order_days")
		
		'order_days = "," & order_days & ","
		
		userid = Rs("h_uid")
		
		Sql = "Select * from T_User Where id="&userid
		
		Set Rs = Dream3CLS.Exec(Sql)
		If not Rs.EOF Then
			mobile=Rs("mobile")
		end if
		
		
		userIdArr(0) = userid
		
		
		Call Dream3Product.getUserMap(userIdArr,userMap)
		
		userface = userMap.getv(CStr(userid))(3)
		If ( IsNull(userface) or userface = "") Then
			userface = VirtualPath & "/images/user_normal.jpg"
		End If
		'��ȡʣ��1�����ڵķ�Դ
		'leftDays = DateDiff("d",Now(),expiredate)
		
		'If leftDays > 30 Then leftDays = 30
		
		'�ز��õ���������
		 Sql = "Select * from T_City Where citypostcode="&vallegeCode
		
		Set Rs = Dream3CLS.Exec(Sql)
		If not Rs.EOF Then
			vallege=Rs("cityname")
		end if
		
End Sub
	
	
%>
<%

G_Title_Content  = h_hotelname &"-" &vallege&"ס��-���ݴ�ѧ��ס��|���ù�"
G_Keywords_Content = vallege & "ס��,"&vallege&"�ù�,"&vallege&"�Ƶ�,��ѧ��ס��|���ù�"
G_Description_Content1 = "�Ƶ����: "&h_discription&";��ͨ·��:"&h_line&";��ϵ��ʽ:"&mobile
G_Description_Content = left(G_Description_Content1,150)
%>

<!--#include file="common/inc/header_user.asp"-->



<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />



<SCRIPT type=text/javascript src="<%=VirtualPath%>/common/js/slide.js"></SCRIPT>
<script language="javascript" src="<%=VirtualPath%>/common/js/time.js"></script>
<script type="text/javascript" src="<%=VirtualPath%>/common/js/common.js"></script>
<SCRIPT language=javascript type=text/javascript src="<%=VirtualPath%>/common/js/leftmenu.js"></SCRIPT>


	
	<style>
      .gmap3{
        margin: 20px auto;
        border: 1px dashed #C0C0C0;
        width: 600px;
        height: 400px;
      }
    </style>
   
  

<div class="content_wrapper">
	
    <div class="room-tit">
        <p>
            <a href="<%=VirtualPath%>/index.asp"><%=Dream3CLS.SiteConfig("SiteShortName")%></a> &gt <a href="list.asp?cityname=<%=vallege%>"><%=vallege%></a> &gt <%=h_hotelname%>
            <a href="#"></a> 
        </p>
        <div class="title-room">
        <h1><%=h_hotelname%></h1>
        	<span><a onclick="this.blur();" class="sd-log sd-position2" target="_blank" title="�÷���<%=Dream3CLS.SiteConfig("SiteShortName")%>Ա����ʵ�ؿ���,�����Է�����ס" href="help/index.asp?c=roomspec"></a></span>
			<span>�Ǽ���<%=h_star%></span>
        </div>
        <div class="add">��ַ�� <%=h_address%>  
		 
<!-- sharebar button begin --
<a class="sharebar_button" href="http://www.sharebar.cn/"><img src="http://s.sharebar.cn/img/lg-share-cn.gif" width="125" height="21" alt="������" style="border:0"/></a>
<script type="text/javascript" src="http://s.sharebar.cn/js/sharebar_button.js" charset="utf-8"></script>
<!-- sharebar button end -->
<!-- Baidu Button BEGIN -->
    <div id="bdshare" class="bdshare_t bds_tools get-codes-bdshare">
        <span class="bds_more">������</span>
        <a class="bds_qzone"></a>
        <a class="bds_tsina"></a>
        <a class="bds_tqq"></a>
        <a class="bds_renren"></a>
		<a class="shareCount"></a>
    </div>
<script type="text/javascript" id="bdshare_js" data="type=tools&amp;uid=110587" ></script>
<script type="text/javascript" id="bdshell_js"></script>
<script type="text/javascript">
	document.getElementById("bdshell_js").src = "http://bdimg.share.baidu.com/static/js/shell_v2.js?cdnversion=" + new Date().getHours();
</script>
<!-- Baidu Button END -->

 		</div>
    </div>
    <div class="left-detail">
   	
        <div id="show_con">
            <ul id="show_tags">
                <li class="show_selectTag"><A onClick="show_selectTag('tagContent0',this)" href="javascript:">�Ƶ�ͼƬ</A> </li>
                <li><A onClick="show_selectTag('tagContent1',this);initialize()" href="javascript:void(0)">��ͼ</A> </li> <!-- mike ��,����ط�����������-->
				<!--<li><A onClick="show_selectTag('tagContent2',this)" href="javascript:void(0)">����</A> </li> -->
            </ul>
            <div id="show_tagContent">
                <div class="show_tagContent show_selectTag" id="tagContent0">
                	
                    <div style="height: 520px; padding-top:5px" class="wrap picshow"><!--��ͼ�ֻ���-->
                        <div id="picarea">
                        <div style="margin: 0px auto; width: 666px; height: 436px; overflow: hidden">
                        <div style="margin: 0px auto; width: 666px; height: 436px; overflow: hidden" id="bigpicarea">
                        <P class=bigbtnPrev><SPAN id=big_play_prev></SPAN></P>
						
						<%
						imgsum=Dream3Product.GetHotelimg(hid,h_img)
						if IsArray(imgsum) then
						For i = LBound(imgsum) To UBound(imgsum)
    					%>
						<div id="image_xixi-<%=i%>" class="image">
                            <img src="<%=imgsum(i)%>" alt="<%=h_hotelname%>�Ƶ�ͼƬ<%=i %>" height="430">
                            <div class="word">
                                
                            </div>
                        </div>
						<%
						Next
						end if
						%>
						
                        <P class="bigbtnNext"><SPAN id="big_play_next"></SPAN></P>
                        </div>
                        </div>
                        <div id="smallpicarea" style="overflow-x: scroll;height: 70px">
                            <div id="thumbs" style="WIDTH: 1800px">
                                <ul>
                                    <li class="first btnPrev"><img id=play_prev src="<%=VirtualPath%>/common/themes/<%=Dream3CLS.SiteConfig("DefaultSiteStyle")%>/img/left.png"></li>
									<%
									imgsum=Dream3Product.GetHotelimg(hid,h_img)
									if IsArray(imgsum) then
										For i = LBound(imgsum) To UBound(imgsum)
    								%>
									<li class="slideshowItem">
                                        <A id="thumb_xixi-<%=i%>" href="#"><img src="<%=imgsum(i)%>"height="40" alt="<%=h_hotelname%>�Ƶ�ͼƬ��<%=i %>"></A>
                                    </li>
									<%
										Next
									end if
									%>
                                   
                                    <li class="last btnNext"><img id=play_next src="<%=VirtualPath%>/common/themes/<%=Dream3CLS.SiteConfig("DefaultSiteStyle")%>/img/right.png"></li>
                                </ul>
                            </div>
                        </div>
                        </div>
						<%
						if IsArray(imgsum) then
							For i = LBound(imgsum) To UBound(imgsum)
    							tar=tar&"'xixi-"&i&"',"
							Next
						if right(tar,1)="," then 
							tar=left(tar,len(tar)-1) 
						end if 
						end if
						%>
                         <SCRIPT>
                        var target = [<%=tar%>];
                        </SCRIPT>
                       
                        </div>
                    
                </div>
                <div class="show_tagContent" id="tagContent1">
             	
                                    	
                <div class="show_map">
                                    <!--��ͼ-->
                        <div id="map" class="gmap3">   <!-- mike -->
                 
                        </div>
                    </div>
                    
                </div>
                <!--<div id="map" style="width:580px;height:420px"></div><div class="show_tagContent" id="tagContent2">
                
                	<div class="show_day">
                    	<div class="show_day">
								<div class="calendar">
									<h2>��һ���·�Դ</h2>
									<ul>
										<%
										For i = 0 To leftDays
											isBook = false
											cDays = Dream3CLS.Formatdate(DateAdd("d", i, Now()) , 11)
											fDays = Dream3CLS.Formatdate(DateAdd("d", i, Now()) , 2)
											If instr(order_days , ","&fDays&",") > 0  Then
												isBook = true
											End If
										%>
										<li>
										<div class="fc_day_number"><%=cDays%></div>
										<div class="fc_event_inner">
											<span class="addCalendarRoom">
											<%If isBook Then%>
												<span class="addCalendarRoom yd">��Ԥ��</span>
												<span class="addCalendarPrice"></span>
											<%Else%>
												<span class="addCalendarRoom kz">����</span>
												<span class="addCalendarPrice"><a href="buy.asp?checkintype=perDay&startdate=<%=fDays%>&enddate=<%=fDays%>&pid=<%=detail_id%>&checkinRoomNum=1">��ҪԤ��</a></span>
											<%End If%>
											</span>
											<span class="addCalendarPrice"></span>
										</div>
										</li>
										<%
										Next
										%>
									</ul>
								</div>
							</div>
                    </div>
                
                </div> -->
            </div>
        </div>
        <p>
          <SCRIPT type=text/javascript>
        function show_selectTag(showContent,selfObj){
            // ������ǩ
            var tag = document.getElementById("show_tags").getElementsByTagName("li");
            var taglength = tag.length;
            for(i=0; i<taglength; i++){
                tag[i].className = "";
            }
            selfObj.parentNode.className = "show_selectTag";
            // ��������
            for(i=0; j=document.getElementById("tagContent"+i); i++){
                j.style.display = "none";
            }
            document.getElementById(showContent).style.display = "block";
            
            
        }
        </SCRIPT>
        </p>
        
        <div id="show1_con">
            <ul id="show1_tags">
                <li class="show1_selectTag"><A onClick="show1_selectTag('tag_Content0',this)" href="javascript:void(0)">����չʾ</A> </li>
                <li><A onClick="show1_selectTag('tag_Content1',this)" href="javascript:void(0)">������ʩ</A> </li>
                <li><A onClick="show1_selectTag('tag_Content2',this)" href="javascript:void(0)">���׹���</A> </li>
                <li><A onClick="show1_selectTag('tag_Content3',this)" href="javascript:void(0)">�Ƶ���ܼ���ͨ</A> </li>
            </ul>
            <div id="show1_tagContent">
                <div class="show1_tagContent show1_selectTag" id="tag_Content0">
                	<div class="tab-con2">
                    <DIV class=hInfo>
						<div class="htitle">
							<li>����</li>
							<li>����</li>
							<li>���</li>
							<li>������</li>
							<li>ƽ�ռ�</li>
							<li>��ĩ��</li>
							
						</div>
						<%
						Sql = "Select * from T_Product  Where state='normal'  and enabled='Y'  and online='Y' and  hid="&hid
						Set Rs = Dream3CLS.Exec(Sql)
						i=0
						do while not Rs.eof 
							i=i+1
							detail_id = Rs("id")
							housetitle = Rs("housetitle")
							area = Rs("area")
							roomsnum = Rs("roomsnum")
							bedtype = Rs("bedtype")
							bedtype = Dream3Static.GetBedType(bedtype)
							dayrentprice = Rs("dayrentprice") 
							guestnum = Rs("guestnum")
							weekrentprice = Rs("weekrentprice") 
							monthrentprice = Rs("monthrentprice")
							RoomDesc = Rs("RoomDesc")
							image = Rs("image")
							image1 = Rs("image1")
							image2 = Rs("image2")
							image3 = Rs("image3")
							image4 = Rs("image4")
							image5 = Rs("image5")
							image6 = Rs("image6")
							image7 = Rs("image7")
							image8 = Rs("image8")
							image9 = Rs("image9")
							
							
							
						%>
						
					
						<div class="htext">
							<li><a onclick='showHide("items<%=i%>_1")' href="javascript:void(0)"><%=houseTitle%></a> <b onclick='showHide("items<%=i%>_1")'><a href="javascript:void(0)" >&nbsp;&nbsp;&nbsp;&nbsp;</a></b></li>
							<li><%=bedtype%></li>
							<li><%=area%></li>
							<li><%=roomsnum%></li>
							<li><%=dayrentprice%></li>
							<li><%=weekrentprice%></li>
							<li><a href="detail.asp?pid=<%=detail_id%>&fromdate=<%=Dream3CLS.TimeFormateToTwoBits(fromdate)%>&todate=<%=Dream3CLS.TimeFormateToTwoBits(todate)%>"><strong>�鿴</strong></a></li>
							<li><a onclick="myFormShow('myForm');" href="detail.asp?pid=<%=detail_id%>&fromdate=<%=Dream3CLS.TimeFormateToTwoBits(fromdate)%>&todate=<%=Dream3CLS.TimeFormateToTwoBits(todate)%>"><img src="/common/themes/Default/img/order.jpg" alt=""></a></li>
						</div>
						<ul style="DISPLAY: none" id=items<%=i%>_1>
							<div class="hbox">
���ͣ�<%=bedtype%>&nbsp;&nbsp;���������<%=area%>ƽ����&nbsp;&nbsp;��������<%=roomsnum%>&nbsp;&nbsp;��ס������<%=guestnum%> &nbsp;&nbsp;ƽʱ�վ��ۣ�<%=dayrentprice%>&nbsp;&nbsp;��ĩ�վ��ۣ�<%=weekrentprice%>&nbsp;&nbsp;�¾��ۣ�<%=monthrentprice%><br />
����������<%=RoomDesc%>

							</div>
						</ul>
						<%
						Rs.movenext
						loop
						%>
					
</DIV>
                </DIV>    
                </div>
                <div class="show1_tagContent" id="tag_Content1">
                	
                    <div class="tab-con2">
                        <div class="yym-detail">
                           <%
							Set f_Rs = Server.CreateObject("adodb.recordset")	
							Sql = "select id,cname from T_Hfacility Where enabled='Y' order by seqno desc"		
							f_Rs.open Sql,conn,1,1
							
							Do While Not f_rs.EOF
								If instr(facilities,","&f_Rs("id")&",") Then
									facilitySelect = true
								Else
									facilitySelect = false
								End If
							%>
							<span <%If Not facilitySelect Then%>class="no"<%End If%>><%=f_rs("cname")%></span>
							<%
								f_rs.Movenext
							Loop
							%>
                        </div>
                    </div>
                    
                </div>
                <div class="show1_tagContent" id="tag_Content2">
                
                    <div class="tab-con2">
                        <div class="Trading_rules">
                        	<p><b>���ù���(www.yoinns.com)���׹���</b>��<br></p>
                            <ul>
                            <li>�����ȷ����Ԥ����������������<b style="color:#ff0000;">ȫ��֧��</b>���</li>
                            <li>������ס��䣬�����ʽ��ɡ����ùݡ���վ(www.yoinns.com)���ܣ����԰�ȫ��</li>
                            <li>����һ���´���佫������,�������޷�,����ȫ���˻���</li> 
                            <li>����ķ�����ú�Ѻ�𲻰������ܷ����ڣ��ɷ���������ȡ��</li>
                            <li>Ϊ��֤������ʱ�з��ͽ��װ�ȫ�������ͨ�����ù�������֧������ܾ��õ�����֧����Ҫ��</li>
                            </ul>
                        </div>
                        <div class="Trading_rules">
                            <p>
                            
                            
                            <br>
                            </p>
                            <ul>
                                <li>
                                
                                </li>
                            </ul>
                        </div>
                    </div>
                    
                </div>
                <div class="show1_tagContent" id="tag_Content3">
                
                	<div class="tab-con2">
                    	<div class="House_rules">
                            <strong>���ܣ�</strong><%=h_discription%><br />
							<br><strong>��ͨ·�ߣ�</strong><%=h_line%><br />
							<%if not isempty(Session("_UserName")) then %>
                              <br><strong>��ϵ��ʽ��</strong><%=mobile%>
                            <%else%>
                            <br><strong>��ϵ��ʽ��</strong>  <a href="javascript:void(0)" onclick="load_login('');go_top()">��¼</a>��ɼ�
							<!--  <br><strong>��ϵ��ʽ��</strong>  <A href="user/account/login.asp">��¼</A>��ɼ� -->
                            <%end if %>
							
                        </div>
                    </div>
                
                </div>
            </div>
        </div>
        <p>
          <SCRIPT type=text/javascript>
        function show1_selectTag(showContent,selfObj){
            // ������ǩ
            var tag = document.getElementById("show1_tags").getElementsByTagName("li");
            var taglength = tag.length;
            for(i=0; i<taglength; i++){
                tag[i].className = "";
            }
            selfObj.parentNode.className = "show1_selectTag";
            // ��������
            for(i=0; j=document.getElementById("tag_Content"+i); i++){
                j.style.display = "none";
            }
            document.getElementById(showContent).style.display = "block";
            
            
        }
        </SCRIPT>
        </p>
        
        <div class="info_pl" style="display:block ">
            <a class="nav-unit nav-selected" href="#">����������</a>
        </div>
        
        
        
        
        
       <!-- <div class="pinglun" style="display:block;">
        	��������(����5��һҳ)
        </div>
        
        <div class="pinglun" style="display:block ">
        
            <div class="pinglun_box">
            
                <div class="pl_img">
                    <img width="60" height="60" title=" " src="/images/user_normal.jpg">
                    <p>�û�����</p>
                </div>
                <div class="pl_text">
                    <div class="pl_text_center">
                        <span class="pl_sanjiao"></span>
                        <div class="moreinfo">
                        	<p><br /><br /></p>
                        </div>
                        <p class="detail_comment"></p>
                    </div>
                </div>
                
                <dl class="fav-dl">
                    <dd>����������������</dd>
                    <dd>��ȫ�̶ȣ�������</dd>
                    <dd>���������������</dd>
                    <dd>��ͨλ�ã�������</dd>
                    <dd>�Լ۱ȣ�������</dd>
                </dl>
                
            </div>
            
                       
        	
            <div class="page_t right">
                <span>��һҳ</span>
                <strong>1</strong>
                <a href="#">2</a>
                <a href="#">3</a>
                <a href="#">4</a>
                <a href="#">5</a>
                <a href="#">6</a>
                <a href="#">7</a>
                <a href="#">8</a>
                <a href="#">9</a> 
                <a href="#" class="pagedown">��һҳ</a>
            </div>
            
        </div>
        
    </div>-->
	
	    
     <%
dim pageiswho
dim bigpage
Dim pageintPageNow
dim pagesql
dim pagestrLocalUrl

pagestrLocalUrl = request.ServerVariables("SCRIPT_NAME")&"?hid="&hid
pagesql="select id,username,userface,hotelname,houseTitle,contents,state,createtime,owner,callback,callbacktime from T_Comments where  hid='"&hid&"'"


set rs=Dream3CLS.Exec("select  manager,state from T_User where id='"&Session("_UserID")&"'")

if Session("_UserID")="" then

elseif rs(0)="Y" then
 bigpage="manager"
 pageintPageSize=10
elseif rs(1)=2 then

 pageintPageSize=3
 bigpage="fangdong"
 pageiswho=Session("_UserName")
 
 
else
 pageiswho=Session("_UserName")
 pageintPageSize=3
 bigpage="user"
 
end if
 	
if Session("_UserID")="" then
bigpage="youke"
pageintPageSize=3
end if
rs.close()

if  bigpage="manager" then
pagesql=pagesql
else if  bigpage="fangdong" or bigpage="user"  then
pagesql=pagesql&"and  username='"&Session("_UserName")&"' or state ='Y' and hid='"&hid&"'"
else
pagesql=pagesql&" and state='Y'"
end if 
end if 
%>

<!--#include file="commentsdisplay.asp"-->        
</div>
  <div class="right-detail">
		<form method="post" action="buy.asp" name="myForm" id="myForm" onSubmit="return order_check('myForm')">
        <div class="yd-room">
            <div class="yd-price">
			<%
			'����SpecialPrice����۸�
			Dim sumPrice
			sumPrice = 0
			if detail_id<>"" then
				Sql  = "select * from T_SpecialPrice where product_id = "&detail_id&" and  date> ='"&Dream3CLS.TimeFormateToTwoBits(fromdate)&"' and date< '"&Dream3CLS.TimeFormateToTwoBits(todate)&"'" 
				
				Set Rs = Dream3CLS.Exec(Sql)
				Do While Not Rs.EOF
					sumPrice = sumPrice + Cint(Rs("price"))
					Rs.Movenext
				Loop
				Rs.close
			else
				sumPrice=dayrentprice
			end if

			  
			
			'if typeid<>"" then
			'Sql = "Select * from T_Product Where id="&typeid
			'Response.Write Sql
			'Set Rs = Dream3CLS.Exec(Sql)
			'dayrentprice = Rs("dayrentprice") 
			'weekrentprice = Rs("weekrentprice") 
			'monthrentprice = Rs("monthrentprice")
			
			'response.end
			'end if
			%>
			<span style="" class="font1" id="price"><b>��</b><%=sumPrice%></span>
			<%
		'============================mike
		Set mRs = Server.CreateObject("adodb.recordset")			
		Sql = "select * from T_Product Where hid='"&hid&"' and enabled='Y'  and online='Y' and  state='normal' order by id desc"
		mRs.open Sql,conn,1,2
		num=0
		stt=""
		dtt=""
		sx_id=""
		Do While Not mRs.EOF 
			
				stt="<option  value='"&mRs("id")&"'>"&mRs("houseTitle")&"</option>" '��������

			'if num=0 then ' ����JS����
				'sz_id=mRs("id")
			'else
				'sz_id=sz_id&","&mRs("id")
			'end if
			dtt=dtt&stt
			'num=num+1
			mRs.Movenext
		Loop
		mRs.close
		'sz_id=sz_id&",0" '����Ӷ����
		'============================mike
			%>
                <i class="renttype_tip">
				
				<!--�Ѿ��м۸����� ����ĩ�۲�����ʾ xiaoyaohang-->
                <select  name="detail_id" onchange="get_new_price('startdate','enddate','detail_id');" id="detail_id" class="jianye" >
					<%=dtt%> 
				</select>
                	<!-- add by xiaoyaohang -->
                <script type="text/javascript">
                function getQueryString(name)
                {
                    // �������û�в��������������в���������Ҫ��ȡ�Ĳ�����ֱ�ӷ��ؿ�
                    if(location.href.indexOf("?")==-1 || location.href.indexOf(name+'=')==-1)
                    {
                        return '';
                    }
                 
                    // ��ȡ�����в�������
                    var queryString = location.href.substring(location.href.indexOf("?")+1);
                 
                    // ��������� ?key=value&key2=value2
                    var parameters = queryString.split("&");
                 
                    var pos, paraName, paraValue;
                    for(var i=0; i<parameters.length; i++)
                    {
                        // ��ȡ�Ⱥ�λ��
                        pos = parameters[i].indexOf('=');
                        if(pos == -1) { continue; }
                 
                        // ��ȡname �� value
                        paraName = parameters[i].substring(0, pos);
                        paraValue = parameters[i].substring(pos + 1);
                 
                        // �����ѯ��name���ڵ�ǰname���ͷ��ص�ǰֵ��ͬʱ���������е�+�Ż�ԭ�ɿո�
                        if(paraName == name)
                        {
                            return unescape(paraValue.replace(/\+/g, " "));
                        }
                    }
                    return '';
                };
                 
                </script>
				<script  type="text/javascript" >
				var typeid = getQueryString('roomType');
				if(typeid){
				document.getElementById('detail_id').value = typeid;
				}
				
				</script>
                </i></div>
            <p class="book-tips"></p>
            <div class="yd-sel">
			<input type="text" readonly="readonly" value="<%=Dream3CLS.TimeFormateToTwoBits(fromdate)%>" id="startdate" name="startdate" onclick="WdatePicker({minDate:'%y-%M-%d',onpicked:function(){former_select('startdate','enddate');get_new_price('startdate','enddate','detail_id');}})" />

            <input type="text" readonly="readonly" value="<%=Dream3CLS.TimeFormateToTwoBits(todate)%>" id="enddate" name="enddate" onclick="WdatePicker({minDate:'#F{$dp.$D(\'startdate\',{d:+1})}',onpicked:function(){get_new_price('startdate','enddate','detail_id');}})" />

			

                <select onchange="get_new_price('startdate','enddate','detail_id')"  name="checkinRoomNum" id="checkinRoomNum" class="day_select">
				<%
				
				For i = 1 to roomsnum

				%>
				<option value="<%=i%>"><%=i%>��</option>
				<%
				Next
				%>
				</select>
            </div>
            <div id="totalPrice" class="total_price"></div>
            <div class="yd-btn"><a href="#ongo" class="day_yuding"><input type="submit" value=""></a></div>
        </div>
		<input type="hidden" name="pid" id="pid" value="<%=show_id%>"/>
		<input type="hidden" name="checkinrenttype" value=""/>
		</form>
        <div class="per-con">
        <img height="225" src="<%If IsNull(h_img) or h_img="" Then response.Write("images/user_normal.jpg") else response.Write(h_img)%>"">
        	<h2 class="font2"><%=userMap.getv(CStr(userid))(0)%></h2>
            <p class="fd">(����)</p>         
        </div>
        
        <div class="per-con2">
			<h3 class="">��㿴��</h3>
        	<ul>
				<%=Dream3Product.GetAboutHotel(show_id)%>
			</ul>	        
        </div>
        
    </div>
    
</div>
<!--
mike ��Ҫ��
<script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>
<script language="javascript" src="<%=VirtualPath%>/common/js/jquery/gmap3.min.js"></script>

-->
<script type="text/javascript" >
    //============================================== �ٶȵ�ͼstart
	function loadScript() {
	  var script = document.createElement("script");
	  script.src = "http://api.map.baidu.com/api?v=1.3&callback=initialize";
	  document.body.appendChild(script);
	}
	window.onload = loadScript; //����Զ��JS
	
	function initialize() { //������
	
	  var map = new BMap.Map('map');
	
		var point = new BMap.Point(<%=map_x%>,<%=map_y%>); //����
		
		map.centerAndZoom(point,14);                   // ��ʼ����ͼ,���ó��к͵�ͼ����
	
		map.enableScrollWheelZoom();    //���ù��ַŴ���С��Ĭ�Ͻ���
		map.enableContinuousZoom();    //���õ�ͼ������ק��Ĭ�Ͻ���
		
		map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT}));    //���Ͻǣ�Ĭ�ϵ�ͼ�ؼ�
		
		var opts = {type: BMAP_NAVIGATION_CONTROL_ZOOM, anchor: BMAP_ANCHOR_BOTTOM_RIGHT} 
		map.addControl(new BMap.NavigationControl(opts));//�������ſؼ�
	
		//���� �洢�ı�ע start
		var marker = new BMap.Marker(point);
		map.addOverlay(marker);
		var label = new BMap.Label("��������!",{offset:new BMap.Size(20,-10)});
		marker.setLabel(label);
	}
    //============================================== �ٶȵ�ͼend
	
	function go_top(){
		scroll(0,0)
		//window.scrollBy(0,-15);
		//alert(document.documentElement.scrollTop);
	
		//scrolldelay = setTimeout("go_top()",100);
		
		//	go_top();
			
	}
	
	
    </script> 



<!--#include file="common/inc/footer_user.asp"-->