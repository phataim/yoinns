<%
Class Dream3_Template
	Function  LoadTemplate(TempString) 
	    on error resume next
		
		Dim  Str,A_W
		set A_W=server.CreateObject("adodb.Stream")
		A_W.Type=2 
		A_W.mode=3 
		A_W.charset="gb2312"
		A_W.open
		'response.Write(server.MapPath(Application("G_VirtualPath")&"/templates/"&TempString)&"<br>")
		A_W.loadfromfile server.MapPath(VirtualPath&"/templates/"&TempString&".html")
 		If Err.Number<>0 Then Err.Clear:LoadTemplate="当前模板路径:<font color=red>"&VirtualPath&"</font><br>模板没有找到 <br> by Dream3.cn":Exit Function
		Str=A_W.readtext
		A_W.Close
		Set  A_W=nothing
		LoadTemplate=Str
	End  function
End Class

Dim Dream3Tpl
Set Dream3Tpl = New Dream3_Template
%>
