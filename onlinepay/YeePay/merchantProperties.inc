<%
	
	Dim p1_MerId
	Dim merchantKey
	Dim merchantCallbackURL
	'�趨��Կ��������ʽ��merchantID�Լ���Կvalue ��Ҫ��YeePay�ױ��ṩ���̼ҵ��̼���������ϵͳ���
	p1_MerId = Trim(Dream3CLS.SiteConfig("YeepayID"))			'����ʹ�� merchant ID = "1001001"
	merchantKey = Trim(Dream3CLS.SiteConfig("YeepayKey"))				'����ʹ�� keyValue = "Key"
	merchantCallbackURL = GetSiteUrl&"/onlinepay/return_yeepay.asp"	'�û���ɽ�����ɺ�, ����Ӧ�÷��ص��̼��Լ���URL
	'merchantCallbackURL = "http://dream3.cn/slsdemo/onlinepay/return_yeepay.asp"
	logName = "YeePay_HTML"
%>