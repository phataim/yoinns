<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<%
Dim Action
Dim Rs
Dim smscontent,mobile

	Action = Request.QueryString("act")
	Select Case Action
		   Case Else
				Call Main()
	End Select
	
	Sub Main()		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<script type="text/javascript" src="../../common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="../../xheditor/xheditor-zh-cn.min.js"></script>

<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl">����Ⱥ��</span>
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
                            <label>�ֻ�����</label>
                            <textarea cols="45" rows="5" name="mobile" id="mobile" class="f-textarea"></textarea>
							����ֻ���������Ӣ�Ķ��š�,���ֿ�
                        </div>
						<div class="field">
                            <label>��������</label>
							 <textarea cols="45" rows="5" name="smscontent" id="smscontent" class="f-textarea"></textarea> 
							 ����70�������ڣ�1����ĸ��1�����ֶ���Ϊ��1���֣���ǰ <p id="wordcount">��������<font id="str" color="#FF0000">0</font>��  </p>�ַ�
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
	  if($('#mobile').val() == ""){
	  	alert("�������ֻ�����");
		return;
	  }
	  if($('#smscontent').val() == ""){
	  	alert("�������������");
		return;
	  }
	  $("#btnSend").attr('disabled','true'); 
	  $("#btnSend").attr('value','���ڷ��ͣ����Ժ�......'); 
      $.get(
      '<%=VirtualPath%>/ajax/sendMarketSMS.asp',
      {
        mobile:$('#mobile').val(),
        smscontent:escape($('#smscontent').val())
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

$(function(){  
    var $smscontent = $('#smscontent');  
    var $str  =  $('#str');  
    var time;  

    $smscontent.focus(function(){  
        time = window.setInterval( substring,100 );  
    });  

    function substring() {  
        var val = $smscontent.val();  
        var length = val.length;  
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
</script>

	
<!--#include file="../../common/inc/footer_manage.asp"-->