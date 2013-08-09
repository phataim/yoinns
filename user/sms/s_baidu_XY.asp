<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->

<table width=200 align=center border=1>
<tr>
<th>ID</th>
<th>X</th>
<th>Y</th>
</tr><%

Sql = "select * from T_hotel" 
	Rs.open Sql,conn,1,3
	do while not rs.eof
%>

<tr>
<td><%=rs("h_id")%></td>
<td><%=rs("h_mapx")%></td>
<td><%=rs("h_mapy")%></td>
</tr>


<%	rs.movenext 
	loop
	rs.close
%></table>
<hr>
转换前
<hr />
<%

Sql = "select * from T_hotel" 
	Rs.open Sql,conn,1,3
	do while not rs.eof

		'map_x = "" '百度坐标 x mike
		'map_y = "23.057637" '百度坐标 y mike

rs("h_mapx")="113.400961"
rs("h_mapy")="23.057637"

	rs.update
	rs.movenext 
	loop
	rs.close
%>
<hr>
转换后
<hr>
<table width=200 align=center border=1>
<tr>
<th>ID</th>
<th>X</th>
<th>Y</th>
</tr><%

Sql = "select * from T_hotel" 
	Rs.open Sql,conn,1,3
	do while not rs.eof
%>

<tr>
<td><%=rs("h_id")%></td>
<td><%=rs("h_mapx")%></td>
<td><%=rs("h_mapy")%></td>
</tr>


<%	rs.movenext 
	loop
	rs.close
%></table>









