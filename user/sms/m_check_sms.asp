<!--#include file="../../conn.asp"-->
<%
' ����Ӹ���·���
reg_code=ConvertHTML(request("reg_code")) '��֤��
t_no=ConvertHTML(request("t_no")) '�ֻ�����

back_z="n" 'Ĭ��Ϊʧ��ֵ
session("r_no")="" '����

if len(t_no)<>11 and  IsNum_pro(t_no)=false then '�����֤���д�ʱ
	response.Write "n" '����ʧ��ֵ
	response.End
end if

if len(reg_code)<>4 and IsNum_pro(reg_code)=false then '����ֻ������д�ʱ
	response.Write "n" '����ʧ��ֵ
	response.End
end if

call mdb_name(user_mdb) '��SMS���ݿ�

sql="select * from sms where t_no='"&t_no&"' order by id desc " 'ֻ����ú������һ�ε���֤��
ps.open sql,comm,1,1
if ps.recordcount<>0 then
	if ps("r_no1")=reg_code then '��֤��
		back_z="y" '�ɹ�ֵ
		session("r_no")=reg_code '�洢��֤��
	end if
end if
ps.close	
set ps=nothing
comm.close
set comm=nothing
response.Write back_z '���ֵ
%>