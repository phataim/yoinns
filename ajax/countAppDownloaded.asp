<!--#include file="../common/api/cls_Main.asp"-->
<%
	Dim ipAddress
	ipAddress =  Dream3CLS.RParam("m_data")
	response.write (ipAddress)
	Call ReadFiles()
	
	Sub ReadFiles()
	  Dim fso, f1, ts, s ,readTotalNumSet
	  Const ForReading = 1
	  Set fso = CreateObject("Scripting.FileSystemObject")

	'  Set f1 = fso.CreateTextFile(server.mappath("../appDownloadLog.txt"), True)
	  ' 写一行。
	'  f1.WriteLine "AppDownLoaded"
	'  f1.WriteBlankLines(1)
	'  f1.Close
	
	
	  ' 读取文件的内容。
	
	  Response.Write "Reading file "
	  Set ts = fso.OpenTextFile(server.mappath("../appDownloadLog.txt"), 8 , True)
	  
	    
		ts.write("downloadTime::"&date&" "&Time&"::")
		ts.Write("userIp::"&ipAddress&"::")
		
		If not Session("_UserName") = "" then 
		ts.Write("user::"&Session("_UserName") )
		end if 
		
		ts.WriteLine("")
	  ts.Close
	End Sub
	
	'通过ip138获得客户机的ip地址并存储
	
	'无用代码
	Function GetWanIP()  
		Dim nPos
		Dim objXmlHTTP
		
		GetWanIP = ""
		On Error Resume Next
		'创建XMLHTTP对象
		Set objXmlHTTP = CreateObject("MSXML2.XMLHTTP")
		
		'导航至http://www.ip138.com/ip2city.asp获得IP地址
		objXmlHTTP.open "GET", "http://iframe.ip138.com/ic.asp", False
		objXmlHTTP.send
		
		'提取HTML中的IP地址字符串
		nPos = InStr(objXmlHTTP.responseText, "[")
		If nPos > 0 Then
			GetWanIP = Mid(objXmlHTTP.responseText, nPos + 1)
			nPos = InStr(GetWanIP, "]")
			If nPos > 0 Then GetWanIP = Trim(Left(GetWanIP, nPos - 1))
		End If
		
		'销毁XMLHTTP对象
		Set objXmlHTTP = Nothing
	End Function 
	

%>
