<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="m_codepublic.asp"-->
<%
args=ConvertHTML(request("args"))
'response.write "0"
'response.write args
response.write "<br><br><br>"

'65356862,132710,15388650501,%b2%e2%ca%d4%b6%cc%d0%c51,2012-5-23 11:38:46;65356862,132710,15321858155,%b2%e2%ca%d4%b6%cc%d0%c52,2012-5-23 11:38:49

if (Instr(args,",")>0) then '��������ж���

	call mdb_name(user_mdb)

	if Instr(args,";")>0 then ' ����ж�������
		data_t=Split(args,";") '�ֽ�����
		For i = 0 To Ubound(data_t) '���ã���ȡ������
			sql="select * from sms_back"
			ps.open sql,comm,1,3
			ps.addnew
			data_a=Split(data_t(i),",") '�ֽ�����
			if Ubound(data_a)<> 4 then call js_jump("��ʽ���ԣ� ��������4��","")
				ps("no1")=data_a(0) '
				ps("no2")=data_a(1) '
				ps("t_no")=data_a(2) '�ֻ���
				ps("t_text")=data_a(3) '�ظ�����
				ps("t_time")=data_a(4) '�ظ�ʱ��
			ps.update
			ps.close
			

			sql="select * from [sms] where (t_no='"&data_a(2)&"' and is_back=1) order by id desc" '��������ֻ��������һ��, ����Ҫ�ظ����ֻ���
			ps.open sql,comm,1,3
			 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			do while not ps.eof

				if data_a(3)=ps("r_no1") then ' ��֤����ͬʱ ȷ�ϻظ�
					if ps("sort_name")="T_Order" then '���ڶ����ظ�
						'==================================================================================================================================================
						' ȷ����������
						sql = "select * from T_Order where id = " & ps("sort_id") & " "
						
						Set Rs = Dream3CLS.Exec(Sql)
						If Rs.EOF Then
							Call Dream3CLS.MsgBox2("�޷��ҵ��ö�����",0,"0")
							response.End()
						End If
						
						If (Rs("state") <> "unconfirm")  Then
							Call Dream3CLS.MsgBox2("�޷�ȡ���ö�����",0,"0")
							response.End()
						End If
						
						f_order_no = Rs("order_no") '������
						user_mobile = Rs("mobile") '�û��ֻ���
						owner_mobile=data_a(2) '�̼��ֻ���
						product_id=Rs("product_id") '��¼product_id
						rs.close
						
						Sql = "Update  T_Order set state = 'unpay' Where id="&ps("sort_id")&" "
						
						Dream3CLS.Exec(Sql)

						Sql = "Select hid  from T_Product Where id="&product_id
						Rs.open Sql,conn,1,2
							hhid=rs("hid")
						Rs.Close
						Sql = "Select h_hotelname from T_hotel Where h_id="&hhid
						Rs.open Sql,conn,1,2
							hh_hotelname=rs("h_hotelname") '�̼��õ�����
						Rs.Close

						'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
						' ������ظ����Ÿ��̼Һ��û� 
					
						'owner_id_sms '�̼�ID
						'user_id_sms '�û�ID						
						'owner_mobile '�̼��ֻ���
						'user_mobile '�û��ֻ���
						sms_owner="�𾴵ġ����ùݡ��̼�, ����ȷ��"&f_order_no&" �ɹ�! �ֵ�ס��������, ��ȷ����������,лл!�����ùݡ�" '��������
						sms_user="�𾴵��û����̼�"&hh_hotelname&"��ȷ���˶������������Ϊ"&f_order_no&"���뾡���½�����ùݡ���yoinns.com)֧��, ȷ�������з���лл�������ùݡ�"

						if sms_open=0 then
							at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '���̼ҷ�����
							at2=mt(user_mobile,sms_user,ext,stime,rrid) '���û�������
							
							'call sms_save(owner_mobile,"","","",product_id,"ok_back_T_Order_owner",at1,0,4) '�̼ұ���
							'call sms_save(user_mobile,"","","",product_id,"ok_back_T_Order_user",at2,0,4) '�û�����
						end if
							'owner_mobile
							owner_r_no1=""
							owner_r_no2=""
							owner_r_no3=""
							owner_order_id=product_id
							owner_order_name="ok_back_T_Order_owner"
							owner_is_back=0
							
							'user_mobile
							user_r_no1=""
							user_r_no2=""
							user_r_no3=""
							user_order_id=product_id
							user_order_name="ok_back_T_Order_user"
							user_is_back=0
						'==================================================================================================================================================
						'�������
					
					end if
					
					ps("is_back")=2 '����ѻظ�
					ps.update
					is_run=1 '��ǽ�����
					exit do
				elseif data_a(3)=ps("r_no2") then 'ȡ���ظ�
					if ps("sort_name")="T_Order" then '���ڶ����ظ�
						'==================================================================================================================================================
						' ȷ����������
	
						sql = "select * from T_Order where id = " & ps("sort_id") & " "
						
						Set Rs = Dream3CLS.Exec(Sql)
							If Rs.EOF Then
								Call Dream3CLS.MsgBox2("�޷��ҵ��ö�����",0,"0")
								response.End()
							End If
							
							If (Rs("state") <> "unconfirm" and  Rs("state") <> "unpay")  Then
								Call Dream3CLS.MsgBox2("�޷�ȡ���ö�����",0,"0")
								response.End()
							End If
							
							f_order_no = Rs("order_no") '������
							user_mobile = Rs("mobile") '�û��ֻ���
							owner_mobile=data_a(2) '�̼��ֻ���
							product_id=Rs("product_id") '��¼product_id
						Rs.Close
													
						Sql = "Update  T_Order set state = 'ownercancel' Where id = " & ps("sort_id")
						Dream3CLS.Exec(Sql)
						

						'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
						' ������ظ����Ÿ��̼Һ��û� 
					
						'owner_id_sms '�̼�ID
						'user_id_sms '�û�ID						
						'owner_mobile '�̼��ֻ���
						'user_mobile '�û��ֻ���
						sms_owner="�𾴵ġ����ùݡ��̼�, ����ȷ��"&f_order_no&" ��ȡ��! �뱣����վ��Ϣ׼ȷ�Ի�������������, ������,лл!�����ùݡ�" '��������
						sms_user="�𾴵��û�,�ǳ���Ǹ! �̼�"&hh_hotelname&"���, �������Ϊ"&f_order_no&", �����Ѷ���, �ö�����ȡ�����������㾴��ԭ��, �뾡���½ yoinns.com ѡ��������,лл!�����ùݡ�"

						if sms_open=0 then
							at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '���̼ҷ�����
							at2=mt(user_mobile,sms_user,ext,stime,rrid) '���û�������
							
							'call sms_save(owner_mobile,"","","",product_id,"ng_back_T_Order_owner",at1,0,4) '�̼ұ���
							'call sms_save(user_mobile,"","","",product_id,"ng_back_T_Order_user",at2,0,4) '�û�����
						end if
							'owner_mobile
							owner_r_no1=""
							owner_r_no2=""
							owner_r_no3=""
							owner_order_id=product_id
							owner_order_name="ng_back_T_Order_owner"
							owner_is_back=0
							
							'user_mobile
							user_r_no1=""
							user_r_no2=""
							user_r_no3=""
							user_order_id=product_id
							user_order_name="ng_back_T_Order_user"
							user_is_back=0
						'==================================================================================================================================================
						'�������
					end if
					ps("is_back")=2 '����ѻظ�
					ps.update
					is_run=1 '��ǽ�����
					exit do
				end if
			
			ps.movenext 
			loop 
			''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			ps.close
			if is_run<>1 then '����ظ��Ķ������ݿ���û�ҵ���Ӧ��¼ʱ
				response.Write " û���ҵ����ͼ�¼"
			else

				call sms_save(owner_mobile,owner_r_no1,owner_r_no2,owner_r_no3,owner_order_id,owner_order_name,at1,owner_is_back,4) '�̼ұ���
				call sms_save(user_mobile,user_r_no1,user_r_no2,user_r_no3,user_order_id,user_order_name,at2,user_is_back,4) '�û�����
				response.Write "�ѷ��ͳɹ�!"
			
				
			end if
	
			
				
		next
	else 'ֻ�е�������
		sql="select * from sms_back"
		ps.open sql,comm,1,3
		ps.addnew
		data_a=Split(args,",") '�ֽ�����
		if Ubound(data_a)<> 4 then call js_jump("��ʽ���ԣ� ��������4��","")
			ps("no1")=data_a(0)
			ps("no2")=data_a(1)
			ps("t_no")=data_a(2)
			ps("t_text")=data_a(3)
			ps("t_time")=data_a(4)
		ps.update
		ps.close
		
		
'''''''''''''''''''''''''''''		
			sql="select * from [sms] where (t_no='"&data_a(2)&"' and is_back=1) order by id desc" '��������ֻ��������һ��, ����Ҫ�ظ����ֻ���
			ps.open sql,comm,1,3
			 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			do while not ps.eof

				if data_a(3)=ps("r_no1") then ' ��֤����ͬʱ ȷ�ϻظ�
					if ps("sort_name")="T_Order" then '���ڶ����ظ�
						'==================================================================================================================================================
						' ȷ����������
						sql = "select * from T_Order where id = " & ps("sort_id") & " "
						
						Set Rs = Dream3CLS.Exec(Sql)
						If Rs.EOF Then
							Call Dream3CLS.MsgBox2("�޷��ҵ��ö�����",0,"0")
							response.End()
						End If
						
						If (Rs("state") <> "unconfirm")  Then
							Call Dream3CLS.MsgBox2("�޷�ȡ���ö�����",0,"0")
							response.End()
						End If
						
						f_order_no = Rs("order_no") '������
						user_mobile = Rs("mobile") '�û��ֻ���
						owner_mobile=data_a(2) '�̼��ֻ���
						product_id=Rs("product_id") '��¼product_id
						rs.close
						
						Sql = "Update  T_Order set state = 'unpay' Where id="&ps("sort_id")&" "
						
						Dream3CLS.Exec(Sql)

						Sql = "Select hid  from T_Product Where id="&product_id
						Rs.open Sql,conn,1,2
							hhid=rs("hid")
						Rs.Close
						Sql = "Select h_hotelname from T_hotel Where h_id="&hhid
						Rs.open Sql,conn,1,2
							hh_hotelname=rs("h_hotelname") '�̼��õ�����
						Rs.Close

						'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
						' ������ظ����Ÿ��̼Һ��û� 
					
						'owner_id_sms '�̼�ID
						'user_id_sms '�û�ID						
						'owner_mobile '�̼��ֻ���
						'user_mobile '�û��ֻ���
						sms_owner="�𾴵ġ����ùݡ��̼�, ����ȷ��"&f_order_no&" �ɹ�! �ֵ�ס��������, ��ȷ����������,лл!�����ùݡ�" '��������
						sms_user="�𾴵��û����̼�"&hh_hotelname&"��ȷ���˶������������Ϊ"&f_order_no&"���뾡���½�����ùݡ���yoinns.com)֧��, ȷ�������з���лл�������ùݡ�"

						if sms_open=0 then
							at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '���̼ҷ�����
							at2=mt(user_mobile,sms_user,ext,stime,rrid) '���û�������
							
							'call sms_save(owner_mobile,"","","",product_id,"ok_back_T_Order_owner",at1,0,4) '�̼ұ���
							'call sms_save(user_mobile,"","","",product_id,"ok_back_T_Order_user",at2,0,4) '�û�����
						end if
							'owner_mobile
							owner_r_no1=""
							owner_r_no2=""
							owner_r_no3=""
							owner_order_id=product_id
							owner_order_name="ok_back_T_Order_owner"
							owner_is_back=0
							
							'user_mobile
							user_r_no1=""
							user_r_no2=""
							user_r_no3=""
							user_order_id=product_id
							user_order_name="ok_back_T_Order_user"
							user_is_back=0
						'==================================================================================================================================================
						'�������
					
					end if
					
					ps("is_back")=2 '����ѻظ�
					ps.update
					is_run=1 '��ǽ�����
					exit do
				elseif data_a(3)=ps("r_no2") then 'ȡ���ظ�
					if ps("sort_name")="T_Order" then '���ڶ����ظ�
						'==================================================================================================================================================
						' ȷ����������
	
						sql = "select * from T_Order where id = " & ps("sort_id") & " "
						
						Set Rs = Dream3CLS.Exec(Sql)
							If Rs.EOF Then
								Call Dream3CLS.MsgBox2("�޷��ҵ��ö�����",0,"0")
								response.End()
							End If
							
							If (Rs("state") <> "unconfirm" and  Rs("state") <> "unpay")  Then
								Call Dream3CLS.MsgBox2("�޷�ȡ���ö�����",0,"0")
								response.End()
							End If
							
							f_order_no = Rs("order_no") '������
							user_mobile = Rs("mobile") '�û��ֻ���
							owner_mobile=data_a(2) '�̼��ֻ���
							product_id=Rs("product_id") '��¼product_id
						Rs.Close
													
						Sql = "Update  T_Order set state = 'ownercancel' Where id = " & ps("sort_id")
						Dream3CLS.Exec(Sql)
						

						'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
						' ������ظ����Ÿ��̼Һ��û� 
					
						'owner_id_sms '�̼�ID
						'user_id_sms '�û�ID						
						'owner_mobile '�̼��ֻ���
						'user_mobile '�û��ֻ���
						sms_owner="�𾴵ġ����ùݡ��̼�, ����ȷ��"&f_order_no&" ��ȡ��! �뱣����վ��Ϣ׼ȷ�Ի�������������, ������,лл!�����ùݡ�" '��������
						sms_user="�𾴵��û�,�ǳ���Ǹ! �̼�"&hh_hotelname&"���, �������Ϊ"&f_order_no&", �����Ѷ���, �ö�����ȡ�����������㾴��ԭ��, �뾡���½ yoinns.com ѡ��������,лл!�����ùݡ�"

						if sms_open=0 then
							at1=mt(owner_mobile,sms_owner,ext,stime,rrid) '���̼ҷ�����
							at2=mt(user_mobile,sms_user,ext,stime,rrid) '���û�������
							
							'call sms_save(owner_mobile,"","","",product_id,"ng_back_T_Order_owner",at1,0,4) '�̼ұ���
							'call sms_save(user_mobile,"","","",product_id,"ng_back_T_Order_user",at2,0,4) '�û�����
						end if
							'owner_mobile
							owner_r_no1=""
							owner_r_no2=""
							owner_r_no3=""
							owner_order_id=product_id
							owner_order_name="ng_back_T_Order_owner"
							owner_is_back=0
							
							'user_mobile
							user_r_no1=""
							user_r_no2=""
							user_r_no3=""
							user_order_id=product_id
							user_order_name="ng_back_T_Order_user"
							user_is_back=0
						'==================================================================================================================================================
						'�������
					end if
					ps("is_back")=2 '����ѻظ�
					ps.update
					is_run=1 '��ǽ�����
					exit do
				end if
			
			ps.movenext 
			loop 
			''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			ps.close
			if is_run<>1 then '����ظ��Ķ������ݿ���û�ҵ���Ӧ��¼ʱ
				response.Write " û���ҵ����ͼ�¼"
			else

				call sms_save(owner_mobile,owner_r_no1,owner_r_no2,owner_r_no3,owner_order_id,owner_order_name,at1,owner_is_back,4) '�̼ұ���
				call sms_save(user_mobile,user_r_no1,user_r_no2,user_r_no3,user_order_id,user_order_name,at2,user_is_back,4) '�û�����
				response.Write "�ѷ��ͳɹ�!"
			
				
			end if
'''''''''''''''''''''''''''''		
	
	end if
	response.Write "0"
else
	response.Write "1"
end if






















































%>