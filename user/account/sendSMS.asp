<%
'------------------------------------------------
'功能:	国宇短信HTTP接口ASP调用说明
'日期:	2010-02-08
'状态:
'------------------------------------------------
%>
 
<%
Sub sendsms(mobile,msg)
'多个手机号之间用“,”分隔
dim userid,password,status
dim xmlObj,httpsendurl
userid = "lzp"		'企业ID，请在www.gysoft.cn/sms注册
password = "113507"	'ID密码  

httpsendurl="http://www.gysoft.cn/smspost/send.aspx?username="&userid&"&password="&password&"&mobile="&mobile&"&content="&server.URLEncode(msg)

Set xmlObj = server.CreateObject("Microsoft.XMLHTTP")
xmlObj.Open "GET",httpsendurl,false
xmlObj.send()
status = xmlObj.responseText
Set xmlObj = nothing
If left(status,2) = "OK" then '发送成功  返回结果为OK1 表示成功发送1条 ,OK2表示成功2条，以此类推
	Response.Write "<br><br>返回状态码："&status&"&nbsp;&nbsp;&nbsp;发送状态：发送成功！&nbsp;&nbsp;&nbsp; <a href=""javascript:history.back();"">返回发送页面</a>"
Else '发送失败
	Response.Write "<br><br>返回状态码："&status&"&nbsp;&nbsp;&nbsp;发送状态：发送失败！&nbsp;&nbsp;&nbsp;<a href=""javascript:history.back();"">返回发送页面</a>"
End if
End sub
%>
