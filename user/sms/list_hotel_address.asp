<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->

<table width=200 align=center border=1>
<tr>
<th>ID</th>
<th>µØÖ·</th>
</tr><%

Sql = "select * from T_hotel" 
Set Rs = Dream3CLS.Exec(Sql)
	do while not rs.eof
%>

<tr>
<td><%=rs("h_id")%></td>
<td><%=rs("h_address")%></td>
</tr>


<%	rs.movenext 
	loop
	rs.close
%></table>