<!--#include file="conn.asp"-->
<!--#include file="user/sms/m_codepublic.asp"-->
<%		

	order_id=session("order_id") 'order_id 
	order_no=session("order_no") 'order_no
	user_id_sms=session("user_id") '�û�ID
	owner_id_sms=session("owner_id") '�̼�ID
	owner_mobile=session("owner_mobile") '�̼��ֻ���
	user_mobile=session("user_mobile") '�û��ֻ���

	'owner_id_sms 
	'user_id_sms
	'owner_mobile '�̼��ֻ���
	'user_mobile  '�û��ֻ���
	
	if owner_mobile<>"" and user_mobile<>"" then
response.write "<br>����֧���ɹ������Ż���"				
		sms_owner="�𾴵ġ����ù�'�̼�,��ϲ���������"&order_no&"֧���ɹ�����Ҫ�鿴���飬���¼���ùݣ�yoinns.com)�̼Һ�̨�鿴��лл�������κ����ʣ���ӭ�µ����ùݿͷ��绰020-34726441.�����ùݡ�"
			
		sms_user="�𾴵ġ����ùݡ��û�,��ϲ�����Ķ�����������ţ�"&order_no&"��֧���ɹ���������ʱ��ס������������������κ����ʣ���ӭ�µ����ùݿͷ��绰020-34726441�����ף����ס��죬����ʮ�����⣬�����ǵ�ʮ�ֶ����������ùݡ�"
			
response.write "<br>׼��������Ż���"				
		'sms_save(�绰,��֤��1,��֤��2,��֤��3,����id,��������,�Ƿ���Ҫ���û��ض���,��ǰλ��) '����
		if sms_open=0 then
			at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '���̼ҷ�����
			at2=mt(user_mobile,sms_user,ext,stime,rrid) '���û�������
response.write "<br>������Ż���"				
		end if
				
			'owner_mobile
		owner_r_no1=""
		owner_r_no2=""
		owner_r_no3=""
		owner_order_id=order_id
		owner_order_name="Pay_ok_T_Order_owner"
		owner_is_back=0
							
		'user_mobile
		user_r_no1=""
		user_r_no2=""
		user_r_no3=""
		user_order_id=order_id
		user_order_name="Pay_ok_T_Order_user"
		user_is_back=0
				
		call sms_save(owner_mobile,owner_r_no1,owner_r_no2,owner_r_no3,owner_order_id,owner_order_name,at1,owner_is_back,0) '�̼ұ���
		call sms_save(user_mobile,user_r_no1,user_r_no2,user_r_no3,user_order_id,user_order_name,at2,user_is_back,0) '�û�����
response.write "<br>�洢���Ż���"				
		
		' ���session
		session("order_id")="" 'order_id 
		session("order_no")="" 'order_no
		session("user_id")="" '�û�ID
		session("owner_id")="" '�̼�ID
		session("owner_mobile")="" '�̼��ֻ���
		session("user_mobile")="" '�û��ֻ���
		
	end if	
		
%>