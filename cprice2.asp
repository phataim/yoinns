<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<%
Dim Action
Dim pid
Dim checkintime,checkouttime,minday,maxday,refundday,paymentRules,dayrentprice,weekrentprice,monthrentprice

Action = Request.QueryString("act")
Select Case Action
	Case "save"
		Call SaveRecord()
	Case "showedit"
		Call ShowEdit()
	Case Else
		Call Main()
End Select

Sub SaveRecord()
 	pid = Dream3CLS.ChkNumeric(Request.Form("pid"))
	
	checkintime = Dream3CLS.RParam("checkintime")
	checkouttime = Dream3CLS.RParam("checkouttime")
	minday = Dream3CLS.RNum("minday")
	maxday = Dream3CLS.RNum("maxday")
	refundday = Dream3CLS.RNum("refundday")
	paymentRules = Dream3CLS.RParam("paymentRules")
	dayrentprice = Dream3CLS.RNum("dayrentprice")
	weekrentprice = Dream3CLS.RNum("weekrentprice")
	monthrentprice = Dream3CLS.RNum("monthrentprice")
	

	'��֤��
	Call validateSubmit()

	
	
	If len(gMsgArr) > 0 Then 
		gMsgFlag = "E"
		
		Exit Sub
	End If
	
	'��ʼ����
	
	
	Set Rs = Server.CreateObject("Adodb.recordset")
	Sql = "Select * from T_Product"
	If pid <> 0 Then
		If Session("_IsManager") = "Y" Then
			Sql = Sql & " Where ID="&pid
		Else
			Sql = Sql & " Where ID="&pid&" and user_id="&Session("_UserID")
		End If
	End If
	
	Rs.open Sql,conn,1,2


	Rs("checkintime") = checkintime
	Rs("checkouttime") = checkouttime
	Rs("minday") = minday
	Rs("maxday") = maxday
	Rs("refundday") = refundday
	Rs("paymentRules") = paymentRules
	Rs("dayrentprice") = dayrentprice
	Rs("weekrentprice") = weekrentprice
	Rs("monthrentprice") = monthrentprice
	
	Rs("state") = "auditing" 
	
	Rs.Update

	Rs.Close
	Set Rs = Nothing
	
	
	directPage = VirtualPath&"/user/company/myroom.asp"
	
	'response.Redirect(directPage)
	Dream3CLS.showMsg "��ϲ���޸ļ۸�ɹ���","S", directPage
	
	
End Sub

Sub ShowEdit()
	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	If Session("_IsManager") = "Y" Then
		Sql = "Select * from T_Product Where id="&Pid
	Else
		Sql = "Select * from T_Product Where id="&Pid&"  and user_id="&Session("_UserID")
	End If
	Set Rs = Dream3CLS.Exec(Sql)
	If Rs.EOF Then
		Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
		response.End()
	End If
	
	
	checkintime = Rs("checkintime")
	checkouttime = Rs("checkouttime") 
	
	if Len(checkintime) = 0  Then
		checkintime = "14:00:00"
		checkouttime = "12:00:00"
	End if
	
	minday= Rs("minday")
	maxday = Rs("maxday")
	' ���ò���ʾ
	If maxday = 0 Then maxday = ""
	refundday = Rs("refundday")
	paymentRules = Rs("paymentRules")
	dayrentprice = Rs("dayrentprice")
	weekrentprice = Rs("weekrentprice")
	monthrentprice = Rs("monthrentprice")

End Sub

Sub validateSubmit()

	If  minday <=0 Then
		gMsgArr = gMsgArr&"|���������������0��"
	End If
	If  dayrentprice <=0 Then
		gMsgArr = gMsgArr&"|����۱������0�����������ã�лл��"
	End If
	If weekrentprice<=0 Then
	    gMsgArr = gMsgArr&"|��ĩ�۱������0�����������ã�лл��"
	End If
	
	If weekrentprice <> 0 Then
		If  weekrentprice <= dayrentprice Then
			gMsgArr = gMsgArr&"|��ĩ�۱������ƽʱ����ۣ�"
		Else
			'If  (weekrentprice > (dayrentprice * 7)) Then
			'	gMsgArr = gMsgArr&"|��ĩ��۲��ܴ���ƽ�����̫�࣡"
		'	End If
		End If
	End If
	
	If monthrentprice <> 0 Then
		If weekrentprice <> 0 Then
			If  monthrentprice <= weekrentprice Then
				gMsgArr = gMsgArr&"|����۱��������ĩ��ۣ�"
			End If
		End If
		
		If  monthrentprice <= dayrentprice Then
			gMsgArr = gMsgArr&"|����۱����������ۣ�"
		Else
			If  monthrentprice > (dayrentprice * 30) Then
				gMsgArr = gMsgArr&"|����۲��ܴ���30��*����ۣ�"
			End If
		End If
	End If
	
End Sub

Sub validateDraft()

End Sub




Sub Main()	
	
	Call ShowEdit()

End Sub

%>
<%
G_Title_Content = "����ϵͳ"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="common/js/tools.js"></script>
<script type="text/javascript" src="common/js/calendar.js"></script> 
<script type="text/javascript" src="common/js/common.js"></script> 

<form class="validator"  action="?act=save" method="post" id="productForm" name="productForm">
<div class="area">
	
    <div class="Details-tit">
    	<span class="t6"><b><a href="pstep1.asp?pid=<%=pid%>">��������</a></b></span>
        <span class="t8"><b><a href="pstep2.asp?pid=<%=pid%>">�ϴ���Ƭ</a></b></span>
        <span class="t10"><b><a href="pstep3.asp?pid=<%=pid%>">��ʩ����</a></b></span>
        <span class="t11"><b>��ס��۸�</b></span>
        <span class="t5"><b>Ԥ��</b></span>
    </div>
    
	<!--#include file="common/inc/publish_header.asp"-->
    
    <div class="layer2">
        <div class="side-top"></div>
        <div class="side-center">
            <div class="detail-left">
                <h4 class="title">��ס��۸�</h4>
                <dl>
                    <dd>
                        <label class="spe">��סʱ�䣺</label>
                        <select class="w-input" name="checkintime">
                        <option value ="00:00:00" <%If checkintime="00:00:00" then Response.Write("selected")%>>00:00</option>
						<option value ="01:00:00" <%If checkintime="01:00:00" then Response.Write("selected")%>>01:00</option>
						<option value ="02:00:00" <%If checkintime="02:00:00" then Response.Write("selected")%>>02:00</option>
						<option value ="03:00:00" <%If checkintime="03:00:00" then Response.Write("selected")%>>03:00</option>
						<option value ="04:00:00" <%If checkintime="04:00:00" then Response.Write("selected")%>>04:00</option>
						<option value ="05:00:00" <%If checkintime="05:00:00" then Response.Write("selected")%>>05:00</option>
						<option value ="06:00:00" <%If checkintime="06:00:00" then Response.Write("selected")%>>06:00</option>
						<option value ="07:00:00" <%If checkintime="07:00:00" then Response.Write("selected")%>>07:00</option>
						<option value ="08:00:00" <%If checkintime="08:00:00" then Response.Write("selected")%>>08:00</option>
						<option value ="09:00:00" <%If checkintime="09:00:00" then Response.Write("selected")%>>09:00</option>
						<option value ="10:00:00" <%If checkintime="10:00:00" then Response.Write("selected")%>>10:00</option>
						<option value ="11:00:00" <%If checkintime="11:00:00" then Response.Write("selected")%>>11:00</option>
						<option value ="12:00:00" <%If checkintime="12:00:00" then Response.Write("selected")%>>12:00</option>
						<option value ="13:00:00" <%If checkintime="13:00:00" then Response.Write("selected")%>>13:00</option>
						<option value ="14:00:00" <%If checkintime="14:00:00" then Response.Write("selected")%>>14:00</option>
						<option value ="15:00:00" <%If checkintime="15:00:00" then Response.Write("selected")%>>15:00</option>
						<option value ="16:00:00" <%If checkintime="16:00:00" then Response.Write("selected")%>>16:00</option>
						<option value ="17:00:00" <%If checkintime="17:00:00" then Response.Write("selected")%>>17:00</option>
						<option value ="18:00:00" <%If checkintime="18:00:00" then Response.Write("selected")%>>18:00</option>
						<option value ="19:00:00" <%If checkintime="19:00:00" then Response.Write("selected")%>>19:00</option>
						<option value ="20:00:00" <%If checkintime="20:00:00" then Response.Write("selected")%>>20:00</option>
						<option value ="21:00:00" <%If checkintime="21:00:00" then Response.Write("selected")%>>21:00</option>
						<option value ="22:00:00" <%If checkintime="22:00:00" then Response.Write("selected")%>>22:00</option>
						<option value ="23:00:00" <%If checkintime="23:00:00" then Response.Write("selected")%>>23:00</option>
                        </select>
                    </dd>
                    <dd>
                        <label class="spe">�˷�ʱ�䣺</label>
                        <select class="w-input" name="checkouttime">
                        <option value ="00:00:00" <%If checkouttime="00:00:00" then Response.Write("selected")%>>00:00</option>
						<option value ="01:00:00" <%If checkouttime="01:00:00" then Response.Write("selected")%>>01:00</option>
						<option value ="02:00:00" <%If checkouttime="02:00:00" then Response.Write("selected")%>>02:00</option>
						<option value ="03:00:00" <%If checkouttime="03:00:00" then Response.Write("selected")%>>03:00</option>
						<option value ="04:00:00" <%If checkouttime="04:00:00" then Response.Write("selected")%>>04:00</option>
						<option value ="05:00:00" <%If checkouttime="05:00:00" then Response.Write("selected")%>>05:00</option>
						<option value ="06:00:00" <%If checkouttime="06:00:00" then Response.Write("selected")%>>06:00</option>
						<option value ="07:00:00" <%If checkouttime="07:00:00" then Response.Write("selected")%>>07:00</option>
						<option value ="08:00:00" <%If checkouttime="08:00:00" then Response.Write("selected")%>>08:00</option>
						<option value ="09:00:00" <%If checkouttime="09:00:00" then Response.Write("selected")%>>09:00</option>
						<option value ="10:00:00" <%If checkouttime="10:00:00" then Response.Write("selected")%>>10:00</option>
						<option value ="11:00:00" <%If checkouttime="11:00:00" then Response.Write("selected")%>>11:00</option>
						<option value ="12:00:00" <%If checkouttime="12:00:00" then Response.Write("selected")%>>12:00</option>
						<option value ="13:00:00" <%If checkouttime="13:00:00" then Response.Write("selected")%>>13:00</option>
						<option value ="14:00:00" <%If checkouttime="14:00:00" then Response.Write("selected")%>>14:00</option>
						<option value ="15:00:00" <%If checkouttime="15:00:00" then Response.Write("selected")%>>15:00</option>
						<option value ="16:00:00" <%If checkouttime="16:00:00" then Response.Write("selected")%>>16:00</option>
						<option value ="17:00:00" <%If checkouttime="17:00:00" then Response.Write("selected")%>>17:00</option>
						<option value ="18:00:00" <%If checkouttime="18:00:00" then Response.Write("selected")%>>18:00</option>
						<option value ="19:00:00" <%If checkouttime="19:00:00" then Response.Write("selected")%>>19:00</option>
						<option value ="20:00:00" <%If checkouttime="20:00:00" then Response.Write("selected")%>>20:00</option>
						<option value ="21:00:00" <%If checkouttime="21:00:00" then Response.Write("selected")%>>21:00</option>
						<option value ="22:00:00" <%If checkouttime="22:00:00" then Response.Write("selected")%>>22:00</option>
						<option value ="23:00:00" <%If checkouttime="23:00:00" then Response.Write("selected")%>>23:00</option>
                        </select>
                    </dd>
                    <dd>
                        <label class="spe">����������</label>
                        <input type="text" value="<%=minday%>" id="minday" name="minday" style="width:39px;" class="radius input">��
                        <span style="color:red">&nbsp;&nbsp;*</span>
                        <span id="tip_minday"></span>
                    </dd>
                    <dd class="grade_dd_price" id="_MinDays"></dd>
                    <dd>
                        <label class="spe">���������</label>
                        <input type="text" value="<%=maxday%>" id="maxday" name="maxday" style="width:39px;" class="radius input">��&nbsp;&nbsp;(Ĭ��������)
                    	<span id="tip_maxday"></span>
                    </dd>
                    <dd class="grade_dd_price" id="_MaxDays"></dd>
                    <dd style="display:none ">
                        <label class="spe">ȫ���˿��գ�</label>
                        <select onchange="setRefundDayWords();" name="refundday" id="refundday">
                        <option selected="" cday="1" value="1" <%If refundday="1" then Response.Write("selected")%>>1��</option>
                        <option cday="3" value="3" <%If refundday="3" then Response.Write("selected")%>>3��</option>
                        <option cday="5" value="5" <%If refundday="5" then Response.Write("selected")%>>5��</option>
                        <option cday="7" value="7" <%If refundday="7" then Response.Write("selected")%>>7��</option>
                        <option cday="15" value="15" <%If refundday="15" then Response.Write("selected")%>>15��</option>
                        <option cday="30" value="30" <%If refundday="30" then Response.Write("selected")%>>30��</option>                    
                        </select>
                    </dd>
                    <dd style="display:none ">
                        <label class="spe">�������</label>
                        <select onchange="cancelRule();DisRules();" name="paymentRules" id="paymentRules">
                        <option value ="moststrict" selected cancelrate="100" punishrate="100" firstpayrate="100" <%If paymentRules="moststrict" then Response.Write("selected")%>>�ϸ�</option>
						<option value ="morestrict" cancelrate="50" punishrate="50" firstpayrate="100" <%If paymentRules="morestrict" then Response.Write("selected")%>>�Ƚ��ϸ�</option>
						<option value ="middle" cancelrate="100" punishrate="100" firstpayrate="50" <%If paymentRules="middle" then Response.Write("selected")%>>�е�</option>
						<option value ="moreloose" cancelrate="50" punishrate="50" firstpayrate="50" <%If paymentRules="moreloose" then Response.Write("selected")%>>�ȽϿ���</option>
						<option value ="mostloose" cancelrate="100" punishrate="100" firstpayrate="20" <%If paymentRules="mostloose" then Response.Write("selected")%>>����</option>
                        </select>
                    </dd>
                </dl>
            </div>
            
            <div class="detail-right">
                <dl style="color:#ccc;">���¼۸��е�8%����Ϊ����ѣ���д�۸�����鿼��</dl>
                <dl>
                	<dd>
                    <label>����(���յ�����)�ۣ�</label>
                    <input type="text"  name="dayrentprice" class="radius input" value="<%=dayrentprice%>" onchange="change_normalprice_commit(<%=pid %>,1)">Ԫ/ÿ��<span style="color:red">*</span>
                    <span id="tip_daypriceunit"></span>
                    </dd>
                    <dd>
                    <label>��ĩ(��������)�ۣ�</label>
                    <input type="text" name="weekrentprice" class="radius input" value="<%=weekrentprice%>" onchange="change_normalprice_commit(<%=pid %>,2)">Ԫ/ÿ��<span style="color:red">*</span>

                    <span id="tip_weekpriceunit"></span>
                    </dd>
                    <!--<dd>
                    <label>����ۣ�</label>
                    <input type="text" name="monthrentprice" class="radius input" value="<%=monthrentprice%>">Ԫ/ÿ��
                    <span id="tip_monthpriceunit"></span>
                    </dd>-->
                </dl>
            </div>
                     <div class="text">
                
				<!--#include file="calender/calender_business.asp"-->

                
             </div> 
            <div id="cancelruleshow" class="text">
            	<b>���׹���</b>��<br>
                <ul style="list-style-type:disc;padding-left:25px;">
                    <li style="display:none ">����ȷ�Ϻ�����֧���ܷ����<b style="color:#ff0000;">100%</b>��</li>
                    <li style="display:none ">��������ס��ǰ<b id="str1" style="color:#ff0000;">1</b>�죨ȫ���˿��գ�14:00֮ǰȡ����Ԥ������ȫ���˻���</li>
                    <li style="display:none ">��������ס��ǰ<b id="str2" style="color:#ff0000;">1</b>���14:00֮����ס�յ�14:00֮ǰȡ��������Ԥ������۳�<b style="color:#ff0000;">100%</b>��</li>
                    <li style="display:none">������ס����ǰ�˷���<%=Dream3CLS.SiteConfig("SiteName")%>�뷿�����ֱ��ʣ�������Ķ�������¸����п۳�<b style="color:#ff0000;">100%</b> ��</li>
                    <li style="display:none ">������ȡ��ʱ����<%=Dream3CLS.SiteConfig("SiteName")%>ϵͳ�м�¼�Ķ���ȡ��ʱ��Ϊ׼��</li>
                    <li>����ķ�����ú�Ѻ�𲻰������ܷ����ڣ��ɷ���������ȡ��</li>
                </ul>
            </div>
            
            <div class="clear"></div>
            
        </div>
       	<div class="side-bottom"></div>
        </div>
      	<!---layer2 end-->
        <div class="next">
			<dl>
				<!--<dt class="Button-3 font14_white"><a href="pstep3.asp?act=showedit&pid=<%=pid%>">��һ��</a></dt>-->
				<dd><input type="submit" id="searchBt" value="���" class="input_next"></dd>
			</dl>
		</div>
        <div class="clear"></div>
    </div>
    
</div>
<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
</form>

<script type="text/javascript">

function setRefundDayWords(){
	var $refundday = $('#refundday');  
    var $str1  =  $('#str1');  
	var $str2  =  $('#str2'); 
	$str1.html($refundday); 
}

/*
$(function(){  
    var $refundday = $('#refundday');  
    var $str1  =  $('#str1');  
	var $str2  =  $('#str2'); 
    var time;  

    $refundday.focus(function(){  
        time = window.setInterval( substring,100 );  
    });  

    function substring() {  
        var val = $refundday.val();  
		alert(val);
		/*
        if( $str.html() != (length) ){  
            if(length==0){  
                $("#wordcount")[0].firstChild.nodeValue = "��������0";  
                $str.html(length);  
            }else{  
                $("#wordcount")[0].firstChild.nodeValue = "��������";  
                $str.html(length);  
            }  
        }  
    }  
});  

*/
</script>

<!--#include file="common/inc/footer_user.asp"-->