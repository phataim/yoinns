<!--#include file="m_md5.asp"-->
<%
url="http://117.79.237.3:8060/webservice.asmx"
host="117.79.237.3"
'sn="SDK-TTS-010-05227"
'password="458957"
'sn="SDK-TTS-010-05321"
'password="343418"
sn="SDK-WSS-010-02126"
password="493051"



pwd=MD5(sn & password)

function SendSMS(mobile,content)
	
	SoapRequest="<?xml version="&CHR(34)&"1.0"&CHR(34)&" encoding="&CHR(34)&"utf-8"&CHR(34)&"?>"& _
	"<soap:Envelope xmlns:xsi="&CHR(34)&"http://www.w3.org/2001/XMLSchema-instance"&CHR(34)&" "& _
	"xmlns:xsd="&CHR(34)&"http://www.w3.org/2001/XMLSchema"&CHR(34)&" "& _
	"xmlns:soap="&CHR(34)&"http://schemas.xmlsoap.org/soap/envelope/"&CHR(34)&">"& _
	"<soap:Body>"& _
	
	"<SendSMS xmlns="&CHR(34)&"http://tempuri.org/"&CHR(34)&">"& _
	"<sn>"&sn&"</sn>"& _
	"<pwd>"&password&"</pwd>"& _
	"<mobile>"&mobile&"</mobile>"& _
	"<content>"&content&"</content>"& _
	
	"</SendSMS>"& _
	
	"</soap:Body>"& _
	"</soap:Envelope>"
	
	Set xmlhttp = server.CreateObject("Msxml2.XMLHTTP")
	xmlhttp.Open "POST",url,false
	xmlhttp.setRequestHeader "Content-Type", "text/xml;charset=utf-8"
	xmlhttp.setRequestHeader "HOST",host
	xmlhttp.setRequestHeader "Content-Length",LEN(SoapRequest)
	xmlhttp.setRequestHeader "SOAPAction", "http://tempuri.org/SendSMS" 
	xmlhttp.Send(SoapRequest)	
	If xmlhttp.Status = 200 Then
	
	Set xmlDOC = server.CreateObject("MSXML.DOMDocument")
	xmlDOC.load(xmlhttp.responseXML)
	SendSMS=xmlDOC.documentElement.selectNodes("//SendSMSResult")(0).text
	Set xmlDOC = nothing
	
	Else
	
	SendSMS=xmlhttp.Status&"&nbsp;"&xmlhttp.StatusText
	
	
	End if
	
	Set xmlhttp = Nothing
	
	
END function
'--------------------------------------
'获取余额
'--------------------------------------
function getBalance()
	SoapRequest="<?xml version="&CHR(34)&"1.0"&CHR(34)&" encoding="&CHR(34)&"utf-8"&CHR(34)&"?>"& _
	"<soap:Envelope xmlns:xsi="&CHR(34)&"http://www.w3.org/2001/XMLSchema-instance"&CHR(34)&" "& _
	"xmlns:xsd="&CHR(34)&"http://www.w3.org/2001/XMLSchema"&CHR(34)&" "& _
	"xmlns:soap="&CHR(34)&"http://schemas.xmlsoap.org/soap/envelope/"&CHR(34)&">"& _
	"<soap:Body>"& _
	"<balance xmlns="&CHR(34)&"http://tempuri.org/"&CHR(34)&">"& _
	"<sn>"&sn&"</sn>"& _
	"<pwd>"&pwd&"</pwd>"& _
	"</balance>"& _
	"</soap:Body>"& _
	"</soap:Envelope>"
	
	Set xmlhttp = server.CreateObject("Msxml2.XMLHTTP")
	xmlhttp.Open "POST",url,false
	xmlhttp.setRequestHeader "Content-Type", "text/xml;charset=utf-8"
	xmlhttp.setRequestHeader "HOST",host
	xmlhttp.setRequestHeader "Content-Length",LEN(SoapRequest)
	xmlhttp.setRequestHeader "SOAPAction", "http://tempuri.org/balance"
	xmlhttp.Send(SoapRequest)
	If xmlhttp.Status = 200 Then
	
	Set xmlDOC = server.CreateObject("MSXML.DOMDocument")
	xmlDOC.load(xmlhttp.responseXML)
	getBalance=xmlDOC.documentElement.selectNodes("//balanceResult")(0).text
	Set xmlDOC = nothing
	
	Else
	
	getBalance=xmlhttp.Status&"&nbsp;"&xmlhttp.StatusText
	
	
	End if
	
	Set xmlhttp = Nothing
end function


'--------------------------------------
'发送短信
'参数：mobile 手机，content 内容，ext 扩展码，stime 定时时间，rrid 唯一标识如为空系统返回
'--------------------------------------
function mt(mobile,content,ext,stime,rrid)
	SoapRequest="<?xml version="&CHR(34)&"1.0"&CHR(34)&" encoding="&CHR(34)&"utf-8"&CHR(34)&"?>"& _
	"<soap:Envelope xmlns:xsi="&CHR(34)&"http://www.w3.org/2001/XMLSchema-instance"&CHR(34)&" "& _
	"xmlns:xsd="&CHR(34)&"http://www.w3.org/2001/XMLSchema"&CHR(34)&" "& _
	"xmlns:soap="&CHR(34)&"http://schemas.xmlsoap.org/soap/envelope/"&CHR(34)&">"& _
	"<soap:Body>"& _
	"<mt xmlns="&CHR(34)&"http://tempuri.org/"&CHR(34)&">"& _
	"<sn>"&sn&"</sn>"& _
	"<pwd>"&pwd&"</pwd>"& _
	"<mobile>"&mobile&"</mobile>"& _
	"<content>"&content&"</content>"& _
	"<ext>"&ext&"</ext>"& _
	"<stime>"&stime&"</stime>"& _
	"<rrid>"&rrid&"</rrid>"& _
	"</mt>"& _
	"</soap:Body>"& _
	"</soap:Envelope>"
	
	Set xmlhttp = server.CreateObject("Msxml2.XMLHTTP")
	xmlhttp.Open "POST",url,false
	xmlhttp.setRequestHeader "Content-Type", "text/xml;charset=utf-8"
	xmlhttp.setRequestHeader "HOST",host
	xmlhttp.setRequestHeader "Content-Length",LEN(SoapRequest)
	xmlhttp.setRequestHeader "SOAPAction", "http://tempuri.org/mt"
	xmlhttp.Send(SoapRequest)
	If xmlhttp.Status = 200 Then
	
	Set xmlDOC = server.CreateObject("MSXML.DOMDocument")
	xmlDOC.load(xmlhttp.responseXML)

	mt=xmlDOC.documentElement.selectNodes("//mtResult")(0).text
	Set xmlDOC = nothing
	
	Else
	
	mt=xmlhttp.Status&"&nbsp;"&xmlhttp.StatusText	

	End if
	
	Set xmlhttp = Nothing
end function
'--------------------------------------
'接收短信
'--------------------------------------
function mo()
	SoapRequest="<?xml version="&CHR(34)&"1.0"&CHR(34)&" encoding="&CHR(34)&"utf-8"&CHR(34)&"?>"& _
	"<soap:Envelope xmlns:xsi="&CHR(34)&"http://www.w3.org/2001/XMLSchema-instance"&CHR(34)&" "& _
	"xmlns:xsd="&CHR(34)&"http://www.w3.org/2001/XMLSchema"&CHR(34)&" "& _
	"xmlns:soap="&CHR(34)&"http://schemas.xmlsoap.org/soap/envelope/"&CHR(34)&">"& _
	"<soap:Body>"& _
	"<mo xmlns="&CHR(34)&"http://tempuri.org/"&CHR(34)&">"& _
	"<sn>"&sn&"</sn>"& _
	"<pwd>"&pwd&"</pwd>"& _
	"</mo>"& _
	"</soap:Body>"& _
	"</soap:Envelope>"
	
	Set xmlhttp = server.CreateObject("Msxml2.XMLHTTP")
	xmlhttp.Open "POST",url,false
	xmlhttp.setRequestHeader "Content-Type", "text/xml;charset=utf-8"
	xmlhttp.setRequestHeader "HOST",host
	xmlhttp.setRequestHeader "Content-Length",LEN(SoapRequest)
	xmlhttp.setRequestHeader "SOAPAction", "http://tempuri.org/mo"
	xmlhttp.Send(SoapRequest)
	If xmlhttp.Status = 200 Then
	
		Set xmlDOC = server.CreateObject("MSXML.DOMDocument")
	xmlDOC.load(xmlhttp.responseXML)
	mo=xmlDOC.documentElement.selectNodes("//moResult")(0).text
	Set xmlDOC = nothing
	
	Else
	
	mo=xmlhttp.Status&"&nbsp;"&xmlhttp.StatusText
	
	
	End if
	
	Set xmlhttp = Nothing
end function

function report(maxid)
	SoapRequest="<?xml version="&CHR(34)&"1.0"&CHR(34)&" encoding="&CHR(34)&"utf-8"&CHR(34)&"?>"& _
	"<soap:Envelope xmlns:xsi="&CHR(34)&"http://www.w3.org/2001/XMLSchema-instance"&CHR(34)&" "& _
	"xmlns:xsd="&CHR(34)&"http://www.w3.org/2001/XMLSchema"&CHR(34)&" "& _
	"xmlns:soap="&CHR(34)&"http://schemas.xmlsoap.org/soap/envelope/"&CHR(34)&">"& _
	"<soap:Body>"& _
	"<report xmlns="&CHR(34)&"http://tempuri.org/"&CHR(34)&">"& _
	"<sn>"&sn&"</sn>"& _
	"<pwd>"&pwd&"</pwd>"& _
	"<maxid>"&maxid&"</maxid>"& _
	"</report>"& _
	"</soap:Body>"& _
	"</soap:Envelope>"
	
	Set xmlhttp = server.CreateObject("Msxml2.XMLHTTP")
	xmlhttp.Open "POST",url,false
	xmlhttp.setRequestHeader "Content-Type", "text/xml;charset=utf-8"
	xmlhttp.setRequestHeader "HOST",host
	xmlhttp.setRequestHeader "Content-Length",LEN(SoapRequest)
	xmlhttp.setRequestHeader "SOAPAction", "http://tempuri.org/report"
	xmlhttp.Send(SoapRequest)
	If xmlhttp.Status = 200 Then
	
	Set xmlDOC = server.CreateObject("MSXML.DOMDocument")
	xmlDOC.load(xmlhttp.responseXML)
	report=xmlDOC.documentElement.selectNodes("//reportResult")(0).text
	Set xmlDOC = nothing
	
	Else
	
	report=xmlhttp.Status&"&nbsp;"&xmlhttp.StatusText
	
	
	End if
	
	Set xmlhttp = Nothing
end function

%>