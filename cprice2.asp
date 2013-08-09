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
	

	'验证表单
	Call validateSubmit()

	
	
	If len(gMsgArr) > 0 Then 
		gMsgFlag = "E"
		
		Exit Sub
	End If
	
	'开始保存
	
	
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
	Dream3CLS.showMsg "恭喜，修改价格成功！","S", directPage
	
	
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
		Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
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
	' 设置不显示
	If maxday = 0 Then maxday = ""
	refundday = Rs("refundday")
	paymentRules = Rs("paymentRules")
	dayrentprice = Rs("dayrentprice")
	weekrentprice = Rs("weekrentprice")
	monthrentprice = Rs("monthrentprice")

End Sub

Sub validateSubmit()

	If  minday <=0 Then
		gMsgArr = gMsgArr&"|最少天数必须大于0！"
	End If
	If  dayrentprice <=0 Then
		gMsgArr = gMsgArr&"|日租价必须大于0！请重新设置！谢谢！"
	End If
	If weekrentprice<=0 Then
	    gMsgArr = gMsgArr&"|周末价必须大于0！请重新设置！谢谢！"
	End If
	
	If weekrentprice <> 0 Then
		If  weekrentprice <= dayrentprice Then
			gMsgArr = gMsgArr&"|周末价必须大于平时日租价！"
		Else
			'If  (weekrentprice > (dayrentprice * 7)) Then
			'	gMsgArr = gMsgArr&"|周末租价不能大于平日租价太多！"
		'	End If
		End If
	End If
	
	If monthrentprice <> 0 Then
		If weekrentprice <> 0 Then
			If  monthrentprice <= weekrentprice Then
				gMsgArr = gMsgArr&"|月租价必须大于周末租价！"
			End If
		End If
		
		If  monthrentprice <= dayrentprice Then
			gMsgArr = gMsgArr&"|月租价必须大于日租价！"
		Else
			If  monthrentprice > (dayrentprice * 30) Then
				gMsgArr = gMsgArr&"|月租价不能大于30天*日租价！"
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
G_Title_Content = "发布系统"
%>
<!--#include file="common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="common/js/tools.js"></script>
<script type="text/javascript" src="common/js/calendar.js"></script> 
<script type="text/javascript" src="common/js/common.js"></script> 

<form class="validator"  action="?act=save" method="post" id="productForm" name="productForm">
<div class="area">
	
    <div class="Details-tit">
    	<span class="t6"><b><a href="pstep1.asp?pid=<%=pid%>">房间详情</a></b></span>
        <span class="t8"><b><a href="pstep2.asp?pid=<%=pid%>">上传照片</a></b></span>
        <span class="t10"><b><a href="pstep3.asp?pid=<%=pid%>">设施服务</a></b></span>
        <span class="t11"><b>入住与价格</b></span>
        <span class="t5"><b>预览</b></span>
    </div>
    
	<!--#include file="common/inc/publish_header.asp"-->
    
    <div class="layer2">
        <div class="side-top"></div>
        <div class="side-center">
            <div class="detail-left">
                <h4 class="title">入住与价格</h4>
                <dl>
                    <dd>
                        <label class="spe">入住时间：</label>
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
                        <label class="spe">退房时间：</label>
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
                        <label class="spe">最少天数：</label>
                        <input type="text" value="<%=minday%>" id="minday" name="minday" style="width:39px;" class="radius input">天
                        <span style="color:red">&nbsp;&nbsp;*</span>
                        <span id="tip_minday"></span>
                    </dd>
                    <dd class="grade_dd_price" id="_MinDays"></dd>
                    <dd>
                        <label class="spe">最多天数：</label>
                        <input type="text" value="<%=maxday%>" id="maxday" name="maxday" style="width:39px;" class="radius input">天&nbsp;&nbsp;(默认无限制)
                    	<span id="tip_maxday"></span>
                    </dd>
                    <dd class="grade_dd_price" id="_MaxDays"></dd>
                    <dd style="display:none ">
                        <label class="spe">全额退款日：</label>
                        <select onchange="setRefundDayWords();" name="refundday" id="refundday">
                        <option selected="" cday="1" value="1" <%If refundday="1" then Response.Write("selected")%>>1天</option>
                        <option cday="3" value="3" <%If refundday="3" then Response.Write("selected")%>>3天</option>
                        <option cday="5" value="5" <%If refundday="5" then Response.Write("selected")%>>5天</option>
                        <option cday="7" value="7" <%If refundday="7" then Response.Write("selected")%>>7天</option>
                        <option cday="15" value="15" <%If refundday="15" then Response.Write("selected")%>>15天</option>
                        <option cday="30" value="30" <%If refundday="30" then Response.Write("selected")%>>30天</option>                    
                        </select>
                    </dd>
                    <dd style="display:none ">
                        <label class="spe">付款规则：</label>
                        <select onchange="cancelRule();DisRules();" name="paymentRules" id="paymentRules">
                        <option value ="moststrict" selected cancelrate="100" punishrate="100" firstpayrate="100" <%If paymentRules="moststrict" then Response.Write("selected")%>>严格</option>
						<option value ="morestrict" cancelrate="50" punishrate="50" firstpayrate="100" <%If paymentRules="morestrict" then Response.Write("selected")%>>比较严格</option>
						<option value ="middle" cancelrate="100" punishrate="100" firstpayrate="50" <%If paymentRules="middle" then Response.Write("selected")%>>中等</option>
						<option value ="moreloose" cancelrate="50" punishrate="50" firstpayrate="50" <%If paymentRules="moreloose" then Response.Write("selected")%>>比较宽松</option>
						<option value ="mostloose" cancelrate="100" punishrate="100" firstpayrate="20" <%If paymentRules="mostloose" then Response.Write("selected")%>>宽松</option>
                        </select>
                    </dd>
                </dl>
            </div>
            
            <div class="detail-right">
                <dl style="color:#ccc;">以下价格中的8%将作为服务费，填写价格可酌情考虑</dl>
                <dl>
                	<dd>
                    <label>日租(周日到周四)价：</label>
                    <input type="text"  name="dayrentprice" class="radius input" value="<%=dayrentprice%>" onchange="change_normalprice_commit(<%=pid %>,1)">元/每晚<span style="color:red">*</span>
                    <span id="tip_daypriceunit"></span>
                    </dd>
                    <dd>
                    <label>周末(周五周六)价：</label>
                    <input type="text" name="weekrentprice" class="radius input" value="<%=weekrentprice%>" onchange="change_normalprice_commit(<%=pid %>,2)">元/每晚<span style="color:red">*</span>

                    <span id="tip_weekpriceunit"></span>
                    </dd>
                    <!--<dd>
                    <label>月租价：</label>
                    <input type="text" name="monthrentprice" class="radius input" value="<%=monthrentprice%>">元/每月
                    <span id="tip_monthpriceunit"></span>
                    </dd>-->
                </dl>
            </div>
                     <div class="text">
                
				<!--#include file="calender/calender_business.asp"-->

                
             </div> 
            <div id="cancelruleshow" class="text">
            	<b>交易规则</b>：<br>
                <ul style="list-style-type:disc;padding-left:25px;">
                    <li style="display:none ">订单确认后，在线支付总房款的<b style="color:#ff0000;">100%</b>。</li>
                    <li style="display:none ">房客在入住日前<b id="str1" style="color:#ff0000;">1</b>天（全额退款日）14:00之前取消，预付订金全部退还。</li>
                    <li style="display:none ">房客在入住日前<b id="str2" style="color:#ff0000;">1</b>天的14:00之后，入住日的14:00之前取消订单，预付订金扣除<b style="color:#ff0000;">100%</b>。</li>
                    <li style="display:none">房客入住后提前退房，<%=Dream3CLS.SiteConfig("SiteName")%>与房东将分别从剩余天数的订金和线下付款中扣除<b style="color:#ff0000;">100%</b> 。</li>
                    <li style="display:none ">订单的取消时间以<%=Dream3CLS.SiteConfig("SiteName")%>系统中记录的订单取消时间为准。</li>
                    <li>额外的服务费用和押金不包含在总房租内，由房东线下收取。</li>
                </ul>
            </div>
            
            <div class="clear"></div>
            
        </div>
       	<div class="side-bottom"></div>
        </div>
      	<!---layer2 end-->
        <div class="next">
			<dl>
				<!--<dt class="Button-3 font14_white"><a href="pstep3.asp?act=showedit&pid=<%=pid%>">上一步</a></dt>-->
				<dd><input type="submit" id="searchBt" value="完成" class="input_next"></dd>
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
                $("#wordcount")[0].firstChild.nodeValue = "您已输入0";  
                $str.html(length);  
            }else{  
                $("#wordcount")[0].firstChild.nodeValue = "您已输入";  
                $str.html(length);  
            }  
        }  
    }  
});  

*/
</script>

<!--#include file="common/inc/footer_user.asp"-->