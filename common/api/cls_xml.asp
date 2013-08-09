<%
Class Dream3_XML
	
	Dim S_XMLDOM

	Private Sub Class_Initialize()
		On Error Resume Next
		Set S_XMLDOM=Server.CreateObject("Microsoft.XMLDOM")
	End Sub
	

	
	Function GetValueByTag(s_xml,s_tag)
		S_XMLDOM.loadxml(s_xml)
		s_textStr=S_XMLDOM.documentElement.SelectSingleNode(s_tag).text
		GetValueByTag=s_textStr
	End Function
	
	Private Sub Class_Terminate
		If Err.Number<>995 and Err.Number<>0 then log(""&Err.Source&" ("&Err.Number&")&lt;br&gt;"&Err.Description&"")
		Set XMLDOM = Nothing
	End Sub

End Class

Dim Dream3XML
Set Dream3XML = New Dream3_XML
%>