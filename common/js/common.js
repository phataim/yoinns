function confirmMsg(msg,ok,url){
	$.prompt(msg,{buttons:[{title: ok,value:true},{title: '取消',value:false}], submit: function(v,m,f){if (v){window.location.href=url}} });
	return false;
}
function alertMsg(msg){
	$.prompt(msg);
	return false;
}
function ajaxdo(msg,func){
	$.prompt(msg,{
		submit: func,
		buttons: { '确定':true }
	});
}

function getCity(obj,city,selid,type,did,sd){
	$.getJSON('http://www.nicezu.com/json/jsoncity?id=' + $(obj).val() + '&parm=' + new Date() + '&callback=?',function(json){
		if (json){
			var sed;
			var cityStr = '';
			for (var i in json){
				sed = '';
				if (selid == i){
					sed = ' selected="selected"';
				}
				if (type == 'checkbox'){
					cityStr += '<label><input type="checkbox" name="open[]" value="'+i+'"'+sed+' /> '+json[i]+'</label> ';
				}else {
					cityStr += '<option value="'+i+'"'+sed+'>'+json[i]+'</option>';
				}
				if (i == '0'){
					break;
				}
			}
			$(city).html(cityStr);
			if (did){
				getDistrict(city,did,sd);
			}
		}else {
			if (open){
				$(city).html('当前省份没有未开通的城市');
			}
		}
	});
}
function getDistrict(obj,district,selid,type){
	$.getJSON('http://www.nicezu.com/json/jsondistrict?id=' + $(obj).val() + '&parm=' + new Date() + '&callback=?',function(json){
		if (json){
			var sed;
			var cityStr = '<option value="">全部</option>';
			for (var i in json){
				sed = '';
				if (selid == i){
					sed = 'selected="selected"';
				}
				if (type == 'checkbox'){
					cityStr += '<label><input type="checkbox" name="open[]" value="'+i+'"'+sed+' /> '+json[i]+'</label> ';
				}else {
					cityStr += '<option value="'+i+'"'+sed+'>'+json[i]+'</option>';
				}
				if (i == '0'){
					break;
				}
			}
			$(district).html(cityStr);
		}
	});
}
function showcity(){
	$("#showcity").css('display','block');
}
function getTab(id,obj,self,classname){
	$(obj).addClass('hidden');
	$(obj[id]).removeClass('hidden');
	$(self).removeClass(classname);
	$(self[id]).addClass(classname);
}
/**手机号码验证**/
function is_mobile_phone(num)
{
	var exp=/^1(3|4|5|8)[0-9]{9}$/
	if(exp.exec(num))return 1;
	else return false;
}
/**密码验证***/
function is_psw(psw)
{
    if(psw.length>=6)return 1;
    else return false;
}
/***form serilize重写**/
function yf_serialize(f)
{
    var l=f.length;
    var form_data=Array();
    for(var i=0;i!=l;++i)
    {
        form_data.push((f[i].name||f[i].id)+'='+escape(f[i].value));
    }
    return form_data.join('&');
} 
/***********异步Ajax调用函数********/
Ajax=function (option){
	option=
	{
		type:option.type||'POST',
		url:option.url||'',
		async:option.async||'ture',
		timeout:option.timeout||5000,
		onComplete:option.onComplete||function(){},
		onError:option.onError||function(){},
		onSuccess:option.onSuccess||function(){},
		onSend:option.onSend||function(){},
		onTimeout:option.onTimeout||function(){},
		acceptdatatype:option.acceptdatatype||'json',
		data:option.data||''
	};
	var ajax;
	var timer;
	if(typeof XMLHttpRequest=='undefined')
	{
		ajax=new ActiveXObject("Microsoft.XMLHTTP");
	}
	else 
	{
		ajax=new XMLHttpRequest();
	}
	ajax.open(option.type,option.url,option.async);
	if(option.type=='GET')
	{
		ajax.setRequestHeader("If-Modified-Since","Thu, 01 Jan 1970 00:00:00 GMT"); 
		ajax.send();
	}
	else 
	{
		switch(option.acceptdatatype)
		{
			case 'json':ajax.setRequestHeader("Accept",'application/json, text/javascript');
				ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				break;
			default :ajax.setRequestHeader("Accept",'application/json, text/javascript');
				ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		}
		ajax.setRequestHeader("If-Modified-Since","Thu, 01 Jan 1970 00:00:00 GMT"); 
		ajax.send(option.data);
	}
	timer=setTimeout(function()
		{
			if(typeof option.onTimeout=="function") option.onTimeout();
			if(ajax)
			{
				ajax.abort();
				ajax=null;
			}
			return 0;
		}
		,option.timeout);
	ajax.onreadystatechange=function()
	{
		switch (ajax.readyState)
		{
			case 0: 
				break;
			case 1:
				break;
			case 2:option.onSend();
				break;
			case 3:
				break;
			case 4:
				try
				{
					switch(ajax.status)
					{
						case 200:if(timer)clearTimeout(timer);
							option.onSuccess(ajax.responseText);
							option.onComplete(ajax.responseText);
							ajax=null;
							break;
						case 404:if(timer)clearTimeout(timer);
							option.onError(ajax.responseText);
							option.onComplete(ajax.responseText);
							ajax=null;
							break;
						default:if(timer)clearTimeout(timer);
							option.onComplete(ajax.responseText);
							ajax=null;
					}
				}catch(e){}
			default:break;
		}
	}

}

// Create a JSON object only if one does not already exist. We create the

var JSON;
if (!JSON) {
    JSON = {};
}

(function () {
    'use strict';

    function f(n) {
                return n < 10 ? '0' + n : n;
    }

    if (typeof Date.prototype.toJSON !== 'function') {

        Date.prototype.toJSON = function (key) {

            return isFinite(this.valueOf())
                ? this.getUTCFullYear()     + '-' +
                    f(this.getUTCMonth() + 1) + '-' +
                    f(this.getUTCDate())      + 'T' +
                    f(this.getUTCHours())     + ':' +
                    f(this.getUTCMinutes())   + ':' +
                    f(this.getUTCSeconds())   + 'Z'
                : null;
        };

        String.prototype.toJSON      =
            Number.prototype.toJSON  =
            Boolean.prototype.toJSON = function (key) {
                return this.valueOf();
            };
    }

    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        gap,
        indent,
        meta = {                '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"' : '\\"',
            '\\': '\\\\'
        },
        rep;


    function quote(string) {


        escapable.lastIndex = 0;
        return escapable.test(string) ? '"' + string.replace(escapable, function (a) {
            var c = meta[a];
            return typeof c === 'string'
                ? c
                : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
        }) + '"' : '"' + string + '"';
    }


    function str(key, holder) {


        var i,                      k,                      v,                      length,
            mind = gap,
            partial,
            value = holder[key];


        if (value && typeof value === 'object' &&
                typeof value.toJSON === 'function') {
            value = value.toJSON(key);
        }


        if (typeof rep === 'function') {
            value = rep.call(holder, key, value);
        }


        switch (typeof value) {
        case 'string':
            return quote(value);

        case 'number':


            return isFinite(value) ? String(value) : 'null';

        case 'boolean':
        case 'null':


            return String(value);


        case 'object':


            if (!value) {
                return 'null';
            }


            gap += indent;
            partial = [];


            if (Object.prototype.toString.apply(value) === '[object Array]') {


                length = value.length;
                for (i = 0; i < length; i += 1) {
                    partial[i] = str(i, value) || 'null';
                }


                v = partial.length === 0
                    ? '[]'
                    : gap
                    ? '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']'
                    : '[' + partial.join(',') + ']';
                gap = mind;
                return v;
            }


            if (rep && typeof rep === 'object') {
                length = rep.length;
                for (i = 0; i < length; i += 1) {
                    if (typeof rep[i] === 'string') {
                        k = rep[i];
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            } else {


                for (k in value) {
                    if (Object.prototype.hasOwnProperty.call(value, k)) {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            }


            v = partial.length === 0
                ? '{}'
                : gap
                ? '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}'
                : '{' + partial.join(',') + '}';
            gap = mind;
            return v;
        }
    }


    if (typeof JSON.stringify !== 'function') {
        JSON.stringify = function (value, replacer, space) {


            var i;
            gap = '';
            indent = '';


            if (typeof space === 'number') {
                for (i = 0; i < space; i += 1) {
                    indent += ' ';
                }


            } else if (typeof space === 'string') {
                indent = space;
            }


            rep = replacer;
            if (replacer && typeof replacer !== 'function' &&
                    (typeof replacer !== 'object' ||
                    typeof replacer.length !== 'number')) {
                throw new Error('JSON.stringify');
            }


            return str('', {'': value});
        };
    }



    if (typeof JSON.parse !== 'function') {
        JSON.parse = function (text, reviver) {


            var j;

            function walk(holder, key) {


                var k, v, value = holder[key];
                if (value && typeof value === 'object') {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v;
                            } else {
                                delete value[k];
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }



            text = String(text);
            cx.lastIndex = 0;
            if (cx.test(text)) {
                text = text.replace(cx, function (a) {
                    return '\\u' +
                        ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                });
            }



            if (/^[\],:{}\s]*$/
                    .test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, '@')
                        .replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']')
                        .replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {


                j = eval('(' + text + ')');


                return typeof reviver === 'function'
                    ? walk({'': j}, '')
                    : j;
            }
            throw new SyntaxError('JSON.parse');
        };
    }
}());
Date.prototype.format = function(format)
{ 
	var o = { 
		"M+" : this.getMonth()+1, //month 
		"d+" : this.getDate(), //day 
		"h+" : this.getHours(), //hour 
		"m+" : this.getMinutes(), //minute 
		"s+" : this.getSeconds(), //second 
		"q+" : Math.floor((this.getMonth()+3)/3), //quarter 
		"S" : this.getMilliseconds() //millisecond 
	} 
	
	if(/(y+)/.test(format)) 
	{ 
	format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
	} 

	for(var k in o) 
	{ 
		if(new RegExp("("+ k +")").test(format)) 
		{ 
		format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
		} 
	} 
	return format; 
} 
function addListener(element,e,fn){ 
			if(element != null){
				 if(element.addEventListener){ 
				element.addEventListener(e,fn,false); 
				 } else { 
				 element.attachEvent("on" + e,fn); 
				  } 
				} 
				var headEmail = document.getElementById("headEmail"); 
				addListener(headEmail,"click",function(){ 
					headEmail.value = ""; 
				}) 
				addListener(headEmail,"blur",function(){ 
					if(headEmail.value == ""){
						headEmail.value = "输入E-mail，订阅每日租房信息"; 
					}
				})    
			} 
former_select=function(former,next)
{
	var f=document.getElementById(former);
	var n=document.getElementById(next);
	var f_obj=new Date(f.value.replace(/-/g,"/"));
	var n_obj=new Date(n.value.replace(/-/g,"/"));
	if(f.value>=n.value)
	{
		f_obj.setDate(f_obj.getDate()+1);
		n.value=f_obj.format('yyyy-MM-dd');
	}
	n.click();
}
get_new_price=function(former,next,pid_dom)
{
	var f=document.getElementById(former);
	var n=document.getElementById(next);
	var pid=document.getElementById(pid_dom);
	Ajax({
		url:'/ajax/countOrderPrice.asp',
		data:'product_id='+pid.value+'&dateLower='+f.value+'&dateUpper='+n.value,
		onSuccess:function(e)
			{
				var r=JSON.parse(e);
				if(r.countResult)
				{
					var r_num=document.getElementById('checkinRoomNum').value;
					document.getElementById('price').innerHTML='<b>￥</b>'+r_num*r.countResult;
				}
			}
		})
}
/******显示覆盖层**********/
function showOverlay()
{
	var overlay=document.createElement('div');
	overlay.id='overlay';
	document.body.appendChild(overlay);
	$(overlay).fadeTo('fast',0.4);
}	

/******隐藏覆盖层**********/
function hideOverlay()
{
	$('#overlay').fadeOut('fast',function(){$('#overlay').remove()});
}
/****检查用户是否注册****/
is_login=function(o)
{
	o={
		t:o.t||'',
		f:o.f||''
	}
	Ajax({
		url:'/ajax/isLogin.asp',
		onSuccess:function(r){var e=JSON.parse(r);if(e.userID)o.t();else o.f();}
	})
}
/******悬浮登陆框加载*****/
function load_login(to_be_submit_f)
{
	var form_to=''
	if(to_be_submit_f)form_to='?to_be_submit_f='+to_be_submit_f;
	var l=document.createElement('div');
	l.id='l_f_login';
	Ajax({
		url:'/ajax/l_f_login.asp'+form_to,
		type:'GET',
		onSuccess:function(e){
			l.innerHTML=e;
			document.body.appendChild(l);
			showOverlay();
			$(l).fadeIn('fast');
		}
	})
}
/***悬浮注册框加载*****/
function load_regist(to_be_submit_f)
{
    var form_to=''
	if(to_be_submit_f)form_to='?to_be_submit_f='+to_be_submit_f;
	var l=document.createElement('div');
	l.id='l_f_regist';
	Ajax({
		url:'/ajax/l_f_regist.asp'+form_to,
		type:'GET',
		onSuccess:function(e){
			l.innerHTML=e;
			document.body.appendChild(l);
			showOverlay();
			$(l).fadeIn('fast');
		}
	})
}
function f_clear(e)
{
	var o=document.getElementById(e);
	o.parentNode.removeChild(o);
	hideOverlay();	
}
function l_f_login(f,to_be_submit_f)
{
	if(f.l_f_username.value==''||f.l_f_username.value=='邮箱/手机号/用户名'){alert('请输入账户名！');f.l_f_username.focus();return false;}
	if(f.l_f_passwd.value==''){alert('请输入密码！');f.l_f_passwd.focus();return false;}
	try{if(f.checkcode&&!f.checkcode.value){alert('请输入验证码！');return false;}}catch(err){};
	var login_data=yf_serialize(f);
	Ajax({
		url:'/ajax/ajaxLogin.asp',
		data:login_data,
		onSuccess:function(e)
		{
			var r=JSON.parse(e);
			if(r.login_r==1)
			{
				f_clear('l_f_login');
				if(to_be_submit_f)document.getElementById(to_be_submit_f).submit();
				else location.reload();
			}
			else
			{
				alert(r.login_msg);
				if(r.checkcode_r>3)
				{
				    f_clear('l_f_login');
				    load_login(to_be_submit_f);
				}
				else document.getElementById('checkcode_img').src='/common/inc/getcode.asp?t='+Math.random();
			}
		}
	})
	return false;
}

function l_f_regist(f,to_be_submit_f)
{
    if(!is_mobile_phone(f.mobile_number.value)){alert('请输入正确的手机号！');f.mobile_number.focus();return false;};
    if(f.check_code.value==''||f.check_code.value=='请输入您收到的验证码'){alert('请输入您收到的验证码！');f.check_code.focus();return false;};
    if(f.l_f_passwd.value==''||!is_psw(f.l_f_passwd.value)){alert('密码至少为6个字符！');f.l_f_passwd.focus();return false;};
    if(f.l_f_passwd.value!=f.l_f_passwd_confirm.value){alert('密码和确认密码不一致！');f.l_f_passwd_confirm.focus();return false;};
    if(!f.affirm.value){alert('请接受注册条款！');return false;}
    var l_data=yf_serialize(f)
    Ajax({
        url:'/ajax/ajaxRegist.asp',
        data:l_data,
        onSuccess:function(e)
        {
            var r=JSON.parse(e);
            if(r.regist_r==1)
            {
                f_clear('l_f_regist');
				if(to_be_submit_f)document.getElementById(to_be_submit_f).submit();
				else location.reload();
            }
            else
            {
                alert(r.regist_msg);
            }
        }
    })
    return false;
}
function l_f_send_sms(m_input,c_input)
{
    var m=document.getElementById(m_input);
    var c=document.getElementById(c_input);
    if(!is_mobile_phone(m.value)){alert('请输入正确的手机号！');m.focus();return false;};
    var m_data="t_no="+escape(m.value);
    Ajax({
        url:'/user/sms/m_send.asp',
        data:m_data,
        onSuccess:function(e){
            if (e==0){alert ("验证码已发送， 请注意查收！");c.disabled=false;c.focus();}
			else if (e==2){alert("验证码已经发送, 请稍候！");c.disabled=false;c.focus();}
			else if (e==3){alert("此手机号已注册过！");m.value='';m.focus();}
			else if (e==4){alert("请勿重复提交！")}
			else {alert("发送失败，请稍候再试！")}
        }
    })
}

function order_check(form)
{
	is_login({
		t:function(){document.getElementById(form).submit()},
		f:function(){load_login(form);}
	})
	return false;
}

function countAppDownload()
{
//	if(typeof XMLHttpRequest=='undefined')
//	{
//		xml=new ActiveXObject("Microsoft.XMLHTTP");
//		xml.open("GET","http://iframe.ip138.com/ic.asp",false);   
//		xml.send();   
//		kk=xml.ResponseText;   
//		i=kk.indexOf("[");   
//		ie=kk.indexOf("]");   
//		ip=kk.substring(i+1,ie); 
//	}
//	else 
//	{
//	   ip="0.0.0.0"
//	}
   try{
     xml=new ActiveXObject("Microsoft.XMLHTTP");
		xml.open("GET","http://iframe.ip138.com/ic.asp",false);   
		xml.send();   
		kk=xml.ResponseText;   
		i=kk.indexOf("[");   
		ie=kk.indexOf("]");   
		ip=kk.substring(i+1,ie); 
   }catch(e){
   //alert(e);
    ip="0.0.0.001";
   }


   var m_data = ip+"";
    Ajax({
        url:'/ajax/countAppDownloaded.asp',
        data:'m_data = '+ m_data,
        onSuccess:function(e){
          //  alert(e);
	        window.location.href="/forDownload/PhoneGap.apk";
        }
    })
}