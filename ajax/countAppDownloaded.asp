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
	  ' дһ�С�
	'  f1.WriteLine "AppDownLoaded"
	'  f1.WriteBlankLines(1)
	'  f1.Close
	
	
	  ' ��ȡ�ļ������ݡ�
	
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
	
	'ͨ��ip138��ÿͻ�����ip��ַ���洢
	
	'���ô���
	Function GetWanIP()  
		Dim nPos
		Dim objXmlHTTP
		
		GetWanIP = ""
		On Error Resume Next
		'����XMLHTTP����
		Set objXmlHTTP = CreateObject("MSXML2.XMLHTTP")
		
		'������http://www.ip138.com/ip2city.asp���IP��ַ
		objXmlHTTP.open "GET", "http://iframe.ip138.com/ic.asp", False
		objXmlHTTP.send
		
		'��ȡHTML�е�IP��ַ�ַ���
		nPos = InStr(objXmlHTTP.responseText, "[")
		If nPos > 0 Then
			GetWanIP = Mid(objXmlHTTP.responseText, nPos + 1)
			nPos = InStr(GetWanIP, "]")
			If nPos > 0 Then GetWanIP = Trim(Left(GetWanIP, nPos - 1))
		End If
		
		'����XMLHTTP����
		Set objXmlHTTP = Nothing
	End Function 
	

%>
