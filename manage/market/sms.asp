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
        <span class="fl">短信群发</span>
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
                            <label>手机号码</label>
                            <textarea cols="45" rows="5" name="mobile" id="mobile" class="f-textarea"></textarea>
							多个手机号码请用英文逗号“,”分开
                        </div>
						<div class="field">
                            <label>短信内容</label>
							 <textarea cols="45" rows="5" name="smscontent" id="smscontent" class="f-textarea"></textarea> 
							 长度70个字以内，1个字母和1个汉字都认为是1个字，当前 <p id="wordcount">您已输入<font id="str" color="#FF0000">0</font>字  </p>字符
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
	  if($('#mobile').val() == ""){
	  	alert("请输入手机号码");
		return;
	  }
	  if($('#smscontent').val() == ""){
	  	alert("请输入短信内容");
		return;
	  }
	  $("#btnSend").attr('disabled','true'); 
	  $("#btnSend").attr('value','正在发送，请稍后......'); 
      $.get(
      '<%=VirtualPath%>/ajax/sendMarketSMS.asp',
      {
        mobile:$('#mobile').val(),
        smscontent:escape($('#smscontent').val())
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
                $("#wordcount")[0].firstChild.nodeValue = "您已输入0";  
                $str.html(length);  
            }else{  
                $("#wordcount")[0].firstChild.nodeValue = "您已输入";  
                $str.html(length);  
            }  
        }  
    }  
});  
</script>

	
<!--#include file="../../common/inc/footer_manage.asp"-->