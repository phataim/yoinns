<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_team.asp"-->
<!--#include file="../common/api/cls_user.asp"-->
<!--#include file="OnlinePaycode.asp"-->
<!--#include file="md5.inc"-->
<!--#include file="alipay/alipay_md5.asp"-->
<!--#include file="../common/api/cls_tpl.asp"-->
<!--#include file="../common/api/cls_sms.asp"-->
<!--#include file="../common/api/cls_xml.asp"-->

<%
	'功能：付完款后跳转的页面（页面跳转同步通知页面）
	'版本：3.1
	'日期：2010-11-23
	'说明：
	'以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
	'该代码仅供学习和研究支付宝接口使用，只是提供一个参考。
	
''''''''页面功能说明''''''''''''''''
'该页面可在本机电脑测试
'该页面称作“页面跳转同步通知页面”，是由支付宝服务器同步调用，可当作是支付完成后的提示信息页，如“您的某某某订单，多少金额已支付成功”。
'可放入HTML等美化页面的代码和订单交易完成后的数据库更新程序代码
'该页面可以使用ASP开发工具调试，也可以使用写文本函数log_result进行调试，该函数已被默认关闭，见alipay_notify.asp中的函数return_verify
'WAIT_SELLER_SEND_GOODS(表示买家已在支付宝交易管理中产生了交易记录且付款成功，但卖家没有发货);
'TRADE_FINISHED(表示买家已经确认收货，这笔交易完成);

''''''''注意'''''''''''''''''''''''
'如何判断该笔交易是通过即时到帐方式付款还是通过担保交易方式付款？
'
'担保交易的交易状态变化顺序是：等待买家付款→买家已付款，等待卖家发货→卖家已发货，等待买家收货→买家已收货，交易完成
'即时到帐的交易状态变化顺序是：等待买家付款→交易完成
'
'每当收到支付宝发来通知时，就可以获取到这笔交易的交易状态，并且商户需要利用商户订单号查询商户网站的订单数据，
'得到这笔订单在商户网站中的状态是什么，把商户网站中的订单状态与从支付宝通知中获取到的状态来做对比。
'如果商户网站中目前的状态是等待买家付款，而从支付宝通知获取来的状态是买家已付款，等待卖家发货，那么这笔交易买家是用担保交易方式付款的
'如果商户网站中目前的状态是等待买家付款，而从支付宝通知获取来的状态是交易完成，那么这笔交易买家是用即时到帐方式付款的
''''''''''''''''''''''''''''''''''''
%>
<!--#include file="alipay/alipay_config.asp"-->
<!--#include file="alipay/alipay_notify.asp"-->

<%
'计算得出通知验证结果
'verify_result = return_verify()

't(verify_result)
verify_result = true

Dim returnMsg
Dim total_fee
Dim order_no
Dim OnlineNumber
Dim team_id
 
if verify_result then	'验证成功
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'请在这里加上商户的业务逻辑程序代码
	
	'——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
    '获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表
    order_no		= "11120620355004"	'获取订单号
    total_fee		= 95			'获取总金额
	OnlineNumber = "1234567"
	team_id = 6
	

	SetOrderState order_no,"alipay",OnlineNumber,CDBL(total_fee)
	Set tRs = Dream3Team.GetOrderByOrderNo(order_no)
	UpdateTeamState(tRs("team_id"))
	
	
	returnMsg	= "支付成功！"
	
	'——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
else '验证失败
    '如要调试，请看alipay_notify.asp页面的return_verify函数，比对sign和mysign的值是否相等，或者检查responseTxt有没有返回true
    returnMsg	= "支付失败！"
end if

Sub createLog(ByRef returnMsg)
    filename = "alipay/alipaytradeinfo.log"
    content = now()		&	","							&	request.ServerVariables("REMOTE_ADDR")
    content = content &	","							&	returnMsg
    content = content &	",商户订单号:"	& r6_Order
    content = content &	",支付金额:"		& r3_Amt

    
    Set FSO = Server.CreateObject("Scripting.FileSystemObject")   
    Set TS = FSO.OpenTextFile(Server.MapPath(filename),8,true) 
    TS.write content   
    TS.Writeline ""
    TS.Writeline ""
    Set TS = Nothing   
    Set FSO = Nothing   
End Sub
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>支付宝支付 - <%=SiteConfig("SiteName")%></title>
<meta name="description" content="<%=SiteConfig("MetaDescription")%>">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
</head>
	<body>
    	<%=returnMsg%>,请关闭此页面并回到支付页面完成操作！
	</body>
</html>