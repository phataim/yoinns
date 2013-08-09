<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_static.asp"-->
<!--#include file="../../onlinepay/onlinepaycode.asp"-->

<%
Dim Action
Dim pid
Dim city_code,lodgeType,leaseType,houseTitle,address,invoice
Dim roomtitle,area,guestnum,toiletnum,roomdesc,userule,bedtype,roomsnum,bednum,expireDate,startDate,hid
Dim img1,img2,img3,img4,img5,img6,img7,img8,img9,img10
Dim facilities
Dim checkintime,checkouttime,minday,maxday,refundday,paymentRules,dayrentprice,weekrentprice,monthrentprice

Action = Request.QueryString("act")
Select Case Action
	Case "save"
		Call SaveRecord()
	Case "showedit"
		Call ShowEdit()
	Case Else
		Call Main()
End Select



Sub ShowEdit()
	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	Sql = "Select * from T_Product Where id="&Pid&" and user_id="&Session("_UserID")
	Set Rs = Dream3CLS.Exec(Sql)
	If Rs.EOF Then
		Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
		response.End()
	End If
	
	'publish
	city_code = Rs("city_code") 
	lodgeType = Rs("lodgeType")
	leaseType = Rs("leaseType")
	houseTitle = Rs("houseTitle")
	invoice = Rs("invoice")
	address = Rs("address")
	
	'step1
	hid=Rs("hid")
	area = Rs("area")
	guestnum  = Rs("guestnum")
	toiletnum  = Rs("toiletnum")
	roomdesc  = Rs("roomdesc")
	userule  = Rs("userule")
	bedtype  = Rs("bedtype")
	roomsnum  = Rs("roomsnum")
	bednum = Rs("bednum")
	expireDate = Rs("expireDate")
	startDate  = Rs("startDate")
	
	'step2
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
	
	If (Not IsNull(img1) and img1 <> "") Then
		img1 = "../../"&img1
	else
		img1 = VirtualPath & "/images/noimage.gif"
	End If
	If (Not IsNull(img2) and img2 <> "") Then
		img2 = "../../"&img2
	End If
	If (Not IsNull(img3) and img3 <> "") Then
		img3 = "../../"&img3
	End If
	If (Not IsNull(img4) and img4 <> "") Then
		img4 = "../../"&img4
	End If
	If (Not IsNull(img5) and img5 <> "") Then
		img5 = "../../"&img5
	End If
	If (Not IsNull(img6) and img6 <> "") Then
		img6 = "../../"&img6
	End If
	If (Not IsNull(img7) and img7 <> "") Then
		img7 = "../../"&img7
	End If
	If (Not IsNull(img8) and img8 <> "") Then
		img8 = "../../"&img8
	End If
	If (Not IsNull(img9) and img9 <> "") Then
		img9 = "../../"&img9
	End If
	If (Not IsNull(img10) and img10 <> "") Then
		img10 = "../../"&img10
	End If
	
	
	'step3
	facilities = Rs("facilities") 
	facilities = ","&facilities&","
	
	'step4
	checkintime = Rs("checkintime")
	checkouttime = Rs("checkouttime") 
	minday= Rs("minday")
	maxday = Rs("maxday")
	refundday = Rs("refundday")
	paymentRules = Rs("paymentRules")
	dayrentprice = Rs("dayrentprice")
	weekrentprice = Rs("weekrentprice")
	monthrentprice = Rs("monthrentprice")

End Sub

Sub validateSubmit()

End Sub

Sub validateDraft()

End Sub




Sub Main()	
	
	Call ShowEdit()

End Sub

%>
<%
G_Title_Content = "预览"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>
<%If G_Title_Content="" Then
G_Title_Content = Dream3CLS.SiteConfig("SiteName")&"-"&Dream3CLS.SiteConfig("SiteTitle")&"|短租|出租"
End If
Response.Write(G_Title_Content)
%>
</title>
<meta name="keywords" content="<%=Dream3CLS.SiteConfig("MetaKeywords")%>" />
<meta name="description" content="<%=Dream3CLS.SiteConfig("MetaDescription")%>" />
<link href="<%=VirtualPath%>/common/themes/<%=Dream3CLS.SiteConfig("DefaultSiteStyle")%>/css.css" rel="stylesheet" type="text/css" />
<link href="<%=VirtualPath%>/common/themes/<%=Dream3CLS.SiteConfig("DefaultSiteStyle")%>/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=VirtualPath%>/common/js/jquery/jquery-1.4.2.min.js"></script>
</head>
<form class="validator"  action="?act=save" method="post" id="productForm" name="productForm">
<div class="area">
	
    
	
    
    <div class="layer2">
    
       <div class="side-top"></div>
        <div class="side-center">
            <div class="Preview-1">
                <h4 class="title"><span>房间详情</span>
                    <div class="grade_view" id="_View_Detail" style="display:none;"><span class="grade_word">得分：</span><span class="grade_score">49.2分</span></div>
                </h4>
                <div class="roomcon-l">
                    <ul>
						
                        <li><span>所属酒店：</span><%=Dream3Product.GetHotelname(hid)%></li>
						<li><span>房间标题：</span><%=houseTitle%></li>
                        <li><span>面积：</span><%=area%>平米</li>
                        <li><span>可住人数：</span><%=guestnum%>人</li>
                        <li><span>房间数：</span><%=roomsnum%>间</li>
                        <li><span>床数：</span><%=bednum%>张</li>
                        <li><span>床型：</span>双人床（中）</li>
                        <li><span>卫生间数：</span><%=toiletnum%>间</li>
						<li><span>生效日期：</span><%=startDate%></li>
                        <li><span>有效期至：</span><%=expireDate%></li>
                    </ul>
                </div>
                <div class="roomcon-r">
                    <p>房间介绍：<span id="_DataScore_View_RoomIntroduce"><%=roomdesc%></span></p>
                    <p>使用规则：<%=userule%></p>
                </div>
            </div>
            <div class="clear"></div>
        </div>
        <div class="side-bottom"></div>
        
        <div class="side-top"></div>
        <div class="side-center">
            <div class="Preview-1">
                <h4 class="title"><span>上传照片</span>
                    <div class="grade_view" id="_View_Imgs" style="display:none;"><span class="grade_word">得分：</span><span class="grade_score">37.39分</span></div>
                </h4>
                <div style="position: relative; border: 1px solid #ccc; padding:2px; float:left;">
                    <img width="284px" height="211px" id="bigImage" src="<%=img1%>">
                </div>
                <dl class="Preview-pic">
					<%
					If img1 <> "" Then
						
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img1%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img2 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img2%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img3 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img3%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img4 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img4%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img5 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img5%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img6 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img6%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img7 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img7%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img8 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img8%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img9 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img9%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
					<%
					If img10 <> "" Then
					%>
                    <dd>
                        <div class="forImgSrc" style="cursor:pointer;position: relative; border: 1px solid #ccc;">
                            <img width="64" height="64" src="<%=img10%>" style="margin:1px;float:left;">
                        </div>
                    </dd>
                    <%End If%>
            	</dl>
            </div>
            <div class="clear"></div>
        </div>
        <div class="side-bottom"></div>
        
        <div class="side-top"></div>
        <div class="side-center">
           <div class="Preview-1">
           		<h4 class="title"><span>设施服务</span></h4>
                <div class="ser-checkin">
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
            <div class="clear"></div>
        </div>
        <div class="side-bottom"></div>
        
        <div class="side-top"></div>
        <div class="side-center">
           <div class="Preview-1">
                <h4 class="title">
                    <span>入住与价格</span>
                    
                    <div class="grade_view" id="_View_Days" style="display:none;"><span class="grade_word">得分：</span><span class="grade_score">100.00分</span><span class="grade_score">&nbsp;太棒了!</span></div>
                </h4>
                <div class="roomcon-l">
                    <ul>
                        <li><span>入住时间：</span><%=checkintime%></li>
                        <li><span>退房时间:</span><%=checkouttime%></li>
                        <li><span>最少天数：</span><%=minday%></li>
                        <li><span>最多天数：</span>
                        <%If maxday=0 Then%>无限制<%Else%><%=maxday%><%End If%>
                        </li>
                        <li style="display:none "><span>全额退款日：</span><%=refundday%>天</li> 
                        <li>
						<span style="display:none ">付款规则：</span>
						<%
						if paymentRules = "moststrict" Then
							'response.Write("严格")
						Elseif paymentRules = "morestrict" Then
							'response.Write("比较严格")
						Elseif paymentRules = "middle" Then
							'response.Write("中等")
						Elseif paymentRules = "moreloose" Then
							'response.Write("比较宽松")
						Elseif paymentRules = "mostloose" Then
							'response.Write("宽松")
						End If
						%>
						
						</li> 
                    </ul>
                </div>
                <div class="roomcon-r">
                    <p>日租价：<b class="blue"><%=dayrentprice%>元</b>/每晚</p>
                    <p>周末价：
					<%If weekrentprice = 0 Then%>
					未设置
					<%Else%>
					<b class="blue"><%=weekrentprice%></b>元/每周
					<%End If%>
					</p>
                    <p>月租价：
					<%If monthrentprice = 0 Then%>
					未设置
					<%Else%>
					<b class="blue"><%=monthrentprice%>元</b>/每月
					<%End If%>
					
					</p>
            	</div>
            </div>
            <div class="clear"></div>
        </div>
       
        
        <div class="clear"></div>
        <div class="side-bottom"></div>
        
    </div>
    
  
    
</div>
<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
</form>
<!--#include file="../../common/inc/footer_user.asp"-->