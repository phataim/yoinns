<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="m_codepublic.asp"-->

<%
' ����Ӹ���·���
call no_long(2) '��ֹ��������
s_time=60 '�������֮���ʱ�� 60��

t_no=ConvertHTML(request("t_no")) '�ֻ�����
sort=ConvertHTML(request("sort")) '��֤��Դ

if len(t_no)<>11 and  IsNum_pro(t_no)=false then '����ֻ������д�ʱ
	response.Write "1" '����ʧ��ֵ
	response.End
end if

if sort="" then 'ע���û�ʱ

	Sql = "select id from T_User Where mobile='"&t_no&"'" '����ֻ��Ƿ��Ѵ��� 
	Set Rs = Dream3CLS.Exec(Sql)
	If Not Rs.EOF Then
		response.Write "3" '����ʧ��ֵ
		response.End
	End If
	
	r_no1=Rnd_no(4) '��Ҫ4λ�����
	
	ext=""
	stime=""
	rrid=""
	
	text_r_no1="��ӭʹ��[���ù�]���ŷ���, ������֤���� "&r_no1&" ,����ҳ����ȷ��д�����֤, лл!�����ùݡ�"
	sort_name="reg"
elseif sort=1 then '��������ʱ

	Sql = "select id from T_User Where mobile='"&t_no&"'" '����ֻ��Ƿ���� 
	rs.open sql,conn,1,1
	if rs.recordcount=0 then '�Ҳ�����¼
		response.Write "3" '����ʧ��ֵ
		response.End
	end if 
	
	r_no1=Rnd_no(6) '��Ҫ6λ�����
	
	ext=""
	stime=""
	rrid=""
	
	text_r_no1="��ӭʹ��[���ù�]���ŷ���, ������֤���� "&r_no1&" ,����ҳ����ȷ��д�����֤, лл!�����ùݡ�"
	sort_name="forgetPW"
end if

call mdb_name(user_mdb) '��SMS���ݿ�

sql="select * from sms where t_no='"&t_no&"' order by id desc " 'ֻ����ú������һ�ε���֤��
ps.open sql,comm,1,1
if ps.recordcount<>0 then
	send_time=ps("send_time")
	aa=datediff("s",send_time, now())  ' n, �� ,С
	if aa<s_time then  'С�ڹ涨ʱ����
		response.Write "2" '����ʧ��ֵ
		response.End
	end if
end if
ps.close	

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''				
if sms_open=0 then
	at=mt(t_no,text_r_no1,ext,stime,rrid) '��Զ�̵�ַ������
	session("r_no")=r_no1
end if
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

sql="select * from sms"
ps.open sql,comm,1,3
ps.addnew
	ps("r_no1")=r_no1 '��֤��
	ps("t_no")=t_no '�ֻ���
	ps("mt")=at '���ŷ���������ֵ
	ps("sort_name")=sort_name '
ps.update
ps.close	
set ps=nothing
comm.close
set comm=nothing 
response.Write "0" '���سɹ�ֵ









%>