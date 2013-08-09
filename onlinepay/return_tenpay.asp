<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_product.asp"-->
<!--#include file="../common/api/cls_user.asp"-->
<!--#include file="OnlinePaycode.asp"-->
<!--#include file="tenpay/tenpay_config.asp"-->
<!--#include file="tenpay/md5.asp"-->
<!--#include file="tenpay/tenpay_util.asp"-->
<!--#include file="tenpay/PayRequestHandler.asp"-->
<!--#include file="tenpay/PayResponseHandler.asp"-->
<!--#include file="../common/api/cls_tpl.asp"-->
<!--#include file="../common/api/cls_sms.asp"-->
<!--#include file="../common/api/cls_xml.asp"-->
<%
Server.ScriptTimeout=20
On Error Resume Next
Dim PayResult
Dim returnMsg
%>

<%   
Call  CommitOrderTrans()

Sub CommitOrderTrans()
	On Error Resume Next
	
	Dim resHandler
	Set resHandler = new PayResponseHandler
	resHandler.setKey(tenpay_key)
	
	'判断签名
	If resHandler.isTenpaySign() = True Then
		
		Dim transaction_id
		Dim total_fee
	
		'交易单号
		transaction_id = resHandler.getParameter("transaction_id")
		sp_billno = resHandler.getParameter("sp_billno")'订单号
	
		'商品金额,以分为单位
		total_fee = resHandler.getParameter("total_fee")
		total_fee = CDBL(total_fee) / 100 
		
		
		'支付结果
		pay_result = resHandler.getParameter("pay_result")
		
		If "0" = pay_result Then
		
			'支付成功
		    '此处加入商户系统的逻辑处理（例如判断金额，判断支付状态，更新订单状态等等）......

			SetOrderState sp_billno,"tenpay",transaction_id,total_fee
			Set tRs = Dream3product.GetOrderByOrderNo(sp_billno)
			UpdateproductState(tRs("product_id"))
			returnMsg	= "支付成功！"
			PayResult = "success"
		
		Else
			'当做不成功处理
			'Response.Write("支付失败")
			returnMsg	= returnMsg	&	"支付失败！"
			PayResult = "error"
			Exit Sub
		End If	
	
	Else
	
		'签名失败
		'Response.Write("签名签证失败")
	
		returnMsg	= returnMsg	&	"签名签证失败！"
		PayResult = "error"
		Exit Sub
	
	End If

	   
End Sub
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>财付通 - <%=Dream3CLS.SiteConfig("SiteName")%></title>
<meta name="description" content="<%=Dream3CLS.SiteConfig("MetaDescription")%>">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
</head>
	<body>
    	<%=returnMsg%>,请关闭此页面并回到支付页面完成操作！
	</body>
</html>