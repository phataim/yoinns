<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../../common/api/cls_email.asp"-->
<%
Dim Action
Dim Rs,Sql
Dim team_id
Dim title, start_time,end_time,teamState,min_number,max_number,team_price,market_price
Dim pre_number,totalQuantity,actualOrderCount,actualQuantity,mailCount,smsCount,allSmsCount
Dim smsSendType

	Action = Request("act")
	Select Case Action	
		Case "sendMail"
			Call Send_Email()
		Case "sendSMS"
			Call Send_SMS()
		Case Else
			Call Main()
	End Select
	
	Sub Send_Email()

		Dim team_id
		Dim useremail, topic, mailbody, i
		Dim mailArr
		Dim SMSArray
		
		team_id = Dream3CLS.ChkNumeric(Request("id"))
		Sql = "Select * from T_Team Where id="&team_id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			Response.End()
		End If
		
		title = Rs("title")
		start_time = Rs("start_time")
		image = Rs("image")
		end_time = Rs("end_time")
		teamState = Rs("state")
		min_number = Rs("min_number")
		max_number = Rs("max_number")
		team_price = Rs("team_price")
		market_price = Rs("market_price")
		pre_number = Rs("pre_number")
		city_id = Rs("city_id")
		summary = Rs("summary")
		partner_id = Rs("partner_id")
		discount = Dream3CLS.FormatNumbersNil(Formatnumber((cdbl(team_price) / cdbl(market_price))*10,2,-1))
		reduce = cdbl(market_price)-cdbl(team_price)
		
		'得到商家信息
		Sql = "Select [title],[location],[address] From T_Partner Where id="&partner_id
		Set pRs = Dream3CLS.Exec(Sql)
		partner_title = pRs("title")
		partner_location = pRs("location")
		pRs.Close
		Set pRs = Nothing
		
		topic = title
		topic = Dream3CLS.GetMailTitle(topic)
		
		mailbody = Dream3Tpl.LoadTemplate("mail_team_content")
		mailbody = Replace(mailbody, "{$SiteShortName}", SiteConfig("SiteShortName"))
		mailbody = Replace(mailbody, "{$TeamTitle}", title)
		mailbody = Replace(mailbody, "{$Now}", Dream3CLS.Formatdate(Now(),5))
		mailbody = Replace(mailbody, "{$CityName}", Dream3Team.getCityName(city_id,"全部"))
		mailbody = Replace(mailbody, "{$TeamPrice}", team_price)
		mailbody = Replace(mailbody, "{$CNYSymbol}", SiteConfig("CNYSymbol"))
		mailbody = Replace(mailbody, "{$TeamMarketPrice}", market_price)
		mailbody = Replace(mailbody, "{$SiteUrl}", GetSiteUrl())
		mailbody = Replace(mailbody, "{$TeamID}", team_id)
		mailbody = Replace(mailbody, "{$TeamDiscount}", discount)
		mailbody = Replace(mailbody, "{$TeamReduce}", Reduce)
		mailbody = Replace(mailbody, "{$TeamImage}", GetSiteUrl&"/"&Dream3Team.FilterImage(image))
		mailbody = Replace(mailbody, "{$TeamSummary}", summary)
		mailbody = Replace(mailbody, "{$PartnerTitle}", partner_title)
		mailbody = Replace(mailbody, "{$PartnerLocation}", partner_location)
		mailbody = Replace(mailbody, "{$ServiceEmail}", SiteConfig("ServiceEmail"))
		mailbody = Replace(mailbody, "{$ServicePhone}", SiteConfig("ServicePhone"))
		mailbody = Replace(mailbody, "{$ServiceTime}", SiteConfig("ServiceTime"))
		mailbody = Replace(mailbody, "{$DefaultSiteStyle}", SiteConfig("DefaultSiteStyle"))
		
		't(mailbody)

		
		Rs.Close
		
		If cmEmail.ErrCode <> 0 Then
			gMsgArr = "由于系统错误，邮件发送失败！"
			gMsgFlag = "E"
			Call Main()
			Exit Sub
		End If

		mailArr = Dream3Team.GetMailList(city_id)
		
		If IsArray(mailArr) then
			For i=0 to UBound(mailArr,2)
				useremail = mailArr(0,i)
				cmEmail.SendMail useremail,topic,mailbody
				If cmEmail.Count>0 Then
					'发送成功
				Else
					gMsgArr = gMsgArr&"|"&useremail&"邮件发送失败！"
					gMsgFlag = "E"
				End If
			Next
		End if
	
		If gMsgFlag <> "E" Then
			gMsgArr = "所有邮件发送成功！"
			gMsgFlag = "S"
		End If
		
		Call Main()
	
	End Sub
	
	
	
	Sub Main()	
		team_id = Dream3CLS.ChkNumeric(Request("id"))
		Sql = "Select * From T_Team Where id="&team_id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			Response.End()
		End If
		
		title = Rs("title")
		start_time = Rs("start_time")
		end_time = Rs("end_time")
		teamState = Rs("state")
		min_number = Rs("min_number")
		max_number = Rs("max_number")
		team_price = Rs("team_price")
		market_price = Rs("market_price")
		pre_number = Rs("pre_number")
		city_id = Rs("city_id")
		
		Sql = "Select sum(quantity) From T_Order Where state = 'pay' and team_id="&team_id
		Set cRs = Dream3CLS.Exec(Sql)
		actualQuantity = cRs(0)
		If not isnumeric(Trim(actualQuantity)) then actualQuantity=0
		totalQuantity = actualQuantity + pre_number
		
		Sql = "Select Count(id) From T_Order Where state = 'pay' and team_id="&team_id
		Set cRs = Dream3CLS.Exec(Sql)
		actualOrderCount = cRs(0)
		
		'Get Mail User
		mailArr = Dream3Team.GetMailList(city_id)
		SMSArray = Dream3Team.GetSMSList(city_id)
		AllSMSArray = Dream3Team.GetAllSMSList()
		
		If IsArray(mailArr) Then
			mailCount = UBound(mailArr,2) + 1
		Else
			mailCount = 0
		End If
		
		If IsArray(SMSArray) Then
			smsCount = UBound(SMSArray,2) + 1
		Else
			smsCount = 0
		End If
		
		If IsArray(AllSMSArray) Then
			allSmsCount = UBound(AllSMSArray,2) + 1
		Else
			allSmsCount = 0
		End If
		
		
	End Sub
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="../../common/js/tools.js"></script>
<script type="text/javascript" src="<%=VirtualPath%>/common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript">
function SendSms(sendtype,team_id) {
	if(sendtype == "all"){
		$("#smsallbutton").attr('disabled','false'); 
		$("#smsallbutton").attr('value','正在发送，请稍后......'); 
	}else{
		$("#smsbutton").attr('disabled','false'); 
		$("#smsbutton").attr('value','正在发送，请稍后......'); 
	}
	$.ajax({type:"POST", url:"<%=VirtualPath%>/ajax/getSendSMSSubsResult.asp?teamid="+team_id+"&sendtype="+sendtype,  success:function (data) {
 	if(data == "success"){
		alert("全部发送成功");
	}else{
 		alert(data);
	}
 }});
	
	if(sendtype == "all"){
		$("#smsallbutton").attr('disabled','true'); 
		$("#smsallbutton").attr('value','已发送完毕');
	}else{
		$("#smsbutton").attr('disabled','true'); 
		$("#smsbutton").attr('value','已发送完毕');
	}
}
</script>
<div id="box">
<div class="clear mainwide" id="content">
        <div class="clear box">
            
            <div class="box-content">
                <div class="head">				
					<h2>项目详情</h2>
				</div> 
					
				<div class="sect">
				<table align="center" width="96%" class="coupons-table">
					<tbody>
					<tr><td width="80"><b>项目名称：</b></td><td><%=title%></td></tr>
					<tr><td width="80"><b>项目时间：</b></td><td>开始：<%=start_time%>      截至：<%=end_time%></td></tr>
					<tr>
					<td width="80"><b>当前状态：</b></td>
					<td>
						<%If teamState = "success" Then%>
							团购成功
						<%Elseif teamState = "failed" then%>
							团购失败
						<%Elseif teamState = "normal" then%>
							正常团购
						<%Elseif teamState = "draft" then%>
							处于草稿阶段
						<%Else%>
							未定义
						<%End if%>
					</td>
					</tr>
					<tr>
					<td width="80"><b>限购数量：</b></td>
					<td>最低<%=min_price%>  最高：<%If max_number=0 then%>无上限<%Else%>max_number<%End If%></td>
					</tr>
					
					<tr>
					<td width="80"><b>项目定价：</b></td>
					<td>
					市场价格：<%=market_price%> 元      项目价格：<%=team_price%> 元
					</td>
					</tr>
					
					<tr><td width="80"><b>成交情况：</b></td>
					<td><%=totalQuantity%> ，实际共 <%=actualOrderCount%> 人购买了 <%=actualQuantity%> 份</td>
					</tr>
					<tr ><td width="80"><b>发送邮件：</b></td>
					<td>
					<form method="post" action="teamDetail.asp?act=sendMail">
						<input type="hidden" name="id" value="<%=team_id%>" />
						<input type="submit" name="submit_button" value="发送邮件(共<%=mailCount%>个用户)" class="button">
					</form>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<form method="post" action="teamDetail.asp?act=sendSMS">
						<input type="hidden" name="id" value="<%=team_id%>" />
						<input id="smsbutton" type="submit" name="submit_button" value="给订阅人发送短信(共<%=smsCount%>个用户)" class="button" onclick="SendSms('subs','<%=team_id%>')">
					</form>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<form method="post" action="teamDetail.asp?act=sendSMS">
						<input type="hidden" name="id" value="<%=team_id%>" />
						<input type="hidden" name="smsSendType" value="all" />
						<input id="smsallbutton" type="submit" name="submit_all_button" value="给所有手机号发送短信(共<%=allSmsCount%>个用户)" class="button" onclick="SendSms('all','<%=team_id%>')">
					</form>
					</td>
					</tr>
					</tbody>
				</table>
				</div>
				
            </div>
            
        </div>
	</div>
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->