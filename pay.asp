<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_user.asp"-->
<!--#include file="onlinepay/onlinepaycode.asp"-->
<!--#include file="onlinepay/md5.inc"-->
<!--#include file="onlinepay/alipay/alipay_md5.asp"-->
<!--#include file="onlinepay/chinabank/md5.asp"-->
<!--#include file="onlinepay/tenpay/md5.asp"-->
<!--#include file="onlinepay/tenpay/tenpay_util.asp"-->
<!--#include file="onlinepay/tenpay/PayRequestHandler.asp"-->
<!--#include file="onlinepay/tenpay/PayResponseHandler.asp"-->
<!--#include file="common/api/cls_tpl.asp"-->
<!--#include file="common/api/cls_sms.asp"-->
<!--#include file="common/api/cls_xml.asp"-->
<%
Function GetAjaxSubmitButton(s_paytype)
	GetAjaxSubmitButton = "<input alt=""ajax/pay_confirm_page.asp?paytype="&paytype&"&order_id="&order_id&"&height=150&width=240"" type=""submit"" id=""order_onlinepay_button"" class=""thickbox"" title=""�밴��ʾ��ɲ���"" value=""ǰ��"&s_paytype&"֧��"" onclick=""this.form.submit();"" />"
End Function

%>
<%
On Error Resume Next
Dim Action
Dim Rs,Sql
Dim product_id,totalMoney,order_id,service, paymoney
Dim PayResult ,PayErrorMsg
Dim houseTitle,userCredit
Dim IsCreditEnough
Dim orderCredit
Dim paytype
Dim olp_order_no,olp_quantity,olp_money,olp_product_id,olp_remark,olp_product_name

userCredit = Dream3User.getUserMoney(session("_UserID"))

	Action = Request.Form("act")
	Select Case Action
		Case "pay"
			Call Pay()
		Case Else
			Call Main()
	End Select
	
	Sub Main()
		
		order_id = Dream3CLS.ChkNumeric(Request("order_id"))
		paytype = Dream3CLS.RSQL("paytype")
		paytip = Dream3CLS.RParam("paytip")
				
		Sql = "Select * From T_Order Where id="&order_id&" and user_id="&Session("_UserID")
		
		Rs.open Sql,conn,1,2
			
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
			Response.End()
		End If
			'================ ��¼����Ϣ mike
			session("order_id")=order_id 
			session("order_no")=rs("order_no") 
			session("user_id")=rs("user_id")
			session("owner_id")=rs("owner_id")
			session("user_mobile")=rs("mobile") 'user_mobile
			
			Set tRs = Server.CreateObject("adodb.recordset")			
			Sql = "Select * From T_User Where id = "&session("owner_id")&""
			tRs.open Sql,conn,1,1
				session("owner_mobile")=tRs("mobile") 'owner_mobile �̼��ֻ���
			tRs.Close
			Set tRs = Nothing
			'================ ��¼����Ϣ mike

		
		product_id = Rs("product_id")
		Set productRs = Server.CreateObject("adodb.recordset")			
		Sql = "Select * From T_Product Where id="&product_id
		productRs.Open Sql,Conn,1,1
		houseTitle = productRs("housetitle")
		olp_product_name = productRs("housetitle")
		productRs.Close
		Set productRs = Nothing
		
		'����õ��Ѹ����ֱ����ת���ɹ�
		If Rs("state") = "pay" Then
			already_pay=1 '�����ת mike
			PayResult = "success"
			Exit Sub
		End If
		
		'��ʾδ������ʾ
		If paytip <> "" Then
			gMsgArr = "�˶�����δ��ɸ�������¸���,�������ѡ��Ľ��׷�ʽ�ѿۿ�ɹ�������������ϵ��֤��"
			gMsgFlag = "E"
		End If
		
		product_id = Rs("product_id")
		
		
		totalMoney = Rs("totalmoney")
		paymoney = CDBL(Rs("reserve"))
	
		
		olp_order_no = Rs("order_no")
		olp_product_id = product_id
		olp_remark = ""
		If IsNull(olp_order_no) or olp_order_no = ""  Then
			olp_order_no = Cstr(order_id)
		End If
		
		olp_quantity = checkindays
		
		'��Ϊ�Ǵ�check�����ģ�����Ҫ����֧���ֶ�
		
		'Ӧ���ܶ��㷨Ϊ������˻��㹻����ֱ����ʾ�˻�������˻�����������ʾ�ܼۼ�ȥ�û����˻�
		'If totalMoney > userCredit Then 
			'IsCreditEnough = False
			'totalMoney = totalMoney - userCredit
			'Rs("credit") = userCredit
		'Else
			'IsCreditEnough = True 
		'End If
		'����֧�����Ƕ���
		olp_money = paymoney
		
		Rs.Update
		Rs.Close


		Set Rs = Nothing
		
	End Sub
	
	'ʹ���˻����֧��
	Sub Pay()

		order_id = Dream3CLS.ChkNumeric(Request("order_id"))
		paytype = Dream3CLS.RSQL("paytype")
		
		Sql = "Select * From T_Order Where id = "&order_id&" and user_id="&Session("_UserID")
		Rs.open Sql,conn,1,2
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ��ö�����Ϣ��",0,"0")
			Response.End()
		End If
		
			'================ ��¼����Ϣ mike
			session("order_id")=order_id 
			session("order_no")=rs("order_no") 
			session("user_id")=rs("user_id")
			session("owner_id")=rs("owner_id")
			session("user_mobile")=rs("mobile") 'user_mobile
			
			Set tRs = Server.CreateObject("adodb.recordset")			
			Sql = "Select * From T_User Where id = "&session("owner_id")&""
			tRs.open Sql,conn,1,1
				session("owner_mobile")=tRs("mobile") 'owner_mobile �̼��ֻ���
			tRs.Close
			Set tRs = Nothing
			'================ ��¼����Ϣ mike
		product_id = Rs("product_id")
		quantity = Rs("checkindays")
		money = CDBL(Rs("reserve"))
		
		'����õ��Ѹ����ֱ����ת���ɹ�
		If Rs("state") = "pay" Then
			already_pay=1 '�����ת mike
			PayResult = "success"
			Exit Sub
		End If
		
		'�ж��Ƿ���Զ���
		Set productRs = Server.CreateObject("adodb.recordset")			
		Sql = "Select * From T_product Where id="&product_id
		productRs.Open Sql,Conn,1,2
		houseTitle = productRs("housetitle")
		end_time = productRs("end_date")
		start_time = productRs("start_date")
		
		productRs.Close
		Set productRs = Nothing
		
		'If DateDiff("s",end_time,now()) > 0 Then
			'PayResult = "error"
			'PayErrorMsg = "����Ŀ�Ѿ�����,��ȴ���һ�λ��ᣡ"
		'ElseIf DateDiff("s",start_time,now()) < 0 Then
			'PayResult = "error"
			'PayErrorMsg = "����Ŀ��δ��ʼ��"
		'End If
		
			
		If PayResult = "error" Then
			Exit Sub
		End If
		
		If money > userCredit then
			PayResult = "error"
			PayErrorMsg = "�����˻�����Ѳ��㣡"
			Exit Sub
		End If
			
		Rs("pay_time") = Now()
		Rs("service") = "onlinepay" ' Ҫʹ�þ�����������滻��Ŀǰ��ʱΪcredit ��ʾ�˻���� *dream3*
		
		If money > userCredit Then
			orderCredit = userCredit
		Else
			orderCredit = money
			Rs("state") = "pay"
		End If
		
		Rs("credit") = orderCredit' Ҫʹ�þ�����������滻��Ŀǰ��ʱΪcredit ��ʾ�˻���� *dream3*
		Rs.Update
		Rs.Close
	
		Set Rs = Nothing
		'����״̬������������������ˣ����־success�Լ�ʱ��'
		'ע�⵽���Ͳ����ж��ˣ���Ҫ�ظ��޸�
		'Call UpdateProductState(product_id)

		'���ܶ�С���û����˻�����û��ۿ�˴������س�������Ϊ��Ҫֻ�����Ĳ��ܵ����������Ȼ��Ҫ�ж�
		If money <= userCredit then
			Dream3User.AddOrDeductUserMoney Session("_UserID"),-money
			'WriteToFinRecord credit �������֧��
			'Dream3product.WriteToFinRecord Session("_UserID"),0,product_id,"expense","credit",money
		
			
			'���Ͷ���
			'Call Dream3product.SendOrderSuccessSMS(order_id)
			
			userCredit = userCredit - money
		
		End If
		
		PayResult = "success"
		'������ʾ����
		If Dream3product.IsUserOrder(Session("_UserID"))  Then
			Response.Cookies(DREAM3C)("_UserOrderFlag") = "Y"
		Else
			Response.Cookies(DREAM3C)("_UserOrderFlag") = "N"
		End If
		
	End Sub
%>

<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="common/js/jquery/thickbox-compressed.js"></script>
<title><%=Dream3CLS.SiteConfig("SiteName")%>-֧��</title>
<style type="text/css" media="all">
@import "common/static/style/thickbox.css";
</style>

<div class="content_wrapper">
	
    <div class="yuding_box">
        
        <div class="part1_bg">
            <ul>
                <li class="num_01"><h2>�ͷ�Ԥ��</h2></li>
                <li class="num_07"><h2>֧������</h2></li>
                <li class="num_08"><h2>���</h2></li>
            </ul>
        </div>
        <div class="line_one"></div>
		<%
		If PayResult = "success" Then
		
		
		%>

        <div class="success"><h2>��Ķ�����֧���ɹ��ˣ�</h2> </div>
        
        <div class="line_one"></div>
        
        <p class="Order_details">�鿴������Ŀ&nbsp;<a href="detail.asp?pid=<%=product_id%>"><%=houseTitle%></a>&nbsp;��&nbsp;<a href="<%=VirtualPath%>/user/order/view.asp?id=<%=order_id%>">��������</a></p>
        
		<%
			'=================== mike
			if already_pay<>1 then
		

				response.Write(" <img  src='m_send_pay.asp' style='width:0px;height:0px' />")
			end if
			'=================== mike
				
		ElseIf PayResult = "error" Then%>
		
		<div class="error"><h2>��Ķ�����֧��ʧ���ˣ�</h2> </div>
        
        <div class="line_one"></div>
        
        <p class="Order_details">���� <a href="check.asp?id=<%=order_id%>">���¸���</a> ��</p>
        <%
		Else
		%>
		<div class="zhifu">
			<div class="head">
				<h2>Ӧ���ܶ<strong class="total-money"><%=paymoney%></strong> Ԫ</h2>
				
			</div>
			<div class="sect">
			<%If IsCreditEnough Then%>
			<form id="order-pay-credit-form" method="post">
				<input type="hidden" name="order_id" value="<%=order_id%>" />
				<input type="hidden" name="service" value="credit" />
				<input type="hidden" name="product_id" value="<%=product_id%>" />
				<input type="hidden" name="act" value="pay" />
				<input type="submit" class="formbutton gotopay" value="ʹ���˻����֧��" />
			</form>
			<%
			Else
				'�ױ�֧��
				If paytype = "yeepay" Then
			%>
			<!--#include file="onlinepay/YeePay/yeepayCommon.asp"-->
			<%
					Call ShowYeepay()
				Elseif paytype = "alipay" Then
			%>
			<!--#include file="onlinepay/alipay/alipayto.asp"-->
			<%
				Elseif paytype = "chinabank" Then
			%>
			<!--#include file="onlinepay/chinabank/chinabank_config.asp"-->
			<%
				Call ShowChinabank()
				Elseif paytype = "tenpay" Then
			%>
			<!--#include file="onlinepay/tenpay/tenpay_config.asp"-->
			<%
				Call ShowTenpay()	
				ElseIf paytype = "other" Then
			%>
				<%=Dream3CLS.Dream3_OtherPay%>
			<%
				End If
			End If
			%>
			<div class="back-to-check" style="display:none "><%If Not IsCreditEnough Then%>�����˻�����<%End If%></div>
            <div class="back-to-check"><a href="check.asp?id=<%=order_id%>">&raquo; ����ѡ������֧����ʽ</a>
			</div>
			</div>

		</div>
        <%
		End If
		%>
    </div>
    
</div>


<%
Sub ShowYeepay()
	Dim amount
	Dim productDesc
	Dim productCat
	Dim productId
	Dim	cur
	Dim sMctProperties
	Dim sNewString
	Dim frpId
	
	'�̼������û�������Ʒ��֧����Ϣ

	orderId=olp_order_no					'�̼ҵĽ��׶����Ŵ˲�����ѡ�����������ظ������������YeePay���Զ������̼�����һ�������ţ�
	productId =CStr(product_id)		'��ƷID(���������д�������Ժ�ͳ�ƶ���)	
	amount=olp_money             	'������(����)
	cur="CNY"					'���ҵ�λ(�̶�����Ҫ�޸ģ�����һ��ֻ��֧������ҽ���)
	messageType = "Buy"
	addressFlag = "0"				'��Ҫ��д�ͻ���Ϣ 0������Ҫ  1:��Ҫ
	productDesc = ""			'��Ʒ����(�ɱ���Ϊ��)
	productCat = ""				'��Ʒ����(�ɱ���Ϊ��)
	'�̼ҿ��԰�һЩ������Ϣ����mp�б��У�����YeePay�ױ�ƽ̨����ʱ��������ԭ��ȡ���̼��趨��һЩ��Ϣ�������ṩ�̼���ʱ������Ϣ�Ĺ���
	sMctProperties = ""			'(�ɱ���Ϊ��)
	
	'���ֱ�ӵ�YeePay�����趨Ϊ�ռ��ɣ������̼Ҷ�ѡ�����е��������μ������б�
	frpId=""					'(��ѡ)
	needResponse = "1" '�Ƿ���ҪӦ�����,Ĭ�ϻ�0Ϊ����ҪӦ�����,1Ϊ��ҪӦ�����.
	'����ǩ����������ǩ����
	'sNewString = getReqHmacString(orderId,amount,cur,productId,productCat,productDesc,merchantCallbackURL,sMctProperties,frpId)
	sNewString = HTMLcommom(p1_MerId,orderId,amount,cur,productId,productCat,productDesc,merchantCallbackURL,sMctProperties,frpId,needResponse)

	
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""p0_Cmd"" value="""&messageType&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""p1_MerId"" value="""&p1_MerId&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""p2_Order"" value="""&orderId&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""p3_Amt"" value="""&amount&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""p4_Cur"" value="""&cur&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""p5_Pid"" value="""&productId&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""p6_Pcat"" value="""&productCat&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""p7_Pdesc"" value="""&productDesc&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""p8_Url"" value="""&merchantCallbackURL&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""p9_SAF"" value="""&addressFlag&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""pa_MP"" value="""&sMctProperties&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""pd_FrpId"" value="""&frpId&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""pr_NeedResponse"" value="""&needResponse&""">"&vbcrlf
	hiddenstr=hiddenstr&"<input type=""hidden"" name=""hmac"" value="""&sNewString&""">"&vbcrlf
%>
<img src="images/onlinepay/yeepay.gif" /><br />
<form id="order-pay-credit-form" action="https://www.yeepay.com/app-merchant-proxy/node" method=post target="_blank">
	<%=hiddenstr%>
	<%=GetAjaxSubmitButton("�ױ�")%>
</form>
<%
End Sub
%>

<%
Sub ShowAlipay()

%>

<%
End Sub
%>

<%
Sub ShowChinabank()
	v_mid = chinabank_ID   '���������ʺ�
	v_oid =  olp_order_no '������
	v_amount = olp_money		' �������
	v_moneytype = "CNY"					' ����
	v_url = chinabank_return_url
	v_key = chinabank_key

	text = v_amount&v_moneytype&v_oid&v_mid&v_url&v_key	' ƴ�ռ��ܴ�
	

	v_md5info=Ucase(trim(ChinabankMD5.md5(text)))					' ����֧��ƽ̨��MD5ֵֻ�ϴ�д�ַ���������Сд��MD5ֵ��ת��Ϊ��д

'**********���¼���Ϊ��ѡ��Ϣ,��������������߻ᱣ�����Ϣ,ʹ�úͲ�ʹ�ö���Ӱ��֧����**************

	   v_rcvname = request("v_rcvname")			' �ջ���
	   v_rcvaddr = request("v_rcvaddr")			' �ջ���ַ
		v_rcvtel = request("v_rcvtel")			' �ջ��˵绰
	   v_rcvpost = request("v_rcvpost")			' �ջ����ʱ�
	  v_rcvemail = request("v_rcvemail")		' �ջ����ʼ�
	 v_rcvmobile = request("v_rcvmobile")		' �ջ����ֻ���

	 v_ordername = request("v_ordername")		' ����������
	 v_orderaddr = request("v_orderaddr")		' �����˵�ַ
	  v_ordertel = request("v_ordertel")		' �����˵绰
	 v_orderpost = request("v_orderpost")		' �������ʱ�
  	v_orderemail = request("v_orderemail")		' �������ʼ�
	v_ordermobile = request("v_ordermobile")	' �������ֻ���

		 remark1 = "�û���:"&session("_UserName")			' ��ע�ֶ�1
		 remark2 = "��Ʒ����:"&olp_product_name		' ��ע�ֶ�2
	
%>
<img src="images/onlinepay/chinabank.gif" /><br />
<form id="order-pay-credit-form" action="https://pay3.chinabank.com.cn/PayGate?encoding=GB2312" method=post target="_blank">
  <input type="hidden" name="v_md5info"    value="<%=v_md5info%>" size="100">
  <input type="hidden" name="v_mid"        value="<%=v_mid%>">
  <input type="hidden" name="v_oid"        value="<%=v_oid%>">
  <input type="hidden" name="v_amount"     value="<%=v_amount%>">
  <input type="hidden" name="v_moneytype"  value="<%=v_moneytype%>">
  <input type="hidden" name="v_url"        value="<%=v_url%>">
   
  <!--���¼�����Ϊ����֧����ɺ���֧��������Ϣһͬ������Ϣ����ҳ -->
    
  <input type="hidden"  name="remark1" value="<%=remark1%>">
  <input type="hidden"  name="remark2" value="<%=remark2%>">
    
<!--���¼���ֻ��������¼�ͻ���Ϣ�����Բ��ã���Ӱ��֧�� -->

	<input type="hidden"  name="v_rcvname"      value="<%=v_rcvname%>">
	<input type="hidden"  name="v_rcvaddr"      value="<%=v_rcvaddr%>">
	<input type="hidden"  name="v_rcvtel"       value="<%=v_rcvtel%>">
	<input type="hidden"  name="v_rcvpost"      value="<%=v_rcvpost%>">
	<input type="hidden"  name="v_rcvemail"     value="<%=v_rcvemail%>">
	<input type="hidden"  name="v_rcvmobile"    value="<%=v_rcvmobile%>">

	<input type="hidden"  name="v_ordername"    value="<%=v_ordername%>">
	<input type="hidden"  name="v_orderaddr"    value="<%=v_orderaddr%>">
	<input type="hidden"  name="v_ordertel"     value="<%=v_ordertel%>">
	<input type="hidden"  name="v_orderpost"    value="<%=v_orderpost%>">
	<input type="hidden"  name="v_orderemail"   value="<%=v_orderemail%>">
	<input type="hidden"  name="v_ordermobile"  value="<%=v_ordermobile%>">
	<%=GetAjaxSubmitButton("��������")%>
	
</form>
<%
End Sub
%>


<%
Sub ShowTenpay()
Dim strDate
Dim strTime
Dim randNumber
Dim strReq

'8λ���ڸ�ʽYYYYmmdd
strDate = getServerDate()

'6λʱ��,��ʽhhmiss
strTime = getTime()

'4λ�����
randNumber = getStrRandNumber(1000,9999)

'10λ���к�,�������е�����
strReq = strTime & randNumber

Dim key
Dim bargainor_id
Dim sp_billno
Dim transaction_id
Dim total_fee
Dim desc
Dim return_url

'��Կ
key = tenpay_key

'�̻���
bargainor_id = tenpay_ID

'���ص�ַ
return_url = tenpay_return_url

'�̼Ҷ�����,����������32λ��ȡǰ32λ���Ƹ�ֻͨ��¼�̼Ҷ����ţ�����֤Ψһ��
sp_billno = olp_order_no

'�Ƹ�ͨ���׵��ţ�����Ϊ��10λ�̻���+8λʱ�䣨YYYYmmdd)+10λ��ˮ��,��֤Ψһ��
transaction_id = bargainor_id & strDate & Mid(olp_order_no,5)

'��Ʒ�۸񣨰����˷ѣ����Է�Ϊ��λ
total_fee = olp_money * 100

'��Ʒ����
desc = olp_product_name



'����֧���������
Dim reqHandler
Set reqHandler = new PayRequestHandler

'��ʼ��
reqHandler.init()

'������Կ
reqHandler.setKey(key)

'-----------------------------
'����֧������
'-----------------------------
reqHandler.setParameter "bargainor_id", bargainor_id		'�����̻���
reqHandler.setParameter "sp_billno", sp_billno				'�̻�������
reqHandler.setParameter "transaction_id", transaction_id	'�Ƹ�ͨ���׵���
reqHandler.setParameter "total_fee", total_fee				'��Ʒ�ܽ��,�Է�Ϊ��λ
reqHandler.setParameter "return_url", return_url			'���ص�ַ
reqHandler.setParameter "desc", desc						'��Ʒ����

'�û�ip,���Ի���ʱ��Ҫ�����ip��������ʽ�����ټӴ˲���
reqHandler.setParameter "spbill_create_ip", Request.ServerVariables("REMOTE_ADDR")


'�����URL
Dim reqUrl
reqUrl = reqHandler.getRequestURL()
	
%>
<img src="images/onlinepay/tenpay.jpg" /><br />
<input alt="ajax/pay_confirm_page.asp?paytype=<%=paytype%>&order_id=<%=order_id%>&height=150&width=240" type="submit" id="order_onlinepay_tenpay_button" class="thickbox" title="�밴��ʾ��ɲ���" value="ǰ���Ƹ�֧ͨ��"  style="display:none"/>
<a href="<%=reqUrl%>"  target="_blank" onclick="document.getElementById('order_onlinepay_tenpay_button').click();">ǰ���Ƹ�֧ͨ��</a>

<%
End Sub
%>


<!--#include file="common/inc/footer_user.asp"-->