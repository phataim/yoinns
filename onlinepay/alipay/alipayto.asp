
<%
	'���ܣ�������Ʒ�й���Ϣ��ȷ�϶���֧�������߹������ҳ��
	'��ϸ����ҳ���ǽӿ����ҳ�棬����֧��ʱ��URL
	'�汾��3.1
	'���ڣ�2010-11-25
	'˵����
	'���´���ֻ��Ϊ�˷����̻����Զ��ṩ���������룬�̻����Ը����Լ���վ����Ҫ�����ռ����ĵ���д,����һ��Ҫʹ�øô��롣
	'�ô������ѧϰ���о�֧�����ӿ�ʹ�ã�ֻ���ṩһ���ο���
	
'''''''''''''''''ע��'''''''''''''''''''''''''
'������ڽӿڼ��ɹ������������⣬
'�����Ե��̻��������ģ�https://b.alipay.com/support/helperApply.htm?action=consultationApply�����ύ���뼯��Э�������ǻ���רҵ�ļ�������ʦ������ϵ��Э�������
'��Ҳ���Ե�֧������̳��http://club.alipay.com/read-htm-tid-8681712.html��Ѱ����ؽ������
'�������ʹ����չ���������չ���ܲ�������ֵ��
'�ܽ����㷽ʽ�ǣ��ܽ��=price*quantity+logistics_fee+discount��
'�����price����Ϊ�ܽ��������˷ѡ��ۿۡ����ﳵ�й�����Ʒ�ܶ�ȼ��������ն�����Ӧ���ܶ
'������������ֻʹ��һ�飬����������̻���վ���µ�ʱѡ����������ͣ���ݡ�ƽ�ʡ�EMS���������Զ�ʶ��logistics_type�����������е�һ��ֵ
'���ҿ�ݹ�˾������EXPRESS����ݣ��ķ���
''''''''''''''''''''''''''''''''''''''''''''''
%>

<!--#include file="alipay_config.asp"-->
<!--#include file="alipay_service.asp"-->

<%
'''���²�������Ҫͨ���µ�ʱ�Ķ������ݴ���������'''
'�������
sTime=now()
out_trade_no =olp_order_no'�������վ����ϵͳ�е�Ψһ������ƥ��
subject      = olp_product_name		'�������ƣ���ʾ��֧��������̨��ġ���Ʒ���ơ����ʾ��֧�����Ľ��׹���ġ���Ʒ���ơ����б��
body         = olp_remark		'����������������ϸ��������ע����ʾ��֧��������̨��ġ���Ʒ��������
price    	 = olp_money	'�����ܽ���ʾ��֧��������̨��ġ���Ʒ���ۡ���

logistics_fee		= "0.00"				'�������ã����˷ѡ�
logistics_type		= "EXPRESS"				'�������ͣ�����ֵ��ѡ��EXPRESS����ݣ���POST��ƽ�ʣ���EMS��EMS��
logistics_payment	= "SELLER_PAY"			'����֧����ʽ������ֵ��ѡ��SELLER_PAY�����ҳе��˷ѣ���BUYER_PAY����ҳе��˷ѣ�

quantity 	 = "1"							'��Ʒ����������Ĭ��Ϊ1�����ı�ֵ����һ�ν��׿�����һ���¶������ǹ���һ����Ʒ��

'��չ������������ջ���Ϣ���Ƽ���Ϊ���
'�ù���������������Ѿ����̻���վ���µ����������һ���ջ���Ϣ��������Ҫ�����֧�����ĸ����������ٴ���д�ջ���Ϣ��
'��Ҫʹ�øù��ܣ������ٱ�֤receive_name��receive_address��ֵ
'�ջ���Ϣ��ʽ���ϸ�����������ַ���ʱࡢ�绰���ֻ��ĸ�ʽ��д
receive_name		= ""			'�ջ����������磺����
receive_address		= ""			'�ջ��˵�ַ���磺XXʡXXX��XXX��XXX·XXXС��XXX��XXX��ԪXXX��
receive_zip			= ""				'�ջ����ʱ࣬�磺123456
receive_phone		= ""		'�ջ��˵绰���룬�磺0571-88158090
receive_mobile		= ""			'�ջ����ֻ����룬�磺13312341234

'��չ���������ڶ���������ʽ
'������ʽ������Ϊһ�������֡���Ҫʹ�ã�������������Ҫ�������ݣ�����ʹ�ã�������������ҪΪ��
'���˵�һ��������ʽ�������еڶ���������ʽ���Ҳ������һ��������ʽ�е�����������ͬ��
'��logistics_type="EXPRESS"����ôlogistics_type_1�ͱ�����ʣ�µ�����ֵ��POST��EMS����ѡ��
logistics_fee_1		= ""					'�������ã����˷ѡ�
logistics_type_1	= ""					'�������ͣ�����ֵ��ѡ��EXPRESS����ݣ���POST��ƽ�ʣ���EMS��EMS��
logistics_payment_1	= ""					'����֧����ʽ������ֵ��ѡ��SELLER_PAY�����ҳе��˷ѣ���BUYER_PAY����ҳе��˷ѣ�

'��չ��������������������ʽ
'������ʽ������Ϊһ�������֡���Ҫʹ�ã�������������Ҫ�������ݣ�����ʹ�ã�������������ҪΪ��
'���˵�һ��������ʽ�͵ڶ���������ʽ�������е�����������ʽ���Ҳ������һ��������ʽ�͵ڶ���������ʽ�е�����������ͬ��
'��logistics_type="EXPRESS"��logistics_type_1="EMS"����ôlogistics_type_2��ֻ��ѡ��"POST"
logistics_fee_2		= ""					'�������ã����˷ѡ�
logistics_type_2	= ""					'�������ͣ�����ֵ��ѡ��EXPRESS����ݣ���POST��ƽ�ʣ���EMS��EMS��
logistics_payment_2	= ""					'����֧����ʽ������ֵ��ѡ��SELLER_PAY�����ҳе��˷ѣ���BUYER_PAY����ҳе��˷ѣ�

'��չ���ܲ�����������
buyer_email			= ""					'Ĭ�����֧�����˺�
discount	 		= ""					'�ۿۣ��Ǿ���Ľ������ǰٷֱȡ���Ҫʹ�ô��ۣ���ʹ�ø���������֤С���������λ��

'0��ʱ���˽��ף�service=create_direct_pay_by_user
'1��׼˫�ӿڽ��ף� service=trade_create_by_buyer
'2�������ף� service="create_partner_trade_by_buyer"
Select Case CInt(Dream3CLS.SiteConfig("AlipayService"))
	Case 0
		service="create_direct_pay_by_user"
	Case 1
		service="trade_create_by_buyer"
	Case 2
		service="create_partner_trade_by_buyer"
End Select
'service="trade_create_by_buyer"
'service="create_direct_pay_by_user"

' service="create_partner_trade_by_buyer"



''''''''''''''''''''''''''''''''''''''''''''''''''''
'����Ҫ����Ĳ������飬����Ķ�
para = Array("service="&service,"payment_type=1","partner="&partner,"seller_email="&seller_email,"return_url="&return_url,"notify_url="&notify_url,"_input_charset="&input_charset,"show_url="&show_url,"out_trade_no="&out_trade_no,"subject="&subject,"body="&body,"price="&price,"quantity="&quantity,"logistics_fee="&logistics_fee,"logistics_type="&logistics_type,"logistics_payment="&logistics_payment,"receive_name="&receive_name,"receive_address="&receive_address,"receive_zip="&receive_zip,"receive_phone="&receive_phone,"receive_mobile="&receive_mobile,"logistics_fee_1="&logistics_fee_1,"logistics_type_1="&logistics_type_1,"logistics_payment_1="&logistics_payment_1,"logistics_fee_2="&logistics_fee_2,"logistics_type_2="&logistics_type_2,"logistics_payment_2="&logistics_payment_2,"buyer_email="&buyer_email,"discount="&discount)

'����������
alipay_service(para)
sHtmlText = build_form()
Response.Write(sHtmlText)
%>
