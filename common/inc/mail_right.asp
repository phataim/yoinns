<div id="sidebar_mail" class="want_know">
				<div class="hd">
					<h3>��֪��������Ź���ʲô��</h3>
					<p>��������ÿ���¾�ϲ�͸�����</p>
				</div>
				<div class="bd">
					
					<div class="order_op">
					<div class="email_order">
						<form method="post" action="<%=VirtualPath%>/subscribe.asp">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
			<input id="rightEmail" name="email" class="f-email" type="text" style="color: rgb(153, 153, 153);" value="���������Email..." >
</td>
			<td>
			<input type="hidden" name="act" value="save"/>
			<input type="image" name="" src="<%=VirtualPath%>/common/themes/<%=SiteConfig("DefaultSiteStyle")%>/Css/img/subscribe.gif" />
			</td>
		  </tr>
		</table>
	</form>
					</div>
	
					<div class="choice_daily_order">
						<p><span class="red">*</span>�˷��������ʱȡ��</p>
					</div>
					</div>
						
					</div>
					
				</div>
<script language="JavaScript" type="text/javascript"> 
            var rightEmail = document.getElementById("rightEmail"); 
            addListener(rightEmail,"click",function(){ 
                rightEmail.value = ""; 
            }) 
            addListener(rightEmail,"blur",function(){ 
				if(rightEmail.value == ""){
                	rightEmail.value = "���������Email..."; 
				}
            })     
    </script> 