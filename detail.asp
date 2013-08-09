<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->
<!--#include file="SqlFilter.asp"-->

<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount

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
Dim h_discriptio '酒店描述
Dim h_line '交通路线
Dim dayrentprice,weekrentprice,monthrentprice

Dim  map_x,map_y

Dim img1,img2,img3,img4,img5,img6,img7,img8,img9,img10,h_img
Dim userid,detail_id
Dim userIdArr(0) ,userMap
Dim userface

Dim leftDays '展示剩余天数的房源
Dim vallege,vallegeCode '旅店所属的村落

Dim fromdate,todate,fromdate_str,todate_str

Set userMap = new AspMap
dim fangdong
dim ismanager
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
		detail_id = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
		
		Sql = "Select * from T_Product Where id="&detail_id&" and state='normal'"
		
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Dream3CLS.showMsg "您要查询的信息不存在！","S","error.asp"
			Response.End()
		End If
		
		Set cityMap = new AspMap
		Call Dream3Product.getCategoryMap("city",cityMap)
		
		userule = Rs("userule")
		RoomDesc = Rs("RoomDesc")
		lodgeType = Rs("lodgeType")
		leaseType = Rs("leaseType")
		area = Rs("area")
		guestnum = Rs("guestnum")
		roomsnum = Rs("roomsnum")
		If roomsnum = 11 then roomsnum = "大于10"
		bednum = Rs("bednum")
		If bednum = 11 then bednum = "大于10"
		bedtype = Rs("bedtype")
		bedtype = Dream3Static.GetBedType(bedtype)
		
		
		'orange新增内容
		hid=Rs("hid")
		sql2="select * from T_hotel where h_id="&hid
		Set Rs2 = Dream3CLS.Exec(Sql2)
		If Rs2.EOF Then
			Dream3CLS.showMsg "您要查询的信息不存在！","S","error.asp"
			Response.End()
		End If
		
		address=Rs2("h_address")
		h_line= Rs2("h_line")
		h_discription= Rs2("h_discription")
		h_img= Rs2("h_img")
		vallegeCode= Rs2("h_citycode")
		
		
		
		'made by chengguan
		h_uid=Rs2("h_uid")
		Set Rs3 = Dream3CLS.Exec("select username from T_User where id='"&h_uid&"'")
		If Rs3.EOF Then
			Dream3CLS.showMsg "您要查询的信息不存在！","S","error.asp"
			Response.End()
		End If
		fangdong=Rs3(0)
		if Session("_UserID")<>"" then
		Set Rs4 = Dream3CLS.Exec("select state from T_User where id='"&Session("_UserID")&"'")
		If Rs4.EOF Then
			Dream3CLS.showMsg "您要查询的信息不存在！","S","error.asp"
			Response.End()
		End If
		ismanager=Rs4(0)
		end if
		
		
		
		
		toiletnum = Rs("toiletnum")
		If toiletnum = 11 then toiletnum = "大于10"
		checkouttime= Rs("checkouttime")
		checkintime  = Rs("checkintime")
		minday = Rs("minday")
		maxday  = Rs("maxday")
		if maxday = 0 then maxday = "无限制"
		invoice = Rs("invoice")
		'address = Rs("address")
		housetitle = Rs("housetitle")
		facilities = Rs("facilities")
		facilities = ","&facilities&","
		
		img1 = Rs("image")  
		img2 = Rs("image1")  
		img3 = Rs("image2")  
		img4 = Rs("image3")  
		img5 = Rs("image4")  
		img6 = Rs("image5")  
		img7 = Rs("image6")  
		img8 = Rs("image7")  
		img9 = Rs("image8")  
		img10 = Rs("image9") 
		
		map_x = Rs("map_x") 
		map_y = Rs("map_y") 
		
		dayrentprice = Rs("dayrentprice") 
		weekrentprice = Rs("weekrentprice") 
		monthrentprice = Rs("monthrentprice") 
		expiredate = Rs("expiredate")
		order_days = Rs("order_days")
		
		order_days = "," & order_days & ","
		
		userid = Rs("user_id")

		userIdArr(0) = userid
		
		
		Call Dream3Product.getUserMap(userIdArr,userMap)
		
		userface = userMap.getv(CStr(userid))(3)
		If ( IsNull(userface) or userface = "") Then
			userface = VirtualPath & "/images/user_normal.jpg"
		End If
		
		'获取剩余1个月内的房源
		leftDays = DateDiff("d",Now(),expiredate)
		
		If leftDays > 30 Then leftDays = 30
		
		'重查旅店所属村落
		 Sql = "Select * from T_City Where citypostcode="&vallegeCode
		
		Set Rs = Dream3CLS.Exec(Sql)
		If not Rs.EOF Then
			vallege=Rs("cityname")
		end if
	
		
End Sub
	
	
%>
<%
        detail_id = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
			
		Sql = "Select * from T_Product Where id="&detail_id&" and state='normal'"
	    Set Rs = Dream3CLS.Exec(Sql)
	    hid=Rs("hid")
	    Sql="Select * from T_hotel Where h_id="&hid
	    Set Rs = Dream3CLS.Exec(Sql)
	    jiuname=Rs("h_hotelname")
		%>
<%

G_Title_Content = housetitle &"-" &vallege&"住宿-广州大学城住宿|有旅馆"
G_Keywords_Content = vallege & "住宿,"&vallege&"旅馆,"&vallege&"酒店,大学城住宿|有旅馆"
G_Description_Content = left(roomdesc,150)
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<SCRIPT type=text/javascript src="<%=VirtualPath%>/common/js/slide.js"></SCRIPT>
<script language="javascript" src="<%=VirtualPath%>/common/js/time.js"></script>
<link href="./calender/calender.css" style="text/css" rel="stylesheet"/>

	
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
            <a href="<%=VirtualPath%>/index.asp"><%=Dream3CLS.SiteConfig("SiteShortName")%></a> &gt <a href="list.asp?cityname=<%=vallege%>"><%=vallege%></a>&gt<a href=show.asp?hid=<%=hid %> ><%=jiuname%></a>&gt<%=housetitle%>
            <a href="#"></a> 
        </p>
        <div class="title-room">
        <h1><%=housetitle%></h1>
        	<span><a onclick="this.blur();" class="sd-log sd-position2" target="_blank" title="该房间<%=Dream3CLS.SiteConfig("SiteShortName")%>员工已实地考察,您可以放心入住" href="help/index.asp?c=roomspec"></a></span><span>有效期至：<%=expiredate%></span> <h3> <span><%=Dream3Static.GetLodgeType(lodgeType)%> <%=Dream3Static.GetLeaseType(leaseType)%></span></h3>
          
            <span class="ico-pl"><a href="#comment" class="room_comment"></a></span>
        </div>
        <div class="add">地址： <%=address%>
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
                <li class="show_selectTag"><A onClick="show_selectTag('tagContent0',this)" href="javascript:void(0)">房间图片</A> </li>
                <li><A onClick="show_selectTag('tagContent1',this)" href="javascript:void(0)">地图</A> </li>
				<li><A onClick="show_selectTag('tagContent2',this)" href="javascript:void(0)">日历</A> </li>
            </ul>
            <div id="show_tagContent">
                <div class="show_tagContent show_selectTag" id="tagContent0">
                	
                    <div style="height: 520px; padding-top:5px" class="wrap picshow"><!--大图轮换区-->
                        <div id="picarea">
                        <div style="margin: 0px auto; width: 666px; height: 436px; overflow: hidden">
                        <div style="margin: 0px auto; width: 666px; height: 436px; overflow: hidden" id="bigpicarea">
                        <P class=bigbtnPrev><SPAN id=big_play_prev></SPAN></P>
						
						<%If img1 <> "" Then%>
                        <div id="image_xixi-01" class="image">
                            <img src="<%=img1%>" alt="<%=housetitle %>" height="430">
                            <div class="word">
                                
                            </div>
                        </div>
						<%End If%>
						<%If img2 <> "" Then%>
                        <div id="image_xixi-02" class="image">
                            <img src="<%=img2%>"  alt="<%=housetitle %>" height="430"> 
                            <div class="word">
                               
                            </div>
                        </div>
						<%End If%>
						<%If img3 <> "" Then%>
                        <div id="image_xixi-03" class="image">
                            <img src="<%=img3%>" alt="<%=housetitle %>" height="430">
                            <div class="word">
                                
                            </div>
                        </div>
						<%End If%>
						<%If img4 <> "" Then%>
                        <div id="image_xixi-04" class="image">
                            <img src="<%=img4%>" alt="<%=housetitle %>"  height="430"> 
                            <div class="word">
                                <h3></h3>
                            </div>
                        </div>
						<%End If%>
						<%If img5 <> "" Then%>
                        <div id="image_xixi-05" class="image">
                            <img src="<%=img5%>" alt="<%=housetitle %>" height="430"> 
                            <div class="word">
                                <h3></h3>
                            </div>
                        </div>
						<%End If%>
						<%If img6 <> "" Then%>
                        <div id="image_xixi-06" class="image">
                            <img src="<%=img6%>" alt="<%=housetitle %>" height="430"> 
                            <div class="word">
                                <h3></h3>
                            </div>
                        </div>
						<%End If%>
						<%If img7 <> "" Then%>
                        <div id="image_xixi-07" class="image">
                            <img src="<%=img7%>" alt="<%=housetitle %>" height="430"> 
                            <div class="word">
                                <h3></h3>
                            </div>
                        </div>
						<%End If%>
						<%If img8 <> "" Then%>
						<div id="image_xixi-08" class="image">
                            <img src="<%=img8%>" alt="<%=housetitle %>" height="430"> 
                            <div class="word">
                                <h3></h3>
                            </div>
                        </div>
						<%End If%>
						<%If img9 <> "" Then%>
						<div id="image_xixi-09" class="image">
                            <img src="<%=img9%>" alt="<%=housetitle %>" height="430"> 
                            <div class="word">
                                <h3></h3>
                            </div>
                        </div>
						<%End If%>
						<%If img10 <> "" Then%>
						<div id="image_xixi-10" class="image">
                            <img src="<%=img10%>" alt="<%=housetitle %>" height="430"> 
                            <div class="word">
                                <h3></h3>
                            </div>
                        </div>
						<%End If%>
                        <P class="bigbtnNext"><SPAN id="big_play_next"></SPAN></P>
                        </div>
                        </div>
                         <div id="smallpicarea" style="overflow-x: scroll;height: 70px">
                            <div id="thumbs" style="WIDTH: 900px">
                                <ul>
                                    <li class="first btnPrev"><img id="play_prev" src="<%=VirtualPath%>/common/themes/<%=Dream3CLS.SiteConfig("DefaultSiteStyle")%>/img/left.png"></li>
                                    <%
									If img1 <> "" Then
									%>
									<li class="slideshowItem">
                                        <A id="thumb_xixi-01" href="#"><img src="<%=img1%>"height="40"></A>
                                    </li>
									<%End If%>
									<%
									If img2 <> "" Then
									%>
                                    <li class="slideshowItem">
                                        <A id="thumb_xixi-02" href="#"><img src="<%=img2%>"height="40"></A>
                                    </li>
									<%End If%>
									<%
									If img3 <> "" Then
									%>
                                    <li class="slideshowItem">
                                        <A id="thumb_xixi-03" href="#"><img src="<%=img3%>"height="40"></A>
                                    </li>
									<%End If%>
									<%
									If img4 <> "" Then
									%>
                                    <li class="slideshowItem">
                                        <A id="thumb_xixi-04" href="#"><img src="<%=img4%>"height="40"></A>
                                    </li>
									<%End If%>
									<%
									If img5 <> "" Then
									%>
                                    <li class="slideshowItem">
                                        <A id="thumb_xixi-05" href="#"><img src="<%=img5%>"height="40"></A>
                                    </li>
									<%End If%>
									<%
									If img6 <> "" Then
									%>
                                    <li class="slideshowItem">
                                        <A id="thumb_xixi-06" href="#"><img src="<%=img6%>"height="40"></A>
                                    </li>
									<%End If%>
									<%
									If img7 <> "" Then
									%>
                                    <li class="slideshowItem">
                                        <A id="thumb_xixi-07" href="#"><img src="<%=img7%>"height="40"></A>
                                    </li>
									<%End If%>
									<%
									If img8 <> "" Then
									%>
                                    <li class="slideshowItem">
                                        <A id="thumb_xixi-08" href="#"><img src="<%=img8%>"height="40"></A>
                                    </li>
									<%End If%>
									<%
									If img9 <> "" Then
									%>
                                    <li class="slideshowItem">
                                        <A id="thumb_xixi-09" href="#"><img src="<%=img9%>"height="40"></A>
                                    </li>
									<%End If%>
                                    <%
									If img10 <> "" Then
									%>
                                    <li class="slideshowItem">
                                        <A id="thumb_xixi-10" href="#"><img src="<%=img10%>"height="40"></A>
                                    </li>
									<%End If%>
                                    <li class="last btnNext"><img id="play_next" src="<%=VirtualPath%>/common/themes/<%=Dream3CLS.SiteConfig("DefaultSiteStyle")%>/img/right.png"></li>
                                </ul>
                            </div>
                        </div>
                        </div>
                        <SCRIPT>
                        var target = ["xixi-01","xixi-02","xixi-03","xixi-04","xixi-05","xixi-06","xixi-07"];
                        </SCRIPT>
                        </div>
                    
                </div>
                <div class="show_tagContent" id="tagContent1">
                	
                    <div class="show_map">
                    	<!--地图-->
                    	<div id="mapzone" class="gmap3"></div>
                    </div>
                    
                </div>
                <div class="show_tagContent" id="tagContent2">
                
                	<div class="show_day">
                    
                    </div>
                
                </div>
            </div>
        </div>
        
        <br>
		<div >		
			<ul id="Ul1">
                <li class="show_selectTag"><A onClick="show_selectTag('tagContent0',this)" href="javascript:void(0)">价格排期</A> </li>
               
            </ul>
                <div >
                	<div class="show_day">
                    	<!--#include file="calender/calender.asp"-->
                    </div>
                
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
                <li class="show1_selectTag"><A onClick="show1_selectTag('tag_Content0',this)" href="javascript:void(0)">房间描述</A> </li>
                <li><A onClick="show1_selectTag('tag_Content1',this)" href="javascript:void(0)">配套设施</A> </li>
                <li><A onClick="show1_selectTag('tag_Content2',this)" href="javascript:void(0)">交易规则</A> </li>
                <li><A onClick="show1_selectTag('tag_Content3',this)" href="javascript:void(0)">交通路线</A> </li>
            </ul>
            <div id="show1_tagContent">
                <div class="show1_tagContent show1_selectTag" id="tag_Content0">
                	
                    <div class="tab-con2">
                        <p class="fjms">
						<%=RoomDesc%>
                        </p>
                        <div class="fjms-right">
                            <ul>
                                <!--<li><span>房屋类型:</span><%=Dream3Static.GetLodgeType(lodgeType)%></li>
                                <li style="background: none repeat scroll 0% 0% rgb(234, 243, 245);"><span>出租类型:</span><%=Dream3Static.GetLeaseType(leaseType)%></li>-->
                                <li><span>面积:</span><%=area%>&nbsp;平方米</li>
                                <li style="background: none repeat scroll 0% 0% rgb(234, 243, 245);"><span>可住人数:</span><%=guestnum%>&nbsp;人</li>
                                <li><span>房间数:</span><%=roomsnum%>&nbsp;间</li>
                                <li style="background: none repeat scroll 0% 0% rgb(234, 243, 245);"><span>床数:</span><%=bednum%>&nbsp;张</li>
                                <li><span>床型:</span><%=bedtype%></li>
                                <li style="background: none repeat scroll 0% 0% rgb(234, 243, 245);"><span>卫生间数:</span><%=toiletnum%>&nbsp;个</li>
                                <li><span>入住时间:</span><%=checkintime%>之后</li>
                                <li style="background: none repeat scroll 0% 0% rgb(234, 243, 245);"><span>退房时间:</span><%=checkouttime%>之前</li>
                                <li><span>最少天数:</span><%=minday%>&nbsp;天</li>
                                <li style="background: none repeat scroll 0% 0% rgb(234, 243, 245);"><span>最多天数:</span><%=maxday%></li>
                                <li><span>发票:</span><%if invoice="y" Then%>提供<%Else%>不提供<%End If%></li>
                            </ul>
                        </div>
                    </div>
                    
                </div>
                <div class="show1_tagContent" id="tag_Content1">
                	
                    <div class="tab-con2">
                        <div class="yym-detail">
                           <%
							Set f_Rs = Server.CreateObject("adodb.recordset")	
							Sql = "select id,cname from T_Facility Where enabled='Y' order by seqno desc"		
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
                            <%=h_line%>
                           
                        </div>
                    </div>
                
                </div>
            </div>
        </div>
        
 <!--   593~679 made by chinese    chengguan-->      
 
  
         <div id="show2_con">
                  <ul id="show2_tags">
                        <li > <A onClick="show2_selectTag('tag2Content1',this)" href="javascript:void(0)">查看评论</A> </li>
                        <li  <%if ismanager="2" then%> style="display:none"<%end if%>><A onClick="show2_selectTag('tag2Content0',this)" href="javascript:void(0)">添加评论</A> </li>
                      
                  </ul>
                  <div id="show2_tagContent">
                        <div class="show2_tagContent" id="tag2Content0">
                              <div class="tab-con2">
                                   <%if not isempty(Session("_UserName")) then %>
                                    <form action="commentssubmit.asp" method="post" name="addpinglun" onSubmit="return check()" >
                                           评论内容:<br>
                                          <textarea name="pinglunarea" cols="80" rows="8"></textarea>
                                          <input name="href" type="hidden" value="detail.asp?pid=<%=detail_id%>"/>
                                          <input name="hid" type="hidden" value=<%=hid%> />
                                          <input name="fangdong" type="hidden" value=<%=fangdong%> />
                                          <input name="roomid" type="hidden" value=<%=detail_id%> />
                                          <input name="hotelname" type="hidden" value=<%=jiuname%> />
                                          <input name="username" type="hidden" value=<%=Session("_UserName")%> />
                                          <input name="houseTitle" type="hidden" value=<%=houseTitle%> />
                                          <br><br>
                                          <input name="checkcode" type="text" class="reg_txt" id="checkcode" size="5" maxlength="4" onFocus="get_checkcode();this.onfocus=null;" onKeyUp="ajaxcheckcode('check_code','checkcode');" />
                                          <br>
                                          <span id="img_checkcode" style="cursor:pointer;" onClick="get_checkcode();">点击获取验证码</span><span id="isok_checkcode"></span>
                                          <input name="fabiao" type="submit" value="发表评论" />
                                          <input name="cancel" type="reset" value="取消"  />
                                    </form>
                                    <%else%>
                                    啦 <A href="./user/account/login.asp">登录</A>完才能评论啦
                                    <%end if %>
                              </div>
                        </div>
                
                
                        <div class="show2_tagContent show2_selectTag" id="tag2Content1">
                              <div class="tab-con2"><a name="3"></a>
                                    <%
dim pageiswho
dim bigpage
Dim pageintPageNow
dim pagesql
dim pagestrLocalUrl

pagestrLocalUrl = request.ServerVariables("SCRIPT_NAME")&"?pid="&detail_id
pagesql="select id,username,userface,hotelname,houseTitle,contents,state,createtime,owner,callback,callbacktime from T_Comments where  roomid='"&detail_id&"'"


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
pagesql=pagesql&"and  username='"&Session("_UserName")&"' or state ='Y' and roomid='"&detail_id&"'"
else
pagesql=pagesql&" and state='Y'"
end if 
end if 
%>
                                    <!--#include file="commentsdisplay.asp"--> 
                              
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
        
        
        
        
    <!--    <div class="info_pl" style="display:none ">
            <a class="nav-unit nav-selected" href="#">本房间评论</a>
        </div>
        
        <div class="pinglun" style="display:none;">
        	暂无评论(评论5条一页)
        </div>
        
        <div class="pinglun" style="display:none ">
        
            <div class="pinglun_box">
            
                <div class="pl_img">
                    <img width="60" height="60" title="boywangxj" src="#">
                    <p>boywangxj</p>
                </div>
                <div class="pl_text">
                    <div class="pl_text_center">
                        <span class="pl_sanjiao"></span>
                        <div class="moreinfo">
                        	<p>房东很漂亮也很热情，当时选择这个度假屋就是因为房东是个女的，感觉女房东会更爱干净些，呵呵~~</p>
                        </div>
                        <p class="detail_comment">点评时间：2012-03-16 10:14</p>
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
            
                        <div class="pinglun_box">
            
                <div class="pl_img">
                    <img width="60" height="60" title="boywangxj" src="">
                    <p>boywangxj</p>
                </div>
                <div class="pl_text">
                    <div class="pl_text_center">
                        <span class="pl_sanjiao"></span>
                        <div class="moreinfo">
                        <p>环境很不错，老板娘很漂亮</p>
                        </div>
                        <p class="detail_comment">点评时间：2012-03-16 10:14</p>
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
    
    <div class="right-detail">
    	
		<form method="post" action="buy1.asp" name="myForm" id="myForm" onsubmit="return order_check('myForm')">
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
			%>
				<span style="" class="font1" id="price"><b>￥</b><%=sumPrice%></span>
                <!--<i class="renttype_tip">一个房间/晚</i>-->
            </div>
            <p class="book-tips"></p>
            <div class="yd-sel">
			<input type="text" readonly="readonly" value="<%=Dream3CLS.TimeFormateToTwoBits(fromDate)%>" id="startdate" name="startdate" onchange="test()" onclick="WdatePicker({minDate:'%y-%M-%d',onpicked:function(){former_select('startdate','enddate');get_new_price('startdate','enddate','pid');}})"/>

            <input type="text" readonly="readonly" value="<%=Dream3CLS.TimeFormateToTwoBits(toDate)%>" id="enddate" name="enddate" onclick="WdatePicker({minDate:'#F{$dp.$D(\'startdate\',{d:+1})}',onpicked:function(){get_new_price('startdate','enddate','pid');}})" />


                <select onchange="get_new_price('startdate','enddate','pid')"  name="checkinRoomNum" id="checkinRoomNum" class="day_select">
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
		<input type="hidden" name="pid" id="pid" value="<%=detail_id%>"/>
		<input type="hidden" name="checkinrenttype" value=""/>
		</form>
        
        <div class="per-con">
        	<a href=show.asp?hid=<%=hid %>><img height="225" src="<%If IsNull(h_img) or h_img="" Then response.Write("images/user_normal.jpg") else response.Write(h_img)%>"></a>
        	<a href=show.asp?hid=<%=hid %> ><h2 class="font2"><%=jiuname%></h2></a>
            <p class="fd">(所属酒店)</p>         
        </div>
        
        
        
    </div>
    
</div>



<script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>
<script language="javascript" src="<%=VirtualPath%>/common/js/jquery/gmap3.min.js"></script>

<script type="text/javascript">
    
      $(function(){
     
        $("#test1").gmap3();
  
          var addr = "<%=address%>";
          if ( !addr || !addr.length ) return;
          $("#mapzone").gmap3({
            action:   'getlatlng',
            address:  addr,
            callback: function(results){
              if ( !results ) return;
              $(this).gmap3({
                action:'addMarker',
                latLng:results[0].geometry.location,
                map:{
                  center: true,
				  zoom: 14
                },infowindow:{
				  options:{
					size: new google.maps.Size(50,20),
					content: '<div id="elevation"><%=address%></div>'
				  },
				  onces: {
					domready: function(){
					  //refreshinfowindow( center );
					}
				  }
				}
              });
            }
          });
        
        
      });
      
      		    function show2_selectTag(showContent,selfObj){
            // 操作标签
            var tag = document.getElementById("show2_tags").getElementsByTagName("li");
            var taglength = tag.length;
            for(i=0; i<taglength; i++){
                tag[i].className = "";
            }
            selfObj.parentNode.className = "show2_selectTag";
            // 操作内容
            for(i=0; j=document.getElementById("tag2Content"+i); i++){
                j.style.display = "none";
            }
            document.getElementById(showContent).style.display = "block";
            
            
        }
		
		var show_checkcode = false;
    function get_checkcode() {
	var chkCodeFile = "../../common/inc/getcode.asp";
	if(!show_checkcode){
		if(document.getElementById("img_checkcode"))
			document.getElementById("img_checkcode").innerHTML = '<img  id="checkcodeimg" src="'+chkCodeFile+'?t='+Math.random()+'" alt="点击刷新验证码" style="cursor:pointer;border:0;vertical-align:middle;height:18px;" onclick="this.src=\''+chkCodeFile+'?t=\'+Math.random()" />'
			show_checkcode = true;

		if(document.getElementById("isok_checkcode"))
			document.getElementById("isok_checkcode").innerHTML = '<a href="javascript://" onclick="setTimeout(function(){ document.getElementById(\'checkcodeimg\').src=\''+chkCodeFile+'?t=\'+Math.random()},100);">看不清<\/a>';
	}
}
		
	 function check(){
		  
		  if (document.addpinglun.pinglunarea.value.length==0){
			  alert("请输入具体评论！");
			 
			  document.addpinglun.pinglunarea.focus();
			  
			  return false;
			  }
			 if (document.addpinglun.pinglunarea.value.length>200){
			  alert("评论内容不得超过200字！");
			 
			  document.addpinglun.pinglunarea.focus();
			  
			  return false;
			  }
		  }
	  
      
      
</script> 

   
	<div></div>
	<!--#include file="common/inc/footer_user.asp"-->