<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_product.asp"-->
<!--#include file="../common/api/cls_user.asp"-->
<!--#include file="OnlinePaycode.asp"-->
<!--#include file="chinabank/chinabank_config.asp"-->
<!--#include file="md5.inc"-->
<!--#include file="chinabank/MD5.asp"-->
<!--#include file="../common/api/cls_tpl.asp"-->
<!--#include file="../common/api/cls_sms.asp"-->
<!--#include file="../common/api/cls_xml.asp"-->
<%
Server.ScriptTimeout=20
On Error Resume Next
Dim PayResult
Dim returnMsg
%>

<%   
Call  CommitOrderTrans()

Sub CommitOrderTrans()
	On Error Resume Next
'****************************************	' MD5��ԿҪ�������ύҳ��ͬ����Send.asp��� key = "test" ,�޸�""���� test Ϊ������Կ
											' �������û������MD5��Կ���½����Ϊ���ṩ�̻���̨����ַ��https://merchant3.chinabank.com.cn/
	
' ��½��������ĵ�����������ҵ���B2C�����ڶ������������С�MD5��Կ���á�
											' ����������һ��16λ���ϵ���Կ����ߣ���Կ���64λ��������16λ�Ѿ��㹻��
'****************************************

' ȡ�÷��ز���ֵ
	v_idx = request("v_idx")                             'ϵͳ�����Ķ�����
	v_oid=request("v_oid")                               ' �̻����͵�v_oid�������
	v_pmode=request("v_pmode")                           ' ֧����ʽ���ַ����� 
	v_pstatus=request("v_pstatus")                       ' ֧��״̬ 20��֧���ɹ���;30��֧��ʧ�ܣ�
	v_pstring=request("v_pstring")                       ' ֧�������Ϣ ֧����ɣ���v_pstatus=20ʱ����ʧ��ԭ�򣨵�v_pstatus=30ʱ����
	v_amount=request("v_amount")                         ' ����ʵ��֧�����
	v_moneytype=request("v_moneytype")                   ' ����ʵ��֧������
	remark1=request("remark1")                           ' ��ע�ֶ�1
	remark2=request("remark2")                           ' ��ע�ֶ�2
	v_md5str=request("v_md5str")                         ' ��������ƴ�յ�Md5У�鴮


	If v_md5str = "" then
		returnMsg	= returnMsg	&	"������Ϣ���۸ģ�����ʧ�ܣ�"
		PayResult = "error"
		Exit Sub
	End if
	

'md5У��

	text = v_oid&v_pstatus&v_amount&v_moneytype&chinabank_key
	

	md5text =Ucase(trim(ChinabankMD5.md5(text)))    '�̻�ƴ�յ�Md5У�鴮
	

	If md5text<>v_md5str then		' ��������ƴ�յ�Md5У�鴮 �� �̻�ƴ�յ�Md5У�鴮 ���жԱ�
		'�Ա�ʧ�ܱ�ʾ��Ϣ���������߷��ص���Ϣ
		returnMsg	= returnMsg	&	"MD5У��ʧ�ܣ�����ʧ�ܣ�"
		PayResult = "error"
		Exit Sub
	Else
	'�Աȳɹ���ʾ��Ϣ���������߷��ص���Ϣ

		if v_pstatus=20 then

		'֧���ɹ�
		'�˴������̻�ϵͳ���߼����������жϽ��ж�֧��״̬�����¶���״̬�ȵȣ�......
			SetOrderState v_oid,"chinabank",v_idx,CDBL(v_amount)
			Set tRs = Dream3Product.GetOrderByOrderNo(v_oid)
			UpdateProductState(tRs("product_id"))
			returnMsg	= "֧���ɹ���"
			PayResult = "success"
	   Else
	   	returnMsg	= returnMsg	&	"���������ڲ�����ʧ�ܣ�ʧ�ܴ��룺��"
		PayResult = "error"
		Exit Sub

	   End if

	End if
End Sub
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�������� - <%=Dream3CLS.SiteConfig("SiteName")%></title>
<meta name="description" content="<%=Dream3CLS.SiteConfig("MetaDescription")%>">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
</head>
	<body>
    	<%=returnMsg%>,��رմ�ҳ�沢�ص�֧��ҳ����ɲ�����
	</body>
</html>