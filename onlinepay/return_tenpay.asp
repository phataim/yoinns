<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_product.asp"-->
<!--#include file="../common/api/cls_user.asp"-->
<!--#include file="OnlinePaycode.asp"-->
<!--#include file="tenpay/tenpay_config.asp"-->
<!--#include file="tenpay/md5.asp"-->
<!--#include file="tenpay/tenpay_util.asp"-->
<!--#include file="tenpay/PayRequestHandler.asp"-->
<!--#include file="tenpay/PayResponseHandler.asp"-->
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
	
	Dim resHandler
	Set resHandler = new PayResponseHandler
	resHandler.setKey(tenpay_key)
	
	'�ж�ǩ��
	If resHandler.isTenpaySign() = True Then
		
		Dim transaction_id
		Dim total_fee
	
		'���׵���
		transaction_id = resHandler.getParameter("transaction_id")
		sp_billno = resHandler.getParameter("sp_billno")'������
	
		'��Ʒ���,�Է�Ϊ��λ
		total_fee = resHandler.getParameter("total_fee")
		total_fee = CDBL(total_fee) / 100 
		
		
		'֧�����
		pay_result = resHandler.getParameter("pay_result")
		
		If "0" = pay_result Then
		
			'֧���ɹ�
		    '�˴������̻�ϵͳ���߼����������жϽ��ж�֧��״̬�����¶���״̬�ȵȣ�......

			SetOrderState sp_billno,"tenpay",transaction_id,total_fee
			Set tRs = Dream3product.GetOrderByOrderNo(sp_billno)
			UpdateproductState(tRs("product_id"))
			returnMsg	= "֧���ɹ���"
			PayResult = "success"
		
		Else
			'�������ɹ�����
			'Response.Write("֧��ʧ��")
			returnMsg	= returnMsg	&	"֧��ʧ�ܣ�"
			PayResult = "error"
			Exit Sub
		End If	
	
	Else
	
		'ǩ��ʧ��
		'Response.Write("ǩ��ǩ֤ʧ��")
	
		returnMsg	= returnMsg	&	"ǩ��ǩ֤ʧ�ܣ�"
		PayResult = "error"
		Exit Sub
	
	End If

	   
End Sub
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�Ƹ�ͨ - <%=Dream3CLS.SiteConfig("SiteName")%></title>
<meta name="description" content="<%=Dream3CLS.SiteConfig("MetaDescription")%>">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
</head>
	<body>
    	<%=returnMsg%>,��رմ�ҳ�沢�ص�֧��ҳ����ɲ�����
	</body>
</html>