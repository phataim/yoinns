<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_email.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../sms/m_codepublic.asp"-->
<%
Dim Action
Dim mobile,password,email
Dim isCheckCode,checkcode
Dim opFlag,validcode,userid,reg_code 'mike

loginip = Request.ServerVariables("REMOTE_ADDR")

	Action = Request.QueryString("act")
	Select Case Action
		Case "nextstep"
			Call Nextstep()
		Case Else
				Call Main()
	End Select
	
	Sub Nextstep()
	
		mobile =  Dream3CLS.RSQL("mobile")
		checkcode=  Dream3CLS.RParam("checkcode")
		reg_code=  Dream3CLS.RParam("reg_code") 'mike
		'validate Form
		
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		If mobile = "" Then
			gMsgArr = "�������ֻ��ţ�"
		End If
		'����ֻ��������
		
		If mobile<>"" and not Dream3CLS.validate(mobile,4) Then
			gMsgArr = gMsgArr&"|�ֻ����벻�Ϸ���"
		End If
		
		'�ж����ֻ��Ƿ����
		Sql = "select id from T_User Where mobile='"&mobile&"'" '����ֻ��Ƿ���� 
		rs.open sql,conn,1,1
		if rs.recordcount=0 then '�Ҳ�����¼
			gMsgArr = gMsgArr&"|"&mobile&"���ֻ��Ż�δ����վע�����"
		end if 
		rs.close

		telcode = session("r_no") '��ȡ��֤��
		if telcode="" Then
			gMsgArr = gMsgArr&"|��û����д�ֻ���֤��"
		else
			if reg_code <> telcode then
				gMsgArr= gMsgArr&"|����д���ֻ���֤��"&reg_code&"����ȷ������������"
			end if
		end if
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		If checkcode ="" Then
			gMsgArr = gMsgArr&"|��������֤�룡"
		End If
		
		If len(gMsgArr) > 0 Then 
			gMsgFlag = "E"
			Exit Sub
		End If
		
		If Not Dream3User.CodeIsTrue Then
			gMsgArr = gMsgArr&"|���������֤���ϵͳ�����Ĳ�һ�£�����������!"
			gMsgFlag = "E"
			Exit Sub
		End If


		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike				
		n_pw=Dream3CLS.GetRandomize(6) '������
		Sql = "select * from T_User Where mobile='"&mobile&"'"
		Rs.open Sql,conn,1,2
			rs("password")=MD5(n_pw) 'md5����
		Rs.Update
		
		Rs.Close		
		
		text_r_no1="�𾴵ġ����ùݡ��û�, �����Ѿ�Ϊ����������µ����� "&n_pw&" ,�����ڿ���ʹ���������¼��! �����ùݡ�"
	
		if sms_open=0 then
			at=mt(mobile,text_r_no1,ext,stime,rrid) '��Զ�̵�ַ������
		end if

		user_mobile=mobile
		user_r_no1=n_pw
		user_r_no2=""
		user_r_no3=mobile
		user_order_id=0
		user_order_name="forgetPW_send_OK"
		user_is_back=0
				
		call sms_save(user_mobile,user_r_no1,user_r_no2,user_r_no3,user_order_id,user_order_name,at2,user_is_back,3) '�û�����

		''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' mike
		If gMsgFlag = "E" Then
			Exit Sub
		End If
		opFlag = "showresult"
		
	End Sub

	
	Sub Main()	

	End Sub
	
%>
<!--#include file="../../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<!--mike -->
<script language="javascript" src="../sms/m_js.js"></script>
<!--mike -->


<form class="validator" method="post" action="?act=nextstep" id="loginForm" name="loginForm">
<div class="area">
	
    <div class="reg_cente">
		<%
		If opFlag <> "showresult" Then
		%>
    	<div class="reg_left">
        	<dl>
                <!--mike -->
            	<dt>��������</dt>
                <dd>��һ��������д��ע��ʱ���ֻ���
				<input type="text" value="<%=mobile%>" class="reg_txt" id="mobile" name="mobile" style="width:215px"> <input name="regcodesub" type="button" value="������֤��" onclick="send_sms_p()" style="width:80px;height:25px" />
				</dd>
                <dd>�ڶ���������д�ֻ��յ�����֤��
				<input type="text" value="" class="reg_txt" id="reg_code" name="reg_code" style="width:215px" onkeydown="check_r_no();" onkeyup="check_r_no();" onclick="check_r_no();" ><!--mike --><span id="is_ok_reg"></span><!--mike -->
				</dd>
				<dd>��������ҳ�������֤�룺
                <!--mike -->
				<input name="checkcode" type="text" class="reg_txt" id="checkcode" size="5" maxlength="4" onFocus="get_checkcode();this.onfocus=null;" onKeyUp="ajaxcheckcode('check_code','checkcode');" style="width:215px"/>
		  <BR><span id="img_checkcode" style="cursor:pointer;" onClick="get_checkcode();">�����ȡ��֤��</span><span id="isok_checkcode"></span>
				</dd>
            </dl>
            
            <p><a class="login_bottom" href="#" onclick="document.loginForm.submit();">��һ��!</a></p>
        </div>
		
		<%Else%>
		<div class="reg_left">
        	<dl>
            	<dt>��ʾ</dt>
                <dd>�µ������ѷ��͵������ֻ���<br>
				�뱣�ܺ��������룬������ɲ���Ҫ����ʧ��<br><br>
				</dd>
				
            </dl>
        </div>
		<%End If%>
        <div class="reg_right">
            <dl>
                <dt class="font18">��û��<%=Dream3CLS.SiteConfig("SiteShortName")%>�˻���</dt>
                <dd><a class="reg_log" href="signup.asp">ע��</a></dd>
            </dl>
        </div>
    </div>
    
</div>
</form>

<script language="javascript">
<!--//
var show_checkcode = false;
function get_checkcode() {
	var chkCodeFile = "../../common/inc/getcode.asp";
	if(!show_checkcode){
		if(document.getElementById("img_checkcode"))
			document.getElementById("img_checkcode").innerHTML = '<img  id="checkcodeimg" src="'+chkCodeFile+'?t='+Math.random()+'" alt="���ˢ����֤��" style="cursor:pointer;border:0;vertical-align:middle;height:18px;" onclick="this.src=\''+chkCodeFile+'?t=\'+Math.random()" />'
			show_checkcode = true;

		if(document.getElementById("isok_checkcode"))
			document.getElementById("isok_checkcode").innerHTML = '<a href="javascript://" onclick="setTimeout(function(){ document.getElementById(\'checkcodeimg\').src=\''+chkCodeFile+'?t=\'+Math.random()},100);">������<\/a>';
	}
}
//-->
</script>
<!--#include file="../../common/inc/footer_user.asp"-->