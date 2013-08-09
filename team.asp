<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/inc/share_common.asp"-->
<%
Dim Action
Dim Sql,i
Dim Rs
Dim teamIdArr(),userIdArr()
Dim team_id
Dim teamState, isTeamOK, isKeepBuying
Dim city_id,city_name
Dim cityMap

Dim title,market_price,team_price,discount,pre_number,image,image1,image2,min_number,summary,end_time,timeCountStr,max_number
Dim actualCount,totalCount,reduce,detail,userreview,systemreview
Dim partner_id , partner_title,partner_location,conduser
Dim reach_time,notice
Dim userreviewArr

Dim content


	Action = Request.QueryString("act")
	Select Case Action
		Case "saveMsg"
			Call SaveMsg()
		Case Else
			Call Main()
	End Select
	
	Sub SaveMsg()
		team_id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		content = Dream3CLS.RParam("content")
		
		If IsNull(Session("_UserID")) Or Session("_UserID") = "" Then
			Call Dream3CLS.MsgBox2("请先登录后再发表！",0,"0")
			Response.End()
		End If

		If content = "" Then
			Call Main()
			Exit Sub
		End If
		
		If Len(Content) > 500 Then
			gMsgArr = gMsgArr&"|留言内容请不要超过500！"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		Sql = "Select id,partner_id From T_Team Where id="&team_id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			Response.End()
		End If
		
		m_partner_id = Rs("partner_id")
		
		Rs.Close
		
		Sql = "Select * From T_Ask Where team_id="&team_id

		Rs.open Sql,conn,1,2
		Rs.AddNew
		Rs("user_id") = Session("_UserID")
		Rs("username") = Session("_UserName")
		Rs("team_id") = team_id
		Rs("partner_id") = m_partner_id
		Rs("content") = Dream3CLS.HTMLEncode(content)
		Rs("create_time") = Now()
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		Dream3CLS.showMsg "您的留言已经提交，待回复！","S","team.asp?id="&team_id
	End Sub

	
	Sub Main()	
		'得到城市的ID，如果找不到，则默认为全部
		team_id = Dream3CLS.ChkNumeric(Request.QueryString("id"))
		
		Set cityMap = new AspMap
		Call Dream3Team.getCategoryMap("city",cityMap)
		
		Sql = "Select id,start_time,title,city_id,market_price,team_price,image,image1,image2,pre_number,min_number,seqno,summary,end_time,detail ,userreview,systemreview,partner_id,conduser,max_number,reach_time,[notice] from T_Team Where id="&team_id
		
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			'Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			Dream3CLS.showMsg "您要查询的团购信息不存在！","S","error.asp"
			Response.End()
		End If
		
		'如果团购还未开始，则显示未找到团购
		If DateDiff("s",Now(),Rs("start_time")) > 0 Then
			'Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			Dream3CLS.showMsg "您要查询的团购信息不存在！","S","error.asp"
			Response.End()
		End If
		
		title = Rs("title")
		market_price = Dream3CLS.FormatNumbersNil(Rs("market_price"))
		team_price = Dream3CLS.FormatNumbersNil(Rs("team_price"))
		discount = Dream3CLS.FormatNumbersNil(Formatnumber((cdbl(team_price) / cdbl(market_price))*10,2,-1))
		pre_number = Rs("pre_number")
		image = Rs("image")
		image1 = Rs("image1")
		image2 = Rs("image2")
		If IsNull(image1) Or image1="" Then
			image1 = ""
		End If 
		If IsNull(image2) Or image2="" Then
			image2 = ""
		End If 
		min_number = Rs("min_number")
		max_number = Rs("max_number")
		summary = Rs("summary")
		city_id = Rs("city_id")
		conduser = Rs("conduser")
		start_time = Rs("start_time")
		end_time = Rs("end_time")
		reach_time = Rs("reach_time")
		detail = Rs("detail")
		detail = Dream3Team.FilterContentImage(detail)
		userreview  = Rs("userreview")
		systemreview  = Rs("systemreview")
		notice = Rs("notice")
		notice = Dream3Team.FilterContentImage(notice)
		partner_id = Rs("partner_id")
		intSec = DateDiff("s",Now(),end_time)
		timeCountStr = id&","&intSec
		 
		'切分userreview
		If  IsNull(userreview)  Then userreview = ""
		If Len(userreview) > 0 Then
			userreviewArr = Split(userreview,"|")
		End If
		
		Sql = "Select Count(id) From T_Order Where state = 'pay' and team_id="&Rs("id")
		Set oRs = Dream3CLS.Exec(Sql)
		actualCount = oRs(0)
		totalCount = (actualCount + pre_number)
		
		
		Sql = "Select Sum(quantity) From T_Order Where state = 'pay' and team_id="&Rs("id")
		Set oRs = Dream3CLS.Exec(Sql)
		actualQuantity = oRs(0)
		If not isnumeric(Trim(actualQuantity)) then actualQuantity=0
		totalQuantity = actualQuantity + pre_number
		
		'折扣应该按照产品的数量来计算，而不是按照人数来
		reduce = totalQuantity * (cdbl(market_price)-cdbl(team_price))
		
		'判断团购状态,如果已结束，则直接标明已结束,未开始
		If DateDiff("s",end_time,now()) > 0 Then
			teamState = "terminal"
		ElseIf DateDiff("s",start_time,now()) < 0 Then
			teamState = "unstart"
		Else
			'团购正在进行,分为已卖光，未达到标准正在进行的，已达到数量还可以进行的，已达到数量不能进行的
			'达到标准的定义有两种，1人数已达到，2，数量已达到
			teamState = "keepon"
			'购买成功人数
		End If

		'如果按购买人数,但是keepbuying仍然是按照数量来进行计算
		If conduser = "Y" Then
			If totalCount >= min_number Then
				isTeamOK = true
			Else
				isTeamOK = false
			End If
		Else
			'购买成功数量
			
			If totalQuantity >= min_number Then
				isTeamOK = true
			Else
				isTeamOK = false
			End If

		End If
		
		If max_number = 0 Or totalQuantity < max_number Then
			isKeepBuying = true
		Else
			isKeepBuying = false
		End If
		
		
		
		'得到商家信息
		Sql = "Select [title],[location],[address] From T_Partner Where id="&partner_id
		Set pRs = Dream3CLS.Exec(Sql)
		partner_title = pRs("title")
		partner_location = pRs("location")

		
	End Sub
%>
<%
G_Title_Content = title&"|"&SiteConfig("SiteName")&"-"&SiteConfig("SiteTitle")&"|"&G_City_NAME&"购物"&"|"&G_City_NAME&"团购"&"|"&G_City_NAME&"打折"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="common/js/jquery/jquery-1.4.2.min.js"></script>  
<script type="text/javascript" src="common/js/yu.js"></script> 
<script type="text/javascript" src="common/js/tb.js"></script>
<%
If Not isKeepBuying then
%>
<!--#include file="common/inc/team_soldout_tip.asp"-->
<%
End If
%>

<div id="box">	
	<div class="cf">
			
		<div class="index_page">
			<div class="mainbar">
				<div class="index_page-top"></div>
				
				<div class="index_page-content">
					
					<div class="index_tuan_share">
						<div class="left">NO.<span class="theno">1</span></div>
						<div class="con">
							<p>分享本团到：</p>
							<%
							 GetShare team_id,title,title
							%>
						</div>
					</div>
					
					<div class="index_tuan_tit">
						<h3><strong><%=cityMap.getv(CStr(city_id))%><%If teamState<>"terminal" Then%>今日<%End If%>团购:</strong>
							<span class="c_tx4"><%=title%></span>
						</h3>
					</div>
					
					<div class="index_tuan_attr">
						<p class="original_price">原价：<del><%=SiteConfig("CNYSymbol")%><%=market_price%></del>&nbsp;&nbsp;折扣：<span class="zk"><%=discount%></span> 折</p>
						<div class="buy_info">
							<span class="l price_all"><span class="txt_price"><%=SiteConfig("CNYSymbol")%></span><span class="num_price"><%=team_price%></span></span>
							<!--keep on-->
							<%
							If teamState="keepon" Then
								If isKeepBuying Then
							%>
								<a href="buy.asp?id=<%=team_id%>">
								<div class="r info_buy"></div>
								</a>
							<%
								Else
							%>
								<div class="r info_soldout"></div>
							<%
								End If
							End If
							%>
							
							<%If teamState="unstart" Then%>
							<div class="r info_buy"></div>
							<%End If%>
							<!--Teminate-->
							<%If teamState="terminal" Then%>
							<div class="r info_error"></div>
							<%End If%>
						</div>
						<div class="tuan_countdown">					
						<h4>剩余时间：</h4>
						<%
						If teamState = "terminal" Then
						%>
						<p id="v:timeCounter"><span class="item"><span class="hour_num">0</span>天</span><span class="item"><span class="hour_num">0</span>小时</span><span class="item"><span class="minute_num">0</span>分</span><span class="item"><span class="second_num">0</span>秒</span></p>
						<%Else%>
						<p id="remainTime_<%=id%>">
						<%End If%>
					  </div>
					  
					  <%
						If teamState = "terminal" Then
					   %>
					   <div class="tuan_result">
							<p class="has_tuan_people"><span><%=totalCount%></span>人已购买</p>
						</div>
						<div class="tipometer">
							<%If isTeamOK Then%>
							<img src="<%=VirtualPath%>/common/themes/<%=SiteConfig("DefaultSiteStyle")%>/css/img/img_mgl.png">
							<%Else%>
							<img src="<%=VirtualPath%>/common/themes/<%=SiteConfig("DefaultSiteStyle")%>/css/img/img_sb.png">
							<%End If%>
						</div>
					   <%
					   Else
					   %>
						<div class="tuan_result">
							<p class="has_tuan_people"><span><%=totalCount%></span>人已购买</p>
							<p class="Gray">数量有限，再不抢就来不及啦！</P>
						</div>
						<%If isTeamOK Then%>
							<div class="tuan_done">
								<img align="absmiddle" width="46" height="46" src="<%=VirtualPath%>/common/themes/<%=SiteConfig("DefaultSiteStyle")%>/Css/img/done.png"> 团购成功
							</div>
							<div class="Low Gray">
								<p class="Red">团购成功<%If isKeepBuying Then%>可继续购买<%End If%></P>
								<%If isTeamOK Then%>
								<p>
								<%=Dream3CLS.Formatdate(reach_time,6)%>
								<%If conduser="Y" Then%>
								达到最低团购人数：<%=min_number%>人
								<%Else%>
								达到最低团购数量：<%=min_number%>件
								<%End If%>
								</P>
								<%End If%>
							</div>
						<%End If%>
						<%
						End If
						%>
					</div>
					<%
					If image1 = "" and image2 = "" Then
					%>
					<div class="index_tuan_photo">
					<img src="<%=Dream3Team.FilterImage(image)%>" width="488" height="350" border="0">
					</div>
					<%
					Else
					%>
					<div class="index_tuan_photo">
					<div id="MainPromotionBanner">
						<div id="SlidePlayer">
							<ul class="Slides">
								<li><img src="<%=Dream3Team.FilterImage(image)%>"></li>
								<%If image1<>"" Then%>
								<li><img src="<%=Dream3Team.FilterImage(image1)%>"></li>
								<%End If%>
								<%If image2<>"" Then%>
								<li><img src="<%=Dream3Team.FilterImage(image2)%>"></li>
								<%End If%>
							</ul>
						</div>
						<script type="text/javascript">
									TB.widget.SimpleSlide.decoration('SlidePlayer', {eventType:'mouse', effect:'scroll'});
						</script>
					</div>
					</div>
					<%End If%>
					
					
					<div class="say"><%=summary%></div>
					
				</div>
				
				<div class="index_page-bottom"></div>
		
				<div class="blank10"></div>	
				
				<div class="show">
					<div class="inner">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="show_detail"> 
						  <tr>
							<td valign="top">
								<div class="show_intro">
									<div class="con">
										<h4 class="Orange">本单详情</h4>
										<p>
											<font style="padding: 0px 28px;"><%=detail%></font>
										</p>
									</div>
								</div>
							</td>
							<td valign="top" class="bus_show">
								<div class="info_shop">
									<h4 class="Orange"><%=partner_title%></h4>
									<p>
										<%=partner_location%>									
									</p>
								</div>
							</td>
						  </tr>
						</table>
						
						<div class="show_tuan_pl">
							<div class="item">
								<h4 class="Orange">特别提示</h4>
								<div class="con">
								<p><%=notice%></p>
								</div>
							</div>
							
							<div class="item">
								<h4 class="Orange">大家说商家</h4>
								<div class="con">
								<p>
								<%
								If IsArray(userreviewArr) Then
									For i = 0 To UBound(userreviewArr)
										Response.Write(userreviewArr(i)&"<BR>")
									Next
								End If
								%>
								</p>
								</div>
							</div>
							
							<div class="item">
								<h4 class="Orange">我们说商家</h4>
								<div class="con">
								<p><%=systemreview%></p>
								</div>
							</div>
							
							<div class="item">
								<h4 class="Orange">留言讨论区</h4>
								<div class="consult-list">
									<ul class="list">
									<%
										i = 0
										Sql = "Select Top 5 * From T_Ask Where  team_id ="&team_id
										Sql = Sql &" Order By Create_time Desc" 
										Set Rs = Dream3CLS.Exec(Sql)
										Do While Not Rs.EOF
									%>
										<li <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
											<div class="pinl">
											<p class="user"><strong><%=Rs("username")%></strong><span><%=Rs("create_time")%></span></p>
											<div class="clear"></div>
											<p class="text"><%=Rs("content")%></p>
											<%If Rs("comment") <> "" Then%>
											<p class="reply"><strong>管理员回复：</strong><%=Rs("comment")%></p>
											<%End If%>
											<%If Rs("p_comment") <> "" Then%>
											<p class="reply"><strong>商家回复：</strong><%=Rs("p_comment")%></p>
											<%End If%>
											</div>
										</li>
										<%
											i = i + 1
											Rs.MoveNext
										Loop
										%>
										
									</ul>						
								</div>
							</div>
							
							<div class="item">
								<h4 class="Orange">我也来说两句</h4>
								<div class="con1">
								<form name="msgForm" method="post" action="team.asp?act=saveMsg&id=<%=team_id%>"/>							<p><textarea id="consult-content" name="content" rows="5" cols="60" class="f-textarea"></textarea></p><br>
									<p>
									<input type="submit" class="formbutton" name="commit" value="好了，提交" <%If Session("_UserID")="" Then%>disabled="disabled"<%End If%>  >
									</p>
									</form>
								</div>
							</div>
							
						</div>
						
					</div>
				</div>
				
			</div>
		</div>
		
<div id="sidebar">
			
			<div class="sbox">
				<div class="sbox-top"></div>
				<div class="sbox-content">
					<div class="credit">
						<h2>站内公告</h2>
						<p><%=Dream3Team.getBulletin(0)%></p>
					</div>
				</div>
				<div class="sbox-bottom"></div>
			</div>
			
			<div class="blank10"></div>
			
			<%
			'如果是城市，则显示城市公告
			If CStr(G_City_ID) <> "0" Then
			%>
			<div class="sbox">
				<div class="sbox-top"></div>
				<div class="sbox-content">
					<div class="credit">
						<h2><%=G_City_NAME%>站内公告</h2>
						<p><%=Dream3Team.getBulletin(G_City_ID)%></p>
					</div>
				</div>
				<div class="sbox-bottom"></div>
			</div>
			
			<div class="blank10"></div>
			
			<%End If%>
			
			<!--#include file="common/inc/service_common.asp"-->
			
			<div class="blank10"></div>
			
			<!--#include file="common/inc/supply_right.asp"-->
			
			<div class="blank10"></div>
			
			<!--Dream3BizStart侧团-->
			<!--#include file="common/inc/side_team.asp"-->
			<!--Dream3BizEnd-->
			
			<!--#include file="common/inc/mail_right.asp"-->
		
	</div>	
</div>
<div id="remainSeconds" style="display:none"><%=timeCountStr%></div> 
<script type="text/javascript" src="common/js/timeCountDown.js">   
</script> 
<!--#include file="common/inc/footer_user.asp"-->