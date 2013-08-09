<%
	
	Dim p1_MerId
	Dim merchantKey
	Dim merchantCallbackURL
	'设定秘钥，其中正式的merchantID以及秘钥value 需要从YeePay易宝提供给商家的商家自助服务系统获得
	p1_MerId = Trim(Dream3CLS.SiteConfig("YeepayID"))			'测试使用 merchant ID = "1001001"
	merchantKey = Trim(Dream3CLS.SiteConfig("YeepayKey"))				'测试使用 keyValue = "Key"
	merchantCallbackURL = GetSiteUrl&"/onlinepay/return_yeepay.asp"	'用户完成交易完成后, 控制应用返回到商家自己的URL
	'merchantCallbackURL = "http://dream3.cn/slsdemo/onlinepay/return_yeepay.asp"
	logName = "YeePay_HTML"
%>