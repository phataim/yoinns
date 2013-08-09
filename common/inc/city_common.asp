<%
Sub GetDisplayCity(prefix)
	dim str
	dim hotsql
	str = ""
	select case prefix
		case "A"
			str= "'A','B','C','D','E','F'"
		case "G"
			str= "'G','H','I','J','K','L'"
		case "M"
			str= "'M','N','O','P','Q','R'"
		case "S"
			str= "'S','T','U','V','W','X','Y','Z'"
		case else
			hotsql = " and  hotflag = 'Y' and (depth=2 or (depth=1 and zxs=1)) "
	End select 
	
	if str <> "" Then
		Sql = "Select cityname,citypostcode from T_City Where 1=1 and  cityprefix in("&str&") and (depth = 2 or zxs = 1)  "
	else
		Sql = "Select cityname,citypostcode from T_City Where 1=1  " & hotsql
	end if
	sql = sql + " and enabled = 1 Order By citypostcode"

	Set hCityRs = Dream3CLS.Exec(Sql)
	If Not hCityRs.EOF Then
	hCityRs.MoveFirst
	Do While Not hCityRs.EOF 
	%>
		<div class="center_a">
		<a onclick="setCity('<%=hCityRs("citypostcode")%>','<%=hCityRs("cityname")%>')" href="###"><%=hCityRs("cityname")%></a>
		</div>
	<%
		hCityRs.Movenext
	Loop
	End If

End Sub
%>