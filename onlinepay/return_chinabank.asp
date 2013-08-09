<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_product.asp"-->
<!--#include file="../common/api/cls_user.asp"-->
<!--#include file="OnlinePaycode.asp"-->
<!--#include file="chinabank/chinabank_config.asp"-->
<!--#include file="md5.inc"-->
<!--#include file="chinabank/MD5.asp"-->
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
'****************************************	' MD5密钥要跟订单提交页相同，如Send.asp里的 key = "test" ,修改""号内 test 为您的密钥
											' 如果您还没有设置MD5密钥请登陆我们为您提供商户后台，地址：https://merchant3.chinabank.com.cn/
	
' 登陆后在上面的导航栏里可能找到“B2C”，在二级导航栏里有“MD5密钥设置”
											' 建议您设置一个16位以上的密钥或更高，密钥最多64位，但设置16位已经足够了
'****************************************

' 取得返回参数值
	v_idx = request("v_idx")                             '系统产生的订单号
	v_oid=request("v_oid")                               ' 商户发送的v_oid定单编号
	v_pmode=request("v_pmode")                           ' 支付方式（字符串） 
	v_pstatus=request("v_pstatus")                       ' 支付状态 20（支付成功）;30（支付失败）
	v_pstring=request("v_pstring")                       ' 支付结果信息 支付完成（当v_pstatus=20时）；失败原因（当v_pstatus=30时）；
	v_amount=request("v_amount")                         ' 订单实际支付金额
	v_moneytype=request("v_moneytype")                   ' 订单实际支付币种
	remark1=request("remark1")                           ' 备注字段1
	remark2=request("remark2")                           ' 备注字段2
	v_md5str=request("v_md5str")                         ' 网银在线拼凑的Md5校验串


	If v_md5str = "" then
		returnMsg	= returnMsg	&	"交易信息被篡改，交易失败！"
		PayResult = "error"
		Exit Sub
	End if
	

'md5校验

	text = v_oid&v_pstatus&v_amount&v_moneytype&chinabank_key
	

	md5text =Ucase(trim(ChinabankMD5.md5(text)))    '商户拼凑的Md5校验串
	

	If md5text<>v_md5str then		' 网银在线拼凑的Md5校验串 与 商户拼凑的Md5校验串 进行对比
		'对比失败表示信息非网银在线返回的信息
		returnMsg	= returnMsg	&	"MD5校验失败，交易失败！"
		PayResult = "error"
		Exit Sub
	Else
	'对比成功表示信息是网银在线返回的信息

		if v_pstatus=20 then

		'支付成功
		'此处加入商户系统的逻辑处理（例如判断金额，判断支付状态，更新订单状态等等）......
			SetOrderState v_oid,"chinabank",v_idx,CDBL(v_amount)
			Set tRs = Dream3Product.GetOrderByOrderNo(v_oid)
			UpdateProductState(tRs("product_id"))
			returnMsg	= "支付成功！"
			PayResult = "success"
	   Else
	   	returnMsg	= returnMsg	&	"网银在线内部处理失败，失败代码：！"
		PayResult = "error"
		Exit Sub

	   End if

	End if
End Sub
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>网银在线 - <%=Dream3CLS.SiteConfig("SiteName")%></title>
<meta name="description" content="<%=Dream3CLS.SiteConfig("MetaDescription")%>">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
</head>
	<body>
    	<%=returnMsg%>,请关闭此页面并回到支付页面完成操作！
	</body>
</html>