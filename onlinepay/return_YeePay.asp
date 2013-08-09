<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_product.asp"-->
<!--#include file="../common/api/cls_user.asp"-->
<!--#include file="OnlinePaycode.asp"-->
<!--#include file="YeePay/yeepayCommon.asp"-->
<!--#include file="../common/api/cls_tpl.asp"-->
<!--#include file="../common/api/cls_sms.asp"-->
<!--#include file="../common/api/cls_xml.asp"-->
<%
Server.ScriptTimeout=20
On Error Resume Next
Dim  PayResult
%>

<%

	'	只有支付成功时易宝支付才会通知商户.
	''支付成功回调有两次，都会通知到在线支付请求参数中的p8_Url 上：浏览器重定向;服务器点对点通讯.
	Dim product_id
	Dim r0_Cmd
	Dim r1_Code
	Dim r2_TrxId
	Dim r3_Amt
	Dim r4_Cur
	Dim r5_Pid
	Dim r6_Order
	Dim r7_Uid
	Dim r8_MP
	Dim r9_BType
	Dim p_hmac
	
	Dim bRet
	Dim returnMsg
	
	'解析返回参数
	Call getCallBackValue(r0_Cmd,r1_Code,r2_TrxId,r3_Amt,r4_Cur,r5_Pid,r6_Order,r7_Uid,r8_MP,r9_BType,p_hmac)
	'判断返回签名是否正确（True/False）
	
	'response.Write("<br>p_hmac="&p_hmac)

	bRet = CheckHmac(r0_Cmd,r1_Code,r2_TrxId,r3_Amt,r4_Cur,r5_Pid,r6_Order,r7_Uid,r8_MP,r9_BType,p_hmac)
	'以上代码和变量不需要修改.

	OnlineNumber=r2_TrxId'订单流水账号
	total_fee=r3_Amt'订单金额
	out_trade_no=r6_Order'订单号
	
	'response.Write("<br>bret="&bRet)
	'OnlineNumber="abcdefgh1"'订单流水账号
	'total_fee=0.1 '订单金额
	'out_trade_no="6" '订单号
	'r9_BType = "1"
	'bRet = false
	'r1_Code = "1"
	
	'校验码正确
	returnMsg	= ""
	If Err<>0 Then
		Response.Write "易宝返回出错信息:"&Err.Description
		Response.End()
	End If
	If bRet = True Then
	  If(r1_Code="1") Then
		'需要比较返回的金额与商家数据库中订单的金额是否相等，只有相等的情况下才认为是交易成功.
		'并且需要对返回的处理进行事务控制，进行记录的排它性处理，防止对同一条交易重复发货的情况发生.	  	      	  
			If(r9_BType="1") Then
				'	在线支付页面返回
				SetOrderState out_trade_no,"yeepay",OnlineNumber,CDBL(r3_Amt)
				Set tRs = Dream3product.GetOrderByOrderNo(out_trade_no)
				UpdateProductState(tRs("product_id"))
				response.Write("success")
				returnMsg	= "支付成功！"
				PayResult = "success"
			ElseIf(r9_BType="2") Then				
	  		'	如果需要应答机制则必须回写以"success"开头的stream,大小写不敏感.
	  		''易宝支付收到该stream，便认为商户已收到；否则将继续发送通知，直到商户收到为止。
				SetOrderState out_trade_no,"yeepay",OnlineNumber,CDBL(r3_Amt)
		 		Set tRs = Dream3product.GetOrderByOrderNo(out_trade_no)
				UpdateProductState(tRs("product_id"))
				response.Write("success")
				PayResult = "success"
				Call createLog("HTMLcommon")
				returnMsg	= "支付成功"
				'returnMsg	= returnMsg	& "在线支付返回"				
			ElseIf(r9_BType="3") Then
				returnMsg	= returnMsg	&	"电话支付通知页面返回"
			End IF  
	  End IF
	Else
		returnMsg	= returnMsg	&	"交易信息被篡改"
		PayResult = "error"
	End If

'callback在线支付服务器返回，服务器点对点通讯
'写入 onLine.log 这里用来调试接口
Sub createLog(ByRef returnMsg)
    filename = "./" & returnMsg & ".log"
    content = now()		&	","							&	request.ServerVariables("REMOTE_ADDR")
    content = content &	","							&	returnMsg
    content = content &	",商户订单号:"	& r6_Order
    content = content &	",支付金额:"		& r3_Amt
    content = content &	",签名数据:"		& p_hmac
    
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
<title>易宝支付 - <%=Dream3CLS.SiteConfig("SiteName")%></title>
<meta name="description" content="<%=Dream3CLS.SiteConfig("MetaDescription")%>">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
</head>
	<body>
    	<%=returnMsg%>,请关闭此页面并回到支付页面完成操作！
	</body>
</html>