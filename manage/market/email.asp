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
        <span class="fl">�ʼ�Ⱥ��</span>
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
                            <label>Email��ַ</label>
                            <textarea cols="45" rows="5" name="email" id="email" class="f-textarea"><%=email%></textarea>
							���E-Mail��ַ����Ӣ�Ķ��š�,���ֿ�
                        </div>
						<div class="field">
                            <label>Email����</label>
							 <input type="text" size="30" name="mailtitle" id="mailtitle" class="f-input" value=""/> 
                        </div>
                        <div class="field">
                            <label>Email����</label>
							<textarea id="mailcontent" name="mailcontent" class="xheditor" rows="20" cols="50" style="width: 70%"><%=content%></textarea>
							
                        </div>
                        <div class="act">
                            <input type="button" value="����" name="btnSend" id="btnSend" class="formbutton"/>
                        </div>
                    </form>
                </div>

	</div>
	
<script type="text/javascript">

$(document).ready(function ()
{
//$.post()��ʽ��
$('#btnSend').click(function (){
	  if($('#email').val() == ""){
	  	alert("������Email");
		return;
	  }
	  if($('#mailtitle').val() == ""){
	  	alert("�������ʼ�����");
		return;
	  }
	  if($('#mailcontent').val() == ""){
	  	alert("�������ʼ�����");
		return;
	  }
	  $("#btnSend").attr('disabled','true'); 
	  $("#btnSend").attr('value','���ڷ��ͣ����Ժ�......'); 
      $.post(
      '<%=VirtualPath%>/ajax/sendMarketEmail.asp',
      {
        email:$('#email').val(),
		mailtitle:escape($('#mailtitle').val()),
        mailcontent:escape($('#mailcontent').val())
      }, 
   
   function (data) //�ش�����
      {
   		show_result(data)
      },
   'html'
   ); 
   });
   
});

function show_result(json) //�ش�����ʵ�壬����ΪXMLhttpRequest.responseText
{
	alert(json);
	$("#btnSend").removeAttr("disabled");//����ť����
	$("#btnSend").attr('value','���·���'); 
}

</script>

	
<!--#include file="../../common/inc/footer_manage.asp"-->