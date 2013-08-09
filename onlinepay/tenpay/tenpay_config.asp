<%
'账号
tenpay_ID         = Dream3CLS.SiteConfig("TenpayID")  
'用户名
'tenpay_Account   		=  Dream3CLS.SiteConfig("TenpayAccount")
'密钥
tenpay_key   		=  Dream3CLS.SiteConfig("TenpayKey")


'付完款后跳转的页面 要用 http://格式的完整路径
tenpay_return_url      = GetSiteUrl&"/onlinepay/return_tenpay.asp"

%>