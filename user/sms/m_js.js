
//====================================================== 共用函数    ======================================================

	var $=function(node){ //$ 通用字符
		return document.getElementById(node);
	}
	var $$=function(node){ //$ 通用字符
		return document.getElementsByTagName(node);
	}
	

// ==============================================================================================================================

function send_sms(){ //发送短信跳板 注册用

if ( $("mobile").value.length !=11 || isNaN($("mobile").value)==true)
{
alert("请输入正确的手机号码！");
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
				if (data==0){alert ("验证码已发送， 请注意查收！")}
				else if (data==2){alert("验证码已经发送, 请稍候！")}
				else if (data==3){alert("此手机号已注册过！");$("mobile").value="";}
				else if (data==4){alert("请勿重复提交！")}
				else {alert("发送失败，请稍候再试！")}
					
				}
			}
		}
		xmlhttp.open("post", "../sms/m_send.asp", true);
		xmlhttp.setRequestHeader('Content-type','application/x-www-form-urlencoded');
		xmlhttp.send("t_no="+escape($("mobile").value)); //escape 编码
			//+"&N_up="+escape($("N_up").value)+"&N_down="+escape($("N_down").value)
			//?product_no=product_no&N_up&N_down
	}

function check_r_no(){ //检测验证码
//check_r_no
if ( $("reg_code").value.length >= 4 && isNaN($("reg_code").value)==false)
	{ //够>4位并为数字时

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
				if (data=="y"){$("is_ok_reg").innerHTML=" <b>√</b>" }
				else {$("is_ok_reg").innerHTML=" <b>×</b>"}
					
				}
			}
		}
		xmlhttp.open("post", "../sms/m_check_sms.asp", true);
		xmlhttp.setRequestHeader('Content-type','application/x-www-form-urlencoded');
		xmlhttp.send("t_no="+escape($("mobile").value)+"&reg_code="+escape($("reg_code").value)); //escape 编码
		//alert("t_no="+escape($("mobile").value)+"&reg_code="+escape($("reg_code").value))
	}
else
{$("is_ok_reg").innerHTML=" <b>×</b>"}
}


//=================================================================

function send_sms_p(){ //发送短信跳板 忘记密码用

if ( $("mobile").value.length !=11 || isNaN($("mobile").value)==true)
{
alert("请输入正确的手机号码！");
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
				if (data==0){alert ("验证码已发送， 请注意查收！")}
				else if (data==2){alert("验证码已经发送, 请稍候！")}
				else if (data==3){alert("此手机号未在本站注册过！");$("mobile").value="";}
				else if (data==4){alert("请勿重复提交！")}
				else {alert("发送失败，请稍候再试！")}
					
				}
			}
		}
		xmlhttp.open("post", "../sms/m_send.asp", true);
		xmlhttp.setRequestHeader('Content-type','application/x-www-form-urlencoded');
		xmlhttp.send("sort=1&t_no="+escape($("mobile").value)); //escape 编码
			//+"&N_up="+escape($("N_up").value)+"&N_down="+escape($("N_down").value)
			//?product_no=product_no&N_up&N_down
	}


















