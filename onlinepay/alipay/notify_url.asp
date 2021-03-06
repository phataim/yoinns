<!--#include file="../../conn.asp"-->
<%
	'功能：支付宝主动通知调用的页面（服务器异步通知页面）
	'版本：3.1
	'日期：2010-11-25
	'说明：
	'以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
	'该代码仅供学习和研究支付宝接口使用，只是提供一个参考。
	
''''''''''''页面功能说明'''''''''''''''''''
'创建该页面文件时，请留心该页面文件中无任何HTML代码及空格。
'该页面不能在本机电脑测试，请到服务器上做测试。请确保互联网上可以访问该页面。
'该页面调试工具请使用写文本函数log_result，该函数已被默认开启，见alipay_notify.asp中的函数notify_verify
'WAIT_BUYER_PAY(表示买家已在支付宝交易管理中产生了交易记录，但没有付款);
'WAIT_SELLER_SEND_GOODS(表示买家已在支付宝交易管理中产生了交易记录且付款成功，但卖家没有发货);
'WAIT_BUYER_CONFIRM_GOODS(表示卖家已经发了货，但买家还没有做确认收货的操作);
'TRADE_FINISHED(表示买家已经确认收货，这笔交易完成);
'该服务器异步通知页面面主要功能是：防止订单未更新。如果没有收到该页面打印的 success 信息，支付宝会在24小时内按一定的时间策略重发通知

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
'''''''''''''''''''''''''''''''''''''''''''
%>

<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../../common/api/cls_sms.asp"-->
<!--#include file="../../common/api/cls_xml.asp"-->

<!--#include file="../OnlinePaycode.asp"-->
<!--#include file="../md5.inc"-->

<!--#include file="alipay_md5.asp"-->
<!--#include file="alipay_config.asp"-->
<!--#include file="alipay_notify.asp"-->
<%
'计算得出通知验证结果
verify_result = notify_verify()

if verify_result then	'验证成功
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'请在这里加上商户的业务逻辑程序代码
	
	'——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
    '获取支付宝的通知返回参数，可参考技术文档中服务器异步通知参数列表
    order_no		= request.Form("out_trade_no")	'获取订单号
    total_fee		= request.Form("price")			'获取总金额
	
	if request.Form("trade_status") = "WAIT_BUYER_PAY" then
	'该判断表示买家已在支付宝交易管理中产生了交易记录，但没有付款
		
		'判断该笔订单是否在商户网站中已经做过处理（可参考“集成教程”中“3.4返回数据处理”）
			'如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
			'如果有做过处理，不执行商户的业务程序
		
		response.Write "success"	'请不要修改或删除
		
		'调试用，写文本函数记录程序运行情况是否正常
        'log_result("这里写入想要调试的代码变量值，或其他运行的结果记录")
	elseif request.Form("trade_status") = "WAIT_SELLER_SEND_GOODS" then
	'该判断表示买家已在支付宝交易管理中产生了交易记录且付款成功，但卖家没有发货
		
		'判断该笔订单是否在商户网站中已经做过处理（可参考“集成教程”中“3.4返回数据处理”）
			'如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
			'如果有做过处理，不执行商户的业务程序
		
		response.Write "success"	'请不要修改或删除
		
		'调试用，写文本函数记录程序运行情况是否正常
        'log_result("这里写入想要调试的代码变量值，或其他运行的结果记录")
	elseif request.Form("trade_status") = "WAIT_BUYER_CONFIRM_GOODS" then
	'该判断表示卖家已经发了货，但买家还没有做确认收货的操作
	
		'判断该笔订单是否在商户网站中已经做过处理（可参考“集成教程”中“3.4返回数据处理”）
			'如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
			'如果有做过处理，不执行商户的业务程序
		
		response.Write "success"	'请不要修改或删除
		
		'调试用，写文本函数记录程序运行情况是否正常
        'log_result("这里写入想要调试的代码变量值，或其他运行的结果记录")
	elseif request.Form("trade_status") = "TRADE_FINISHED" then
	'该判断表示买家已经确认收货，这笔交易完成
	
		'判断该笔订单是否在商户网站中已经做过处理（可参考“集成教程”中“3.4返回数据处理”）
			'如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
			'如果有做过处理，不执行商户的业务程序
		
		SetOrderState order_no,"alipay",OnlineNumber,CDBL(total_fee)
		Set tRs = Dream3product.GetOrderByOrderNo(order_no)
		UpdateproductState(tRs("product_id"))
		response.Write "success"	
		
		'调试用，写文本函数记录程序运行情况是否正常
        'log_result("这里写入想要调试的代码变量值，或其他运行的结果记录")
		
	'如果交易成功，则判断订单的状态是否更新，如果未更新，则更新
	elseif request.Form("trade_status") = "TRADE_SUCCESS" then
		SetOrderState order_no,"alipay",OnlineNumber,CDBL(total_fee)
		Set tRs = Dream3product.GetOrderByOrderNo(order_no)
		UpdateproductState(tRs("product_id"))
		response.Write "success"	
	else
		'其他状态判断。
		
		response.Write "success"	
		'调试用，写文本函数记录程序运行情况是否正常
		'log_result ("这里写入想要调试的代码变量值，或其他运行的结果记录")
	end if
	'——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
else '验证失败
    response.Write "fail"
	'调试用，写文本函数记录程序运行情况是否正常
	'log_result ("这里写入想要调试的代码变量值，或其他运行的结果记录")
end if
%>