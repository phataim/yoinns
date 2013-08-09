<!--#include file="m_common.asp"-->
<table width=900 align=center border=1>
<tr>
<th>ID</th>
<th>电话号</th>
<th>验证码1</th>
<th>验证码2</th>
<th>验证码3</th>
<th>类型ID</th>
<th>类型名字</th>
<th>短信回复</th>
<th>扩展码</th>
<th>定时时间</th>
<th>rrid</th>
<th>短信平台回执</th>
<th>系统记录时间</th>
</tr>
<%
	sql="select * from [sms] "' 先排序该手机号与接收一致, 并需要回复的手机号
	call mdb_name(user_mdb)

	sql="select * from sms order by id desc"
	ps.open sql,comm,1,1
	num=0

	do while not ps.eof
	
%>
<tr>
<td><%=ps("id")%></td>
<td><%=ps("t_no")%></td>
<td><%=ps("r_no1")%></td>
<td><%=ps("r_no2")%></td>
<td><%=ps("r_no3")%></td>
<td><%=ps("sort_id")%></td>
<td><%=ps("sort_name")%></td>
<td><%=ps("is_back")%></td>
<td><%=ps("ext")%></td>
<td><%=ps("stime")%></td>
<td><%=ps("rrid")%></td>
<td><%=ps("mt")%></td>
<td><%=ps("send_time")%></td>

</tr>
	<%
num=num+1
	ps.movenext 
	loop
	ps.close
%></table>