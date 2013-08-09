<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<%
Dim Action
Dim askid,Rs
Dim mailcontent,email

	Action = Request.QueryString("act")
	Select Case Action
		   Case "save"
		   		Call Reply()
		   Case Else
				Call Main()
	End Select
	
	Sub Reply()
		askid = Dream3CLS.ChkNumeric(Request("askid"))
	

	End Sub
	

	
	Sub Main()		

	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<script type="text/javascript" src="../../common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="../../xheditor/xheditor-zh-cn.min.js"></script>

<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl">邮件群发</span>
        <span class="fr">
        	
        </span>
    </div>
    <div class="say">
        
    </div>
</div>

<div id="box">

                <div class="sect">
                    <form id="myform" method="post" action="?act=send">
						<input type="hidden" name="id" value="1" />
                        <div class="field">
                            <label>Email地址</label>
                            <textarea cols="45" rows="5" name="email" id="email" class="f-textarea"><%=email%></textarea>
							多个E-Mail地址请用英文逗号“,”分开
                        </div>
						<div class="field">
                            <label>Email标题</label>
							 <input type="text" size="30" name="mailtitle" id="mailtitle" class="f-input" value=""/> 
                        </div>
                        <div class="field">
                            <label>Email内容</label>
							<textarea id="mailcontent" name="mailcontent" class="xheditor" rows="20" cols="50" style="width: 70%"><%=content%></textarea>
							
                        </div>
                        <div class="act">
                            <input type="button" value="发送" name="btnSend" id="btnSend" class="formbutton"/>
                        </div>
                    </form>
                </div>

	</div>
	
<script type="text/javascript">

$(document).ready(function ()
{
//$.post()方式：
$('#btnSend').click(function (){
	  if($('#email').val() == ""){
	  	alert("请输入Email");
		return;
	  }
	  if($('#mailtitle').val() == ""){
	  	alert("请输入邮件标题");
		return;
	  }
	  if($('#mailcontent').val() == ""){
	  	alert("请输入邮件内容");
		return;
	  }
	  $("#btnSend").attr('disabled','true'); 
	  $("#btnSend").attr('value','正在发送，请稍后......'); 
      $.post(
      '<%=VirtualPath%>/ajax/sendMarketEmail.asp',
      {
        email:$('#email').val(),
		mailtitle:escape($('#mailtitle').val()),
        mailcontent:escape($('#mailcontent').val())
      }, 
   
   function (data) //回传函数
      {
   		show_result(data)
      },
   'html'
   ); 
   });
   
});

function show_result(json) //回传函数实体，参数为XMLhttpRequest.responseText
{
	alert(json);
	$("#btnSend").removeAttr("disabled");//将按钮可用
	$("#btnSend").attr('value','重新发送'); 
}

</script>

	
<!--#include file="../../common/inc/footer_manage.asp"-->