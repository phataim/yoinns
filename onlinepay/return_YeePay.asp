<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_product.asp"-->
<!--#include file="../common/api/cls_user.asp"-->
<!--#include file="OnlinePaycode.asp"-->
<!--#include file="YeePay/yeepayCommon.asp"-->
<!--#include file="../common/api/cls_tpl.asp"-->
<!--#include file="../common/api/cls_sms.asp"-->
<!--#include file="../common/api/cls_xml.asp"-->
<%
Server.ScriptTimeout=20
On Error Resume Next
Dim  PayResult
%>

<%

	'	ֻ��֧���ɹ�ʱ�ױ�֧���Ż�֪ͨ�̻�.
	''֧���ɹ��ص������Σ�����֪ͨ������֧����������е�p8_Url �ϣ�������ض���;��������Ե�ͨѶ.
	Dim product_id
	Dim r0_Cmd
	Dim r1_Code
	Dim r2_TrxId
	Dim r3_Amt
	Dim r4_Cur
	Dim r5_Pid
	Dim r6_Order
	Dim r7_Uid
	Dim r8_MP
	Dim r9_BType
	Dim p_hmac
	
	Dim bRet
	Dim returnMsg
	
	'�������ز���
	Call getCallBackValue(r0_Cmd,r1_Code,r2_TrxId,r3_Amt,r4_Cur,r5_Pid,r6_Order,r7_Uid,r8_MP,r9_BType,p_hmac)
	'�жϷ���ǩ���Ƿ���ȷ��True/False��
	
	'response.Write("<br>p_hmac="&p_hmac)

	bRet = CheckHmac(r0_Cmd,r1_Code,r2_TrxId,r3_Amt,r4_Cur,r5_Pid,r6_Order,r7_Uid,r8_MP,r9_BType,p_hmac)
	'���ϴ���ͱ�������Ҫ�޸�.

	OnlineNumber=r2_TrxId'������ˮ�˺�
	total_fee=r3_Amt'�������
	out_trade_no=r6_Order'������
	
	'response.Write("<br>bret="&bRet)
	'OnlineNumber="abcdefgh1"'������ˮ�˺�
	'total_fee=0.1 '�������
	'out_trade_no="6" '������
	'r9_BType = "1"
	'bRet = false
	'r1_Code = "1"
	
	'У������ȷ
	returnMsg	= ""
	If Err<>0 Then
		Response.Write "�ױ����س�����Ϣ:"&Err.Description
		Response.End()
	End If
	If bRet = True Then
	  If(r1_Code="1") Then
		'��Ҫ�ȽϷ��صĽ�����̼����ݿ��ж����Ľ���Ƿ���ȣ�ֻ����ȵ�����²���Ϊ�ǽ��׳ɹ�.
		'������Ҫ�Է��صĴ������������ƣ����м�¼�������Դ�����ֹ��ͬһ�������ظ��������������.	  	      	  
			If(r9_BType="1") Then
				'	����֧��ҳ�淵��
				SetOrderState out_trade_no,"yeepay",OnlineNumber,CDBL(r3_Amt)
				Set tRs = Dream3product.GetOrderByOrderNo(out_trade_no)
				UpdateProductState(tRs("product_id"))
				response.Write("success")
				returnMsg	= "֧���ɹ���"
				PayResult = "success"
			ElseIf(r9_BType="2") Then				
	  		'	�����ҪӦ�����������д��"success"��ͷ��stream,��Сд������.
	  		''�ױ�֧���յ���stream������Ϊ�̻����յ������򽫼�������֪ͨ��ֱ���̻��յ�Ϊֹ��
				SetOrderState out_trade_no,"yeepay",OnlineNumber,CDBL(r3_Amt)
		 		Set tRs = Dream3product.GetOrderByOrderNo(out_trade_no)
				UpdateProductState(tRs("product_id"))
				response.Write("success")
				PayResult = "success"
				Call createLog("HTMLcommon")
				returnMsg	= "֧���ɹ�"
				'returnMsg	= returnMsg	& "����֧������"				
			ElseIf(r9_BType="3") Then
				returnMsg	= returnMsg	&	"�绰֧��֪ͨҳ�淵��"
			End IF  
	  End IF
	Else
		returnMsg	= returnMsg	&	"������Ϣ���۸�"
		PayResult = "error"
	End If

'callback����֧�����������أ���������Ե�ͨѶ
'д�� onLine.log �����������Խӿ�
Sub createLog(ByRef returnMsg)
    filename = "./" & returnMsg & ".log"
    content = now()		&	","							&	request.ServerVariables("REMOTE_ADDR")
    content = content &	","							&	returnMsg
    content = content &	",�̻�������:"	& r6_Order
    content = content &	",֧�����:"		& r3_Amt
    content = content &	",ǩ������:"		& p_hmac
    
    Set FSO = Server.CreateObject("Scripting.FileSystemObject")   
    Set TS = FSO.OpenTextFile(Server.MapPath(filename),8,true) 
    TS.write content   
    TS.Writeline ""
    TS.Writeline ""
    Set TS = Nothing   
    Set FSO = Nothing   
End Sub

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�ױ�֧�� - <%=Dream3CLS.SiteConfig("SiteName")%></title>
<meta name="description" content="<%=Dream3CLS.SiteConfig("MetaDescription")%>">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
</head>
	<body>
    	<%=returnMsg%>,��رմ�ҳ�沢�ص�֧��ҳ����ɲ�����
	</body>
</html>