<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_team.asp"-->
<!--#include file="../common/api/cls_user.asp"-->
<!--#include file="OnlinePaycode.asp"-->
<!--#include file="md5.inc"-->
<!--#include file="alipay/alipay_md5.asp"-->
<!--#include file="../common/api/cls_tpl.asp"-->
<!--#include file="../common/api/cls_sms.asp"-->
<!--#include file="../common/api/cls_xml.asp"-->

<%
	'���ܣ���������ת��ҳ�棨ҳ����תͬ��֪ͨҳ�棩
	'�汾��3.1
	'���ڣ�2010-11-23
	'˵����
	'���´���ֻ��Ϊ�˷����̻����Զ��ṩ���������룬�̻����Ը����Լ���վ����Ҫ�����ռ����ĵ���д,����һ��Ҫʹ�øô��롣
	'�ô������ѧϰ���о�֧�����ӿ�ʹ�ã�ֻ���ṩһ���ο���
	
''''''''ҳ�湦��˵��''''''''''''''''
'��ҳ����ڱ������Բ���
'��ҳ�������ҳ����תͬ��֪ͨҳ�桱������֧����������ͬ�����ã��ɵ�����֧����ɺ����ʾ��Ϣҳ���硰����ĳĳĳ���������ٽ����֧���ɹ�����
'�ɷ���HTML������ҳ��Ĵ���Ͷ���������ɺ�����ݿ���³������
'��ҳ�����ʹ��ASP�������ߵ��ԣ�Ҳ����ʹ��д�ı�����log_result���е��ԣ��ú����ѱ�Ĭ�Ϲرգ���alipay_notify.asp�еĺ���return_verify
'WAIT_SELLER_SEND_GOODS(��ʾ�������֧�������׹����в����˽��׼�¼�Ҹ���ɹ���������û�з���);
'TRADE_FINISHED(��ʾ����Ѿ�ȷ���ջ�����ʽ������);

''''''''ע��'''''''''''''''''''''''
'����жϸñʽ�����ͨ����ʱ���ʷ�ʽ�����ͨ���������׷�ʽ���
'
'�������׵Ľ���״̬�仯˳���ǣ��ȴ���Ҹ��������Ѹ���ȴ����ҷ����������ѷ������ȴ�����ջ���������ջ����������
'��ʱ���ʵĽ���״̬�仯˳���ǣ��ȴ���Ҹ�����������
'
'ÿ���յ�֧��������֪ͨʱ���Ϳ��Ի�ȡ����ʽ��׵Ľ���״̬�������̻���Ҫ�����̻������Ų�ѯ�̻���վ�Ķ������ݣ�
'�õ���ʶ������̻���վ�е�״̬��ʲô�����̻���վ�еĶ���״̬���֧����֪ͨ�л�ȡ����״̬�����Աȡ�
'����̻���վ��Ŀǰ��״̬�ǵȴ���Ҹ������֧����֪ͨ��ȡ����״̬������Ѹ���ȴ����ҷ�������ô��ʽ���������õ������׷�ʽ�����
'����̻���վ��Ŀǰ��״̬�ǵȴ���Ҹ������֧����֪ͨ��ȡ����״̬�ǽ�����ɣ���ô��ʽ���������ü�ʱ���ʷ�ʽ�����
''''''''''''''''''''''''''''''''''''
%>
<!--#include file="alipay/alipay_config.asp"-->
<!--#include file="alipay/alipay_notify.asp"-->

<%
'����ó�֪ͨ��֤���
'verify_result = return_verify()

't(verify_result)
verify_result = true

Dim returnMsg
Dim total_fee
Dim order_no
Dim OnlineNumber
Dim team_id
 
if verify_result then	'��֤�ɹ�
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'������������̻���ҵ���߼��������
	
	'�������������ҵ���߼�����д�������´�������ο�������
    '��ȡ֧������֪ͨ���ز������ɲο������ĵ���ҳ����תͬ��֪ͨ�����б�
    order_no		= "11120620355004"	'��ȡ������
    total_fee		= 95			'��ȡ�ܽ��
	OnlineNumber = "1234567"
	team_id = 6
	

	SetOrderState order_no,"alipay",OnlineNumber,CDBL(total_fee)
	Set tRs = Dream3Team.GetOrderByOrderNo(order_no)
	UpdateTeamState(tRs("team_id"))
	
	
	returnMsg	= "֧���ɹ���"
	
	'�������������ҵ���߼�����д�������ϴ�������ο�������
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
else '��֤ʧ��
    '��Ҫ���ԣ��뿴alipay_notify.aspҳ���return_verify�������ȶ�sign��mysign��ֵ�Ƿ���ȣ����߼��responseTxt��û�з���true
    returnMsg	= "֧��ʧ�ܣ�"
end if

Sub createLog(ByRef returnMsg)
    filename = "alipay/alipaytradeinfo.log"
    content = now()		&	","							&	request.ServerVariables("REMOTE_ADDR")
    content = content &	","							&	returnMsg
    content = content &	",�̻�������:"	& r6_Order
    content = content &	",֧�����:"		& r3_Amt

    
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
<title>֧����֧�� - <%=SiteConfig("SiteName")%></title>
<meta name="description" content="<%=SiteConfig("MetaDescription")%>">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
</head>
	<body>
    	<%=returnMsg%>,��رմ�ҳ�沢�ص�֧��ҳ����ɲ�����
	</body>
</html>