<div id="sidebar_mail" class="want_know">
				<div class="hd">
					<h3>想知道明天的团购是什么？</h3>
					<p>立即订阅每天新惊喜送给您！</p>
				</div>
				<div class="bd">
					
					<div class="order_op">
					<div class="email_order">
						<form method="post" action="<%=VirtualPath%>/subscribe.asp">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
			<input id="rightEmail" name="email" class="f-email" type="text" style="color: rgb(153, 153, 153);" value="请输入你的Email..." >
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
						<p><span class="red">*</span>此服务可以随时取消</p>
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
                	rightEmail.value = "请输入你的Email..."; 
				}
            })     
    </script> 