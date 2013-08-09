<!--

function showHide(objname)
{
	//只对主菜单设置cookie
	var obj = document.getElementById(objname);
	var objsun = document.getElementById('sun'+objname);
	if(objname.indexOf('_1')<0 || objname.indexOf('_10')>0)
	{
		if(obj.style.display == 'inline' || obj.style.display =='')
			obj.style.display = 'none';
		else
			obj.style.display = 'inline';
		return true;
	}
  //正常设置cookie
	
	if(obj.style.display == 'inline' || obj.style.display =='')
	{
		obj.style.display = 'none';
	}
	else
	{
		obj.style.display = 'inline';
	}
}
//读写cookie函数
function getCookie(c_name)
{
	if (document.cookie.length > 0)
	{
		c_start = document.cookie.indexOf(c_name + "=")
		if (c_start != -1)
		{
			c_start = c_start + c_name.length + 1;
			c_end   = document.cookie.indexOf(";",c_start);
			if (c_end == -1)
			{
				c_end = document.cookie.length;
			}
			return unescape(document.cookie.substring(c_start,c_end));
		}
	}
	return null
}

//检查以前用户展开的菜单项
var totalitem = 12;
function CheckOpenMenu()
{
	//setCookie('menuitems','');
	var ckstr = getCookie('menuitems');
	var curitem = '';
	var curobj = null;
	
	//cross_obj = document.getElementById("staticbuttons");
	//setInterval("initializeIT()",20);
	
	if(ckstr==null)
	{
		ckstr='1_1,2_1,3_1';
		setCookie('menuitems',ckstr,7);
	}
	ckstr = ','+ckstr+',';
	for(i=0;i<totalitem;i++)
	{
		curitem = i+'_'+curopenItem;
		curobj = document.getElementById('items'+curitem);
		if(ckstr.indexOf(curitem) > 0 && curobj != null)
		{
			curobj.style.display = 'inline';
		}
		else
		{
			if(curobj != null) curobj.style.display = 'none';
		}
	}
}

var curitem = 1;
function ShowMainMenu(n)
{
	var curLink = $DE('link'+curitem);
	var targetLink = $DE('link'+n);
	var curCt = $DE('ct'+curitem);
	var targetCt = $DE('ct'+n);
	if(curitem==n) return false;
	if(targetCt.innerHTML!='')
	{
		curCt.style.display = 'none';
		targetCt.style.display = 'inline';
		curLink.className = 'mm';
		targetLink.className = 'mmac';
		curitem = n;
	}
	else
	{
		var myajax = new DedeAjax(targetCt);
		myajax.SendGet2("index_menu_load.php?openitem="+n);
		if(targetCt.innerHTML!='')
		{
			curCt.style.display = 'none';
			targetCt.style.display = 'inline';
			curLink.className = 'mm';
			targetLink.className = 'mmac';
			curitem = n;
		}
		DedeXHTTP = null;
	}
	// bindClick();
}
//全选复选框
function CheckAll(form){
	for (var i=0;i<form.elements.length;i++){
		var e = form.elements[i];
		if (e.name != 'chkall'){
			e.checked = form.chkall.checked;
		}
		if(e.type == 'checkbox' && e.name != 'chkall' && e.name != 'chkall_box2'){
			var obj = e.parentNode.parentNode;
			e.checked ? obj.className="s_click" : obj.className="s_out";
		}
	}
}
//SELECT框提交  跳转到
//参数说明  obj  select传来的值，formname 表单名称 valuestr 传来的参数字符串
function selectsubmit(obj,formname,valuestr){
	var value=obj.value;
	var myform=document.forms[formname];
	var page="?"+valuestr+"="+value;
	myform.action=page;
	myform.submit();
	
}

-->