<%
'------------------------------------------------
'����:	�������HTTP�ӿ�ASP����˵��
'����:	2010-02-08
'״̬:
'------------------------------------------------
%>
 
<%
Sub sendsms(mobile,msg)
'����ֻ���֮���á�,���ָ�
dim userid,password,status
dim xmlObj,httpsendurl
userid = "lzp"		'��ҵID������www.gysoft.cn/smsע��
password = "113507"	'ID����  

httpsendurl="http://www.gysoft.cn/smspost/send.aspx?username="&userid&"&password="&password&"&mobile="&mobile&"&content="&server.URLEncode(msg)

Set xmlObj = server.CreateObject("Microsoft.XMLHTTP")
xmlObj.Open "GET",httpsendurl,false
xmlObj.send()
status = xmlObj.responseText
Set xmlObj = nothing
If left(status,2) = "OK" then '���ͳɹ�  ���ؽ��ΪOK1 ��ʾ�ɹ�����1�� ,OK2��ʾ�ɹ�2�����Դ�����
	Response.Write "<br><br>����״̬�룺"&status&"&nbsp;&nbsp;&nbsp;����״̬�����ͳɹ���&nbsp;&nbsp;&nbsp; <a href=""javascript:history.back();"">���ط���ҳ��</a>"
Else '����ʧ��
	Response.Write "<br><br>����״̬�룺"&status&"&nbsp;&nbsp;&nbsp;����״̬������ʧ�ܣ�&nbsp;&nbsp;&nbsp;<a href=""javascript:history.back();"">���ط���ҳ��</a>"
End if
End sub
%>
