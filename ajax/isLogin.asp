<%
Dim outStr
outStr = "{""userID"":"""+CStr(Session("_UserID"))+"""}"
response.Write(outStr)
%>
