
//====================================================== ���ú���    ======================================================

	var $=function(node){ //$ ͨ���ַ�
		return document.getElementById(node);
	}
	var $$=function(node){ //$ ͨ���ַ�
		return document.getElementsByTagName(node);
	}
	

// ==============================================================================================================================

function send_sms(){ //���Ͷ������� ע����

if ( $("mobile").value.length !=11 || isNaN($("mobile").value)==true)
{
alert("��������ȷ���ֻ����룡");
return false;
}

	var xmlhttp;
	try{
		xmlhttp=new XMLHttpRequest();
		}
		catch(e){
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange=function(){
		if (xmlhttp.readyState==4){
			if (xmlhttp.status==200){
				var data=xmlhttp.responseText;
				if (data==0){alert ("��֤���ѷ��ͣ� ��ע����գ�")}
				else if (data==2){alert("��֤���Ѿ�����, ���Ժ�")}
				else if (data==3){alert("���ֻ�����ע�����");$("mobile").value="";}
				else if (data==4){alert("�����ظ��ύ��")}
				else {alert("����ʧ�ܣ����Ժ����ԣ�")}
					
				}
			}
		}
		xmlhttp.open("post", "../sms/m_send.asp", true);
		xmlhttp.setRequestHeader('Content-type','application/x-www-form-urlencoded');
		xmlhttp.send("t_no="+escape($("mobile").value)); //escape ����
			//+"&N_up="+escape($("N_up").value)+"&N_down="+escape($("N_down").value)
			//?product_no=product_no&N_up&N_down
	}

function check_r_no(){ //�����֤��
//check_r_no
if ( $("reg_code").value.length >= 4 && isNaN($("reg_code").value)==false)
	{ //��>4λ��Ϊ����ʱ

	var xmlhttp;
	try{
		xmlhttp=new XMLHttpRequest();
		}
		catch(e){
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange=function(){
		if (xmlhttp.readyState==4){
			if (xmlhttp.status==200){
				var data=xmlhttp.responseText;
				if (data=="y"){$("is_ok_reg").innerHTML=" <b>��</b>" }
				else {$("is_ok_reg").innerHTML=" <b>��</b>"}
					
				}
			}
		}
		xmlhttp.open("post", "../sms/m_check_sms.asp", true);
		xmlhttp.setRequestHeader('Content-type','application/x-www-form-urlencoded');
		xmlhttp.send("t_no="+escape($("mobile").value)+"&reg_code="+escape($("reg_code").value)); //escape ����
		//alert("t_no="+escape($("mobile").value)+"&reg_code="+escape($("reg_code").value))
	}
else
{$("is_ok_reg").innerHTML=" <b>��</b>"}
}


//=================================================================

function send_sms_p(){ //���Ͷ������� ����������

if ( $("mobile").value.length !=11 || isNaN($("mobile").value)==true)
{
alert("��������ȷ���ֻ����룡");
return false;
}

	var xmlhttp;
	try{
		xmlhttp=new XMLHttpRequest();
		}
		catch(e){
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange=function(){
		if (xmlhttp.readyState==4){
			if (xmlhttp.status==200){
				var data=xmlhttp.responseText;
				if (data==0){alert ("��֤���ѷ��ͣ� ��ע����գ�")}
				else if (data==2){alert("��֤���Ѿ�����, ���Ժ�")}
				else if (data==3){alert("���ֻ���δ�ڱ�վע�����");$("mobile").value="";}
				else if (data==4){alert("�����ظ��ύ��")}
				else {alert("����ʧ�ܣ����Ժ����ԣ�")}
					
				}
			}
		}
		xmlhttp.open("post", "../sms/m_send.asp", true);
		xmlhttp.setRequestHeader('Content-type','application/x-www-form-urlencoded');
		xmlhttp.send("sort=1&t_no="+escape($("mobile").value)); //escape ����
			//+"&N_up="+escape($("N_up").value)+"&N_down="+escape($("N_down").value)
			//?product_no=product_no&N_up&N_down
	}


















