<%
Rem ==========���ú���=========
dim comm
dim ps
user_mdb="db.mdb" '���ݿ�

Function check_power3(comeclass) '���Ȩ���Ƿ�ͨ�� comeclass:����Ȩ��
	check_power3=true
End Function


Function js_jump(str1,url) '������ʾ str1: ��ʾ�������� url:�վͷ���ԭ����ҳ��,��ֵ��ֵ��ת
	if url="" then
		Response.Write "<script language=JavaScript>" & chr(13) & "alert('"&str1&"');" & "history.back(1)" & "</script>" 
	else
		Response.Write "<script language=JavaScript>" & chr(13) & "alert('"&str1&"');" & "location.href='"&url&"';" & "</script>" 
	end if
	response.end
End Function


Function IsNum_pro(str) '�ܼ������յ���������
	if str="" then
		IsNum_pro=false
	else
		IsNum_pro=IsNumeric(str)
	end if
End Function


Function no_long(aa) '��ֹ�ظ������Ϣ

	'############   ��ֹ�ظ�����
	session("time")=now()
	const atime=#0:0:05# '�������֮�������
	if session("time2") >0 then
		if session("time2")+atime > session("time") then
			session("time2")=now()
			if aa=1 then
				call js_jump("�r(�s_�t)�q ����Ϣ��Ҫ��ô��Ŷ��","")
			else
				response.Write "4"
			end if
			response.end
		end if 
	end if
	session("time2")=now()
	'############
End Function


Function mdb_name(m_n) '�������ݿ�
	set comm=Server.CreateObject("ADODB.Connection")
	comm.open "Provider=Microsoft.JET.OLEDB.4.0;Data Source= "&server.MapPath (m_n)
	Set ps= Server.CreateObject("ADODB.Recordset")
End Function

function ConvertHTML(str) '�����ַ���
	'if IsObject(str) then
		ConvertHTML=trim(str)
		'ConvertHTML=replace(str, "&", "&#38")
		'ConvertHTML=replace(ConvertHTML, ";", "&#59")
		ConvertHTML=replace(ConvertHTML, "(", "��")
		ConvertHTML=replace(ConvertHTML, ")", "��")
		ConvertHTML=replace(ConvertHTML, "<", "��")
		ConvertHTML=replace(ConvertHTML, ">", "��")
		ConvertHTML=replace(ConvertHTML,chr(34), "��")
		ConvertHTML=replace(ConvertHTML,chr(34),"&quot;")
		ConvertHTML=replace(ConvertHTML,chr(39), "&#39")
		ConvertHTML=replace(convertHTML,vbCrLf, "<br />")
'Ҫ���ӹ���%��
		'ConvertHTML=replace(convertHTML," ", "&nbsp;")
		if len(ConvertHTML)< 30 then
			ConvertHTML=replace(ConvertHTML, "	", "______")
		else
			ConvertHTML=replace(ConvertHTML, "	", "&nbsp;&nbsp;")
		end if
		'ConvertHTML=replace(ConvertHTML, "&", "&amp;")
		'ConvertHTML=replace(str, vbCrLf, "<br>")
	'else
	'	ConvertHTML="??"
	'end if
end function



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''



Function Rnd_no(n) '����� , n Ϊ����λ
	Randomize '��ʼ�������
	for i=1 to n
		mn = Int((9 * Rnd) + 1)' ���� 1 �� 6 ֮����������
		tt=mn&tt
	next
	Rnd_no=tt
end function




















%>