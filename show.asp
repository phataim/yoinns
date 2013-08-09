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

Dim RoomDesc '房间描述
Dim lodgeType '房屋类型
Dim leaseType '出租类型
Dim area '面积
Dim guestnum '可住人数
Dim roomsnum '房间数 
Dim bednum '床位数
Dim bedtype '床型 
Dim toiletnum  '卫生间数
Dim checkouttime '退房时间
Dim checkintime '入住时间
Dim minday  '最少天数
Dim maxday '最多天数
Dim invoice ' 发票
Dim facilities '设施
Dim address ' 地址
Dim housetitle ' 房屋标题
Dim userule '使用规则
Dim expiredate  '有效期
Dim order_days '被预定的日期串

Dim dayrentprice,weekrentprice,monthrentprice

Dim  map_x,map_y

Dim img1,img2,img3,img4,img5,img6,img7,img8,img9,img10
Dim userid,detail_id
Dim userIdArr(0) ,userMap
Dim userface,mobile

Dim leftDays '展示剩余天数的房源
Dim vallege,vallegeCode '旅店所属的村落

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
	
		'初始化日期
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
	
	'得到城市的ID，如果找不到，则默认为全部
		show_id = Dream3CLS.ChkNumeric(Request.QueryString("hid"))
		
		Sql = "Select * from T_hotel Where h_id="&show_id
		
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Dream3CLS.showMsg "您要查询的信息不存在！","S","error.asp"
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
		
		'If roomsnum = 11 then roomsnum = "大于10"
		'bednum = Rs("bednum")
		'If bednum = 11 then bednum = "大于10"
		
		
		
		'toiletnum = Rs("toiletnum")
		'If toiletnum = 11 then toiletnum = "大于10"
		'checkouttime= Rs("checkouttime")
		'checkintime  = Rs("checkintime")
		'minday = Rs("minday")
		'maxday  = Rs("maxday")
		'if maxday = 0 then maxday = "无限制"
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
		If IsNull(map_x) Or map_x = "" Then '如果为空就用默认位置
			map_x = "113.400961" '百度坐标 x 
			map_y = "23.057637" '百度坐标 y 
			is_empty_map=1 '没有坐标
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
		'获取剩余1个月内的房源
		'leftDays = DateDiff("d",Now(),expiredate)
		
		'If leftDays > 30 Then leftDays = 30
		
		'重查旅店所属村落
		 Sql = "Select * from T_City Where citypostcode="&vallegeCode
		
		Set Rs = Dream3CLS.Exec(Sql)
		If not Rs.EOF Then
			vallege=Rs("cityname")
		end if
		
End Sub
	
	
%>
<%

G_Title_Content  = h_hotelname &"-" &vallege&"住宿-广州大学城住宿|有旅馆"
G_Keywords_Content = vallege & "住宿,"&vallege&"旅馆,"&vallege&"酒店,大学城住宿|有旅馆"
G_Description_Content1 = "酒店介绍: "&h_discription&";交通路线:"&h_line&";联系方式:"&mobile
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
        	<span><a onclick="this.blur();" class="sd-log sd-position2" target="_blank" title="该房间<%=Dream3CLS.SiteConfig("SiteShortName")%>员工已实地考察,您可以放心入住" href="help/index.asp?c=roomspec"></a></span>
			<span>星级：<%=h_star%></span>
        </div>
        <div class="add">地址： <%=h_address%>  
		 
<!-- sharebar button begin --
<a class="sharebar_button" href="http://www.sharebar.cn/"><img src="http://s.sharebar.cn/img/lg-share-cn.gif" width="125" height="21" alt="分享条" style="border:0"/></a>
<script type="text/javascript" src="http://s.sharebar.cn/js/sharebar_button.js" charset="utf-8"></script>
<!-- sharebar button end -->
<!-- Baidu Button BEGIN -->
    <div id="bdshare" class="bdshare_t bds_tools get-codes-bdshare">
        <span class="bds_more">分享到：</span>
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
                <li class="show_selectTag"><A onClick="show_selectTag('tagContent0',this)" href="javascript:">酒店图片</A> </li>
                <li><A onClick="show_selectTag('tagContent1',this);initialize()" href="javascript:void(0)">地图</A> </li> <!-- mike 顶,这个地方搞了两个钟-->
				<!--<li><A onClick="show_selectTag('tagContent2',this)" href="javascript:void(0)">日历</A> </li> -->
            </ul>
            <div id="show_tagContent">
                <div class="show_tagContent show_selectTag" id="tagContent0">
                	
                    <div style="height: 520px; padding-top:5px" class="wrap picshow"><!--大图轮换区-->
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
                            <img src="<%=imgsum(i)%>" alt="<%=h_hotelname%>酒店图片<%=i %>" height="430">
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
                                        <A id="thumb_xixi-<%=i%>" href="#"><img src="<%=imgsum(i)%>"height="40" alt="<%=h_hotelname%>酒店图片二<%=i %>"></A>
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
                                    <!--地图-->
                        <div id="map" class="gmap3">   <!-- mike -->
                 
                        </div>
                    </div>
                    
                </div>
                <!--<div id="map" style="width:580px;height:420px"></div><div class="show_tagContent" id="tagContent2">
                
                	<div class="show_day">
                    	<div class="show_day">
								<div class="calendar">
									<h2>近一个月房源</h2>
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
												<span class="addCalendarRoom yd">已预订</span>
												<span class="addCalendarPrice"></span>
											<%Else%>
												<span class="addCalendarRoom kz">可租</span>
												<span class="addCalendarPrice"><a href="buy.asp?checkintype=perDay&startdate=<%=fDays%>&enddate=<%=fDays%>&pid=<%=detail_id%>&checkinRoomNum=1">我要预订</a></span>
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
            // 操作标签
            var tag = document.getElementById("show_tags").getElementsByTagName("li");
            var taglength = tag.length;
            for(i=0; i<taglength; i++){
                tag[i].className = "";
            }
            selfObj.parentNode.className = "show_selectTag";
            // 操作内容
            for(i=0; j=document.getElementById("tagContent"+i); i++){
                j.style.display = "none";
            }
            document.getElementById(showContent).style.display = "block";
            
            
        }
        </SCRIPT>
        </p>
        
        <div id="show1_con">
            <ul id="show1_tags">
                <li class="show1_selectTag"><A onClick="show1_selectTag('tag_Content0',this)" href="javascript:void(0)">房间展示</A> </li>
                <li><A onClick="show1_selectTag('tag_Content1',this)" href="javascript:void(0)">配套设施</A> </li>
                <li><A onClick="show1_selectTag('tag_Content2',this)" href="javascript:void(0)">交易规则</A> </li>
                <li><A onClick="show1_selectTag('tag_Content3',this)" href="javascript:void(0)">酒店介绍及交通</A> </li>
            </ul>
            <div id="show1_tagContent">
                <div class="show1_tagContent show1_selectTag" id="tag_Content0">
                	<div class="tab-con2">
                    <DIV class=hInfo>
						<div class="htitle">
							<li>房型</li>
							<li>床型</li>
							<li>面积</li>
							<li>房间数</li>
							<li>平日价</li>
							<li>周末价</li>
							
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
							<li><a href="detail.asp?pid=<%=detail_id%>&fromdate=<%=Dream3CLS.TimeFormateToTwoBits(fromdate)%>&todate=<%=Dream3CLS.TimeFormateToTwoBits(todate)%>"><strong>查看</strong></a></li>
							<li><a onclick="myFormShow('myForm');" href="detail.asp?pid=<%=detail_id%>&fromdate=<%=Dream3CLS.TimeFormateToTwoBits(fromdate)%>&todate=<%=Dream3CLS.TimeFormateToTwoBits(todate)%>"><img src="/common/themes/Default/img/order.jpg" alt=""></a></li>
						</div>
						<ul style="DISPLAY: none" id=items<%=i%>_1>
							<div class="hbox">
床型：<%=bedtype%>&nbsp;&nbsp;房间面积：<%=area%>平方米&nbsp;&nbsp;房间数：<%=roomsnum%>&nbsp;&nbsp;可住人数：<%=guestnum%> &nbsp;&nbsp;平时日均价：<%=dayrentprice%>&nbsp;&nbsp;周末日均价：<%=weekrentprice%>&nbsp;&nbsp;月均价：<%=monthrentprice%><br />
房间描述：<%=RoomDesc%>

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
                        	<p><b>有旅馆网(www.yoinns.com)交易规则</b>：<br></p>
                            <ul>
                            <li>浏览并确定所预订房间后，请务必在线<b style="color:#ff0000;">全额支付</b>房款。</li>
                            <li>在您入住其间，您的资金将由“有旅馆”网站(www.yoinns.com)保管，绝对安全。</li>
                            <li>订单一旦下达，房间将整晚保留,若到店无房,房费全部退还。</li> 
                            <li>额外的服务费用和押金不包含在总房租内，由房东线下收取。</li>
                            <li>为保证您到达时有房和交易安全，请务必通过有旅馆网在线支付房款。拒绝旅店线下支付的要求。</li>
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
                            <strong>介绍：</strong><%=h_discription%><br />
							<br><strong>交通路线：</strong><%=h_line%><br />
							<%if not isempty(Session("_UserName")) then %>
                              <br><strong>联系方式：</strong><%=mobile%>
                            <%else%>
                            <br><strong>联系方式：</strong>  <a href="javascript:void(0)" onclick="load_login('');go_top()">登录</a>后可见
							<!--  <br><strong>联系方式：</strong>  <A href="user/account/login.asp">登录</A>后可见 -->
                            <%end if %>
							
                        </div>
                    </div>
                
                </div>
            </div>
        </div>
        <p>
          <SCRIPT type=text/javascript>
        function show1_selectTag(showContent,selfObj){
            // 操作标签
            var tag = document.getElementById("show1_tags").getElementsByTagName("li");
            var taglength = tag.length;
            for(i=0; i<taglength; i++){
                tag[i].className = "";
            }
            selfObj.parentNode.className = "show1_selectTag";
            // 操作内容
            for(i=0; j=document.getElementById("tag_Content"+i); i++){
                j.style.display = "none";
            }
            document.getElementById(showContent).style.display = "block";
            
            
        }
        </SCRIPT>
        </p>
        
        <div class="info_pl" style="display:block ">
            <a class="nav-unit nav-selected" href="#">本房间评论</a>
        </div>
        
        
        
        
        
       <!-- <div class="pinglun" style="display:block;">
        	暂无评论(评论5条一页)
        </div>
        
        <div class="pinglun" style="display:block ">
        
            <div class="pinglun_box">
            
                <div class="pl_img">
                    <img width="60" height="60" title=" " src="/images/user_normal.jpg">
                    <p>用户评论</p>
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
                    <dd>整洁卫生（好评）</dd>
                    <dd>安全程度（好评）</dd>
                    <dd>描述相符（好评）</dd>
                    <dd>交通位置（好评）</dd>
                    <dd>性价比（好评）</dd>
                </dl>
                
            </div>
            
                       
        	
            <div class="page_t right">
                <span>上一页</span>
                <strong>1</strong>
                <a href="#">2</a>
                <a href="#">3</a>
                <a href="#">4</a>
                <a href="#">5</a>
                <a href="#">6</a>
                <a href="#">7</a>
                <a href="#">8</a>
                <a href="#">9</a> 
                <a href="#" class="pagedown">下一页</a>
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
			'按照SpecialPrice计算价格
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
			<span style="" class="font1" id="price"><b>￥</b><%=sumPrice%></span>
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
			
				stt="<option  value='"&mRs("id")&"'>"&mRs("houseTitle")&"</option>" '房间名字

			'if num=0 then ' 建立JS数组
				'sz_id=mRs("id")
			'else
				'sz_id=sz_id&","&mRs("id")
			'end if
			dtt=dtt&stt
			'num=num+1
			mRs.Movenext
		Loop
		mRs.close
		'sz_id=sz_id&",0" '数组加多个零
		'============================mike
			%>
                <i class="renttype_tip">
				
				<!--已经有价格排期 旧周末价不再显示 xiaoyaohang-->
                <select  name="detail_id" onchange="get_new_price('startdate','enddate','detail_id');" id="detail_id" class="jianye" >
					<%=dtt%> 
				</select>
                	<!-- add by xiaoyaohang -->
                <script type="text/javascript">
                function getQueryString(name)
                {
                    // 如果链接没有参数，或者链接中不存在我们要获取的参数，直接返回空
                    if(location.href.indexOf("?")==-1 || location.href.indexOf(name+'=')==-1)
                    {
                        return '';
                    }
                 
                    // 获取链接中参数部分
                    var queryString = location.href.substring(location.href.indexOf("?")+1);
                 
                    // 分离参数对 ?key=value&key2=value2
                    var parameters = queryString.split("&");
                 
                    var pos, paraName, paraValue;
                    for(var i=0; i<parameters.length; i++)
                    {
                        // 获取等号位置
                        pos = parameters[i].indexOf('=');
                        if(pos == -1) { continue; }
                 
                        // 获取name 和 value
                        paraName = parameters[i].substring(0, pos);
                        paraValue = parameters[i].substring(pos + 1);
                 
                        // 如果查询的name等于当前name，就返回当前值，同时，将链接中的+号还原成空格
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
				<option value="<%=i%>"><%=i%>间</option>
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
            <p class="fd">(房东)</p>         
        </div>
        
        <div class="per-con2">
			<h3 class="">随便看看</h3>
        	<ul>
				<%=Dream3Product.GetAboutHotel(show_id)%>
			</ul>	        
        </div>
        
    </div>
    
</div>
<!--
mike 不要了
<script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>
<script language="javascript" src="<%=VirtualPath%>/common/js/jquery/gmap3.min.js"></script>

-->
<script type="text/javascript" >
    //============================================== 百度地图start
	function loadScript() {
	  var script = document.createElement("script");
	  script.src = "http://api.map.baidu.com/api?v=1.3&callback=initialize";
	  document.body.appendChild(script);
	}
	window.onload = loadScript; //加载远程JS
	
	function initialize() { //主函数
	
	  var map = new BMap.Map('map');
	
		var point = new BMap.Point(<%=map_x%>,<%=map_y%>); //坐标
		
		map.centerAndZoom(point,14);                   // 初始化地图,设置城市和地图级别。
	
		map.enableScrollWheelZoom();    //启用滚轮放大缩小，默认禁用
		map.enableContinuousZoom();    //启用地图惯性拖拽，默认禁用
		
		map.addControl(new BMap.MapTypeControl({anchor: BMAP_ANCHOR_TOP_RIGHT}));    //左上角，默认地图控件
		
		var opts = {type: BMAP_NAVIGATION_CONTROL_ZOOM, anchor: BMAP_ANCHOR_BOTTOM_RIGHT} 
		map.addControl(new BMap.NavigationControl(opts));//增加缩放控件
	
		//加载 存储的标注 start
		var marker = new BMap.Marker(point);
		map.addOverlay(marker);
		var label = new BMap.Label("我在这里!",{offset:new BMap.Size(20,-10)});
		marker.setLabel(label);
	}
    //============================================== 百度地图end
	
	function go_top(){
		scroll(0,0)
		//window.scrollBy(0,-15);
		//alert(document.documentElement.scrollTop);
	
		//scrolldelay = setTimeout("go_top()",100);
		
		//	go_top();
			
	}
	
	
    </script> 



<!--#include file="common/inc/footer_user.asp"-->