<!--#include file="m_common.asp"-->
<table width=900 align=center border=1>
<tr>
<th>ID</th>
<th>�绰��</th>
<th>��֤��1</th>
<th>��֤��2</th>
<th>��֤��3</th>
<th>����ID</th>
<th>��������</th>
<th>���Żظ�</th>
<th>��չ��</th>
<th>��ʱʱ��</th>
<th>rrid</th>
<th>����ƽ̨��ִ</th>
<th>ϵͳ��¼ʱ��</th>
</tr>
<%
	sql="select * from [sms] "' ��������ֻ��������һ��, ����Ҫ�ظ����ֻ���
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