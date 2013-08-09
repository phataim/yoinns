<!--#include file="../conn.asp"-->
<!--#include file="../common/inc/permission_manage.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_tpl.asp"-->
<!--#include file="../common/api/cls_product.asp"-->
<!--#include file="../common/api/cls_coupon.asp"-->
<!--#include file="../common/api/cls_sms.asp"-->
<!--#include file="../common/api/cls_xml.asp"-->
<%
On error resume next
Dim url,result,team_id,rs,mobile,content,smsmsg,smsflag,sendtype
team_id = Dream3CLS.ChkNumeric(Request("teamid"))
sendtype = Dream3CLS.RParam("sendtype")
content = GetSMSSubsContent(team_id)
Set teamRs = Dream3Team.GetTeamById(team_id)
city_id = teamRs("city_id")
If sendtype = "all" Then
	SMSArray = Dream3Team.GetAllSMSList()
Else
	SMSArray = Dream3Team.GetSMSList(city_id)
End If

If IsArray(SMSArray) then
	For i=0 to UBound(SMSArray,2)
		mobile = SMSArray(0,i)
		result = Dream3SMS.SendSMS(mobile,content)
		
		If result <> "success" Then
			smsflag = smsflag&result
			If smsmsg = "" Then
				smsmsg = smsmsg & mobile
			Else
				smsmsg = smsmsg &"," & mobile
			End If
		End If
	Next
Else
	response.Write("没有可发送的短信对象！")
	response.End()
End if
	
If smsmsg <> "" Then
	response.Write(smsmsg&"这些号码发送失败！")
Else
	response.Write("success")
End If

Function GetSMSSubsContent(f_team_id)

	Dim team_id
	Dim useremail, topic, mailbody, i
	Dim mailArr
	Dim SMSArray
	
	Sql = "Select * from T_Team Where id="&f_team_id
	Set Rs = Dream3CLS.Exec(Sql)

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
	smsbody = Dream3Tpl.LoadTemplate("sms_team_subs_content")
	smsbody = Replace(smsbody, "{$SiteName}", SiteConfig("SiteName"))
	smsbody = Replace(smsbody, "{$SiteShortName}", SiteConfig("SiteShortName"))
	smsbody = Replace(smsbody, "{$TeamTitle}", title)
	smsbody = Replace(smsbody, "{$Now}", Dream3CLS.Formatdate(Now(),5))
	smsbody = Replace(smsbody, "{$CityName}", Dream3Team.getCityName(city_id,"全部"))
	smsbody = Replace(smsbody, "{$TeamPrice}", team_price)
	smsbody = Replace(smsbody, "{$CNYSymbol}", SiteConfig("CNYSymbol"))
	smsbody = Replace(smsbody, "{$TeamMarketPrice}", market_price)
	smsbody = Replace(smsbody, "{$SiteUrl}", GetSiteUrl())
	smsbody = Replace(smsbody, "{$TeamID}", team_id)
	smsbody = Replace(smsbody, "{$TeamDiscount}", discount)
	smsbody = Replace(smsbody, "{$TeamReduce}", Reduce)
	smsbody = Replace(smsbody, "{$TeamSummary}", summary)
	smsbody = Replace(smsbody, "{$PartnerTitle}", partner_title)
	smsbody = Replace(smsbody, "{$PartnerLocation}", partner_location)
	smsbody = Replace(smsbody, "{$ServiceEmail}", SiteConfig("ServiceEmail"))
	smsbody = Replace(smsbody, "{$ServicePhone}", SiteConfig("ServicePhone"))
	smsbody = Replace(smsbody, "{$ServiceTime}", SiteConfig("ServiceTime"))
	
	't(smsbody)
	Rs.Close
	GetSMSSubsContent = smsbody
End Function
%>
