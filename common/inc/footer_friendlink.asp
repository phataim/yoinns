
 <DIV class="foot02 clearfix">
<DL>
  <DT>”—«È¡¥Ω”:</DT>

  <DD>
  <%
			Sql = "Select sitename,siteurl,logo From T_FriendLink Where 1=1 order by seqno Desc"
			Set Rs = Dream3CLS.Exec(Sql)
			Do While Not Rs.EOF 
			%>
  <a title=<%=Rs("sitename")%> href="<%=Rs("siteurl")%>" target="_blank"><%=Rs("sitename")%></a> 
  <%
				Rs.Movenext
			Loop
			%></DD></DL></DIV>