<%
'账号
chinabank_ID         = Dream3CLS.SiteConfig("ChinaBankID")  '8位的账号 
'用户名
chinabank_Account   		=  Dream3CLS.SiteConfig("ChinaBankAccount")
'密钥
chinabank_key   		=  Dream3CLS.SiteConfig("ChinaBankKey")


'付完款后跳转的页面 要用 http://格式的完整路径
chinabank_return_url      = GetSiteUrl&"/onlinepay/return_chinabank.asp"

%>