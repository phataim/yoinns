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
			Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
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
		
		'�õ��̼���Ϣ
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
		mailbody = Replace(mailbody, "{$CityName}", Dream3Team.getCityName(city_id,"ȫ��"))
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
			gMsgArr = "����ϵͳ�����ʼ�����ʧ�ܣ�"
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
					'���ͳɹ�
				Else
					gMsgArr = gMsgArr&"|"&useremail&"�ʼ�����ʧ�ܣ�"
					gMsgFlag = "E"
				End If
			Next
		End if
	
		If gMsgFlag <> "E" Then
			gMsgArr = "�����ʼ����ͳɹ���"
			gMsgFlag = "S"
		End If
		
		Call Main()
	
	End Sub
	
	
	
	Sub Main()	
		team_id = Dream3CLS.ChkNumeric(Request("id"))
		Sql = "Select * From T_Team Where id="&team_id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
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
		$("#smsallbutton").attr('value','���ڷ��ͣ����Ժ�......'); 
	}else{
		$("#smsbutton").attr('disabled','false'); 
		$("#smsbutton").attr('value','���ڷ��ͣ����Ժ�......'); 
	}
	$.ajax({type:"POST", url:"<%=VirtualPath%>/ajax/getSendSMSSubsResult.asp?teamid="+team_id+"&sendtype="+sendtype,  success:function (data) {
 	if(data == "success"){
		alert("ȫ�����ͳɹ�");
	}else{
 		alert(data);
	}
 }});
	
	if(sendtype == "all"){
		$("#smsallbutton").attr('disabled','true'); 
		$("#smsallbutton").attr('value','�ѷ������');
	}else{
		$("#smsbutton").attr('disabled','true'); 
		$("#smsbutton").attr('value','�ѷ������');
	}
}
</script>
<div id="box">
<div class="clear mainwide" id="content">
        <div class="clear box">
            
            <div class="box-content">
                <div class="head">				
					<h2>��Ŀ����</h2>
				</div> 
					
				<div class="sect">
				<table align="center" width="96%" class="coupons-table">
					<tbody>
					<tr><td width="80"><b>��Ŀ���ƣ�</b></td><td><%=title%></td></tr>
					<tr><td width="80"><b>��Ŀʱ�䣺</b></td><td>��ʼ��<%=start_time%>      ������<%=end_time%></td></tr>
					<tr>
					<td width="80"><b>��ǰ״̬��</b></td>
					<td>
						<%If teamState = "success" Then%>
							�Ź��ɹ�
						<%Elseif teamState = "failed" then%>
							�Ź�ʧ��
						<%Elseif teamState = "normal" then%>
							�����Ź�
						<%Elseif teamState = "draft" then%>
							���ڲݸ�׶�
						<%Else%>
							δ����
						<%End if%>
					</td>
					</tr>
					<tr>
					<td width="80"><b>�޹�������</b></td>
					<td>���<%=min_price%>  ��ߣ�<%If max_number=0 then%>������<%Else%>max_number<%End If%></td>
					</tr>
					
					<tr>
					<td width="80"><b>��Ŀ���ۣ�</b></td>
					<td>
					�г��۸�<%=market_price%> Ԫ      ��Ŀ�۸�<%=team_price%> Ԫ
					</td>
					</tr>
					
					<tr><td width="80"><b>�ɽ������</b></td>
					<td><%=totalQuantity%> ��ʵ�ʹ� <%=actualOrderCount%> �˹����� <%=actualQuantity%> ��</td>
					</tr>
					<tr ><td width="80"><b>�����ʼ���</b></td>
					<td>
					<form method="post" action="teamDetail.asp?act=sendMail">
						<input type="hidden" name="id" value="<%=team_id%>" />
						<input type="submit" name="submit_button" value="�����ʼ�(��<%=mailCount%>���û�)" class="button">
					</form>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<form method="post" action="teamDetail.asp?act=sendSMS">
						<input type="hidden" name="id" value="<%=team_id%>" />
						<input id="smsbutton" type="submit" name="submit_button" value="�������˷��Ͷ���(��<%=smsCount%>���û�)" class="button" onclick="SendSms('subs','<%=team_id%>')">
					</form>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<form method="post" action="teamDetail.asp?act=sendSMS">
						<input type="hidden" name="id" value="<%=team_id%>" />
						<input type="hidden" name="smsSendType" value="all" />
						<input id="smsallbutton" type="submit" name="submit_all_button" value="�������ֻ��ŷ��Ͷ���(��<%=allSmsCount%>���û�)" class="button" onclick="SendSms('all','<%=team_id%>')">
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