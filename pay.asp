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
	GetAjaxSubmitButton = "<input alt=""ajax/pay_confirm_page.asp?paytype="&paytype&"&order_id="&order_id&"&height=150&width=240"" type=""submit"" id=""order_onlinepay_button"" class=""thickbox"" title=""请按提示完成操作"" value=""前往"&s_paytype&"支付"" onclick=""this.form.submit();"" />"
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
			Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
			Response.End()
		End If
			'================ 记录下信息 mike
			session("order_id")=order_id 
			session("order_no")=rs("order_no") 
			session("user_id")=rs("user_id")
			session("owner_id")=rs("owner_id")
			session("user_mobile")=rs("mobile") 'user_mobile
			
			Set tRs = Server.CreateObject("adodb.recordset")			
			Sql = "Select * From T_User Where id = "&session("owner_id")&""
			tRs.open Sql,conn,1,1
				session("owner_mobile")=tRs("mobile") 'owner_mobile 商家手机号
			tRs.Close
			Set tRs = Nothing
			'================ 记录下信息 mike

		
		product_id = Rs("product_id")
		Set productRs = Server.CreateObject("adodb.recordset")			
		Sql = "Select * From T_Product Where id="&product_id
		productRs.Open Sql,Conn,1,1
		houseTitle = productRs("housetitle")
		olp_product_name = productRs("housetitle")
		productRs.Close
		Set productRs = Nothing
		
		'如果该单已付款，则直接跳转到成功
		If Rs("state") = "pay" Then
			already_pay=1 '标记跳转 mike
			PayResult = "success"
			Exit Sub
		End If
		
		'显示未付款提示
		If paytip <> "" Then
			gMsgArr = "此订单尚未完成付款，请重新付款,如果您所选择的交易方式已扣款成功，请与我们联系查证！"
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
		
		'因为是从check过来的，所以要更新支付字段
		
		'应付总额算法为：如果账户足够，则直接显示账户金额，如果账户不够，则显示总价减去用户的账户
		'If totalMoney > userCredit Then 
			'IsCreditEnough = False
			'totalMoney = totalMoney - userCredit
			'Rs("credit") = userCredit
		'Else
			'IsCreditEnough = True 
		'End If
		'在线支付的是定金
		olp_money = paymoney
		
		Rs.Update
		Rs.Close


		Set Rs = Nothing
		
	End Sub
	
	'使用账户余额支付
	Sub Pay()

		order_id = Dream3CLS.ChkNumeric(Request("order_id"))
		paytype = Dream3CLS.RSQL("paytype")
		
		Sql = "Select * From T_Order Where id = "&order_id&" and user_id="&Session("_UserID")
		Rs.open Sql,conn,1,2
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到该订单信息！",0,"0")
			Response.End()
		End If
		
			'================ 记录下信息 mike
			session("order_id")=order_id 
			session("order_no")=rs("order_no") 
			session("user_id")=rs("user_id")
			session("owner_id")=rs("owner_id")
			session("user_mobile")=rs("mobile") 'user_mobile
			
			Set tRs = Server.CreateObject("adodb.recordset")			
			Sql = "Select * From T_User Where id = "&session("owner_id")&""
			tRs.open Sql,conn,1,1
				session("owner_mobile")=tRs("mobile") 'owner_mobile 商家手机号
			tRs.Close
			Set tRs = Nothing
			'================ 记录下信息 mike
		product_id = Rs("product_id")
		quantity = Rs("checkindays")
		money = CDBL(Rs("reserve"))
		
		'如果该单已付款，则直接跳转到成功
		If Rs("state") = "pay" Then
			already_pay=1 '标记跳转 mike
			PayResult = "success"
			Exit Sub
		End If
		
		'判断是否可以订单
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
			'PayErrorMsg = "该项目已经结束,请等待下一次机会！"
		'ElseIf DateDiff("s",start_time,now()) < 0 Then
			'PayResult = "error"
			'PayErrorMsg = "该项目还未开始！"
		'End If
		
			
		If PayResult = "error" Then
			Exit Sub
		End If
		
		If money > userCredit then
			PayResult = "error"
			PayErrorMsg = "您的账户余额已不足！"
			Exit Sub
		End If
			
		Rs("pay_time") = Now()
		Rs("service") = "onlinepay" ' 要使用具体的数据来替换，目前暂时为credit 表示账户余额 *dream3*
		
		If money > userCredit Then
			orderCredit = userCredit
		Else
			orderCredit = money
			Rs("state") = "pay"
		End If
		
		Rs("credit") = orderCredit' 要使用具体的数据来替换，目前暂时为credit 表示账户余额 *dream3*
		Rs.Update
		Rs.Close
	
		Set Rs = Nothing
		'更新状态：如果数量或人数到了，则标志success以及时间'
		'注意到达后就不用判断了，不要重复修改
		'Call UpdateProductState(product_id)

		'当总额小于用户的账户则给用户扣款，此处条件必成立，因为需要只有余额够的才能点击，但是仍然需要判断
		If money <= userCredit then
			Dream3User.AddOrDeductUserMoney Session("_UserID"),-money
			'WriteToFinRecord credit 代表余额支付
			'Dream3product.WriteToFinRecord Session("_UserID"),0,product_id,"expense","credit",money
		
			
			'发送短信
			'Call Dream3product.SendOrderSuccessSMS(order_id)
			
			userCredit = userCredit - money
		
		End If
		
		PayResult = "success"
		'设置提示订单
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
<title><%=Dream3CLS.SiteConfig("SiteName")%>-支付</title>
<style type="text/css" media="all">
@import "common/static/style/thickbox.css";
</style>

<div class="content_wrapper">
	
    <div class="yuding_box">
        
        <div class="part1_bg">
            <ul>
                <li class="num_01"><h2>客房预订</h2></li>
                <li class="num_07"><h2>支付定金</h2></li>
                <li class="num_08"><h2>完成</h2></li>
            </ul>
        </div>
        <div class="line_one"></div>
		<%
		If PayResult = "success" Then
		
		
		%>

        <div class="success"><h2>你的订单，支付成功了！</h2> </div>
        
        <div class="line_one"></div>
        
        <p class="Order_details">查看所购项目&nbsp;<a href="detail.asp?pid=<%=product_id%>"><%=houseTitle%></a>&nbsp;的&nbsp;<a href="<%=VirtualPath%>/user/order/view.asp?id=<%=order_id%>">订单详情</a></p>
        
		<%
			'=================== mike
			if already_pay<>1 then
		

				response.Write(" <img  src='m_send_pay.asp' style='width:0px;height:0px' />")
			end if
			'=================== mike
				
		ElseIf PayResult = "error" Then%>
		
		<div class="error"><h2>你的订单，支付失败了！</h2> </div>
        
        <div class="line_one"></div>
        
        <p class="Order_details">返回 <a href="check.asp?id=<%=order_id%>">重新付款</a> ！</p>
        <%
		Else
		%>
		<div class="zhifu">
			<div class="head">
				<h2>应付总额：<strong class="total-money"><%=paymoney%></strong> 元</h2>
				
			</div>
			<div class="sect">
			<%If IsCreditEnough Then%>
			<form id="order-pay-credit-form" method="post">
				<input type="hidden" name="order_id" value="<%=order_id%>" />
				<input type="hidden" name="service" value="credit" />
				<input type="hidden" name="product_id" value="<%=product_id%>" />
				<input type="hidden" name="act" value="pay" />
				<input type="submit" class="formbutton gotopay" value="使用账户余额支付" />
			</form>
			<%
			Else
				'易宝支付
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
			<div class="back-to-check" style="display:none "><%If Not IsCreditEnough Then%>您的账户余额不足<%End If%></div>
            <div class="back-to-check"><a href="check.asp?id=<%=order_id%>">&raquo; 返回选择其他支付方式</a>
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
	
	'商家设置用户购买商品的支付信息

	orderId=olp_order_no					'商家的交易定单号此参数可选，但不能有重复（如果不输入YeePay会自动帮助商家生成一个订单号）
	productId =CStr(product_id)		'商品ID(尽量清楚填写，方便以后统计订单)	
	amount=olp_money             	'购买金额(必须)
	cur="CNY"					'货币单位(固定不需要修改，现在一般只会支持人民币交易)
	messageType = "Buy"
	addressFlag = "0"				'需要填写送货信息 0：不需要  1:需要
	productDesc = ""			'商品描述(可保持为空)
	productCat = ""				'商品种类(可保持为空)
	'商家可以把一些辅助信息放在mp列表中，当从YeePay易宝平台返回时，还可以原样取出商家设定的一些信息。可以提供商家临时保存信息的功能
	sMctProperties = ""			'(可保持为空)
	
	'如果直接到YeePay网关设定为空即可，而在商家端选择银行的情况下请参见银行列表
	frpId=""					'(可选)
	needResponse = "1" '是否需要应答机制,默认或0为不需要应答机制,1为需要应答机制.
	'调用签名函数生成签名串
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
	<%=GetAjaxSubmitButton("易宝")%>
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
	v_mid = chinabank_ID   '网银在线帐号
	v_oid =  olp_order_no '订单号
	v_amount = olp_money		' 订单金额
	v_moneytype = "CNY"					' 币种
	v_url = chinabank_return_url
	v_key = chinabank_key

	text = v_amount&v_moneytype&v_oid&v_mid&v_url&v_key	' 拼凑加密串
	

	v_md5info=Ucase(trim(ChinabankMD5.md5(text)))					' 网银支付平台对MD5值只认大写字符串，所以小写的MD5值得转换为大写

'**********以下几项为可选信息,如果发送网银在线会保存此信息,使用和不使用都不影响支付！**************

	   v_rcvname = request("v_rcvname")			' 收货人
	   v_rcvaddr = request("v_rcvaddr")			' 收货地址
		v_rcvtel = request("v_rcvtel")			' 收货人电话
	   v_rcvpost = request("v_rcvpost")			' 收货人邮编
	  v_rcvemail = request("v_rcvemail")		' 收货人邮件
	 v_rcvmobile = request("v_rcvmobile")		' 收货人手机号

	 v_ordername = request("v_ordername")		' 订货人姓名
	 v_orderaddr = request("v_orderaddr")		' 订货人地址
	  v_ordertel = request("v_ordertel")		' 订货人电话
	 v_orderpost = request("v_orderpost")		' 订货人邮编
  	v_orderemail = request("v_orderemail")		' 订货人邮件
	v_ordermobile = request("v_ordermobile")	' 订货人手机号

		 remark1 = "用户名:"&session("_UserName")			' 备注字段1
		 remark2 = "产品名称:"&olp_product_name		' 备注字段2
	
%>
<img src="images/onlinepay/chinabank.gif" /><br />
<form id="order-pay-credit-form" action="https://pay3.chinabank.com.cn/PayGate?encoding=GB2312" method=post target="_blank">
  <input type="hidden" name="v_md5info"    value="<%=v_md5info%>" size="100">
  <input type="hidden" name="v_mid"        value="<%=v_mid%>">
  <input type="hidden" name="v_oid"        value="<%=v_oid%>">
  <input type="hidden" name="v_amount"     value="<%=v_amount%>">
  <input type="hidden" name="v_moneytype"  value="<%=v_moneytype%>">
  <input type="hidden" name="v_url"        value="<%=v_url%>">
   
  <!--以下几项项为网上支付完成后，随支付反馈信息一同传给信息接收页 -->
    
  <input type="hidden"  name="remark1" value="<%=remark1%>">
  <input type="hidden"  name="remark2" value="<%=remark2%>">
    
<!--以下几项只是用来记录客户信息，可以不用，不影响支付 -->

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
	<%=GetAjaxSubmitButton("网银在线")%>
	
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

'8位日期格式YYYYmmdd
strDate = getServerDate()

'6位时间,格式hhmiss
strTime = getTime()

'4位随机数
randNumber = getStrRandNumber(1000,9999)

'10位序列号,可以自行调整。
strReq = strTime & randNumber

Dim key
Dim bargainor_id
Dim sp_billno
Dim transaction_id
Dim total_fee
Dim desc
Dim return_url

'密钥
key = tenpay_key

'商户号
bargainor_id = tenpay_ID

'返回地址
return_url = tenpay_return_url

'商家订单号,长度若超过32位，取前32位。财付通只记录商家订单号，不保证唯一。
sp_billno = olp_order_no

'财付通交易单号，规则为：10位商户号+8位时间（YYYYmmdd)+10位流水号,保证唯一性
transaction_id = bargainor_id & strDate & Mid(olp_order_no,5)

'商品价格（包含运费），以分为单位
total_fee = olp_money * 100

'商品名称
desc = olp_product_name



'创建支付请求对象
Dim reqHandler
Set reqHandler = new PayRequestHandler

'初始化
reqHandler.init()

'设置密钥
reqHandler.setKey(key)

'-----------------------------
'设置支付参数
'-----------------------------
reqHandler.setParameter "bargainor_id", bargainor_id		'设置商户号
reqHandler.setParameter "sp_billno", sp_billno				'商户订单号
reqHandler.setParameter "transaction_id", transaction_id	'财付通交易单号
reqHandler.setParameter "total_fee", total_fee				'商品总金额,以分为单位
reqHandler.setParameter "return_url", return_url			'返回地址
reqHandler.setParameter "desc", desc						'商品名称

'用户ip,测试环境时不要加这个ip参数，正式环境再加此参数
reqHandler.setParameter "spbill_create_ip", Request.ServerVariables("REMOTE_ADDR")


'请求的URL
Dim reqUrl
reqUrl = reqHandler.getRequestURL()
	
%>
<img src="images/onlinepay/tenpay.jpg" /><br />
<input alt="ajax/pay_confirm_page.asp?paytype=<%=paytype%>&order_id=<%=order_id%>&height=150&width=240" type="submit" id="order_onlinepay_tenpay_button" class="thickbox" title="请按提示完成操作" value="前往财付通支付"  style="display:none"/>
<a href="<%=reqUrl%>"  target="_blank" onclick="document.getElementById('order_onlinepay_tenpay_button').click();">前往财付通支付</a>

<%
End Sub
%>


<!--#include file="common/inc/footer_user.asp"-->