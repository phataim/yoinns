<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>邮件订阅</h2></div>
						
						<%
						If opFlag = "success" Then
						%>
						<div class="sect">
							<%IF sendMailFlag="Y" Then%>
								<div class="succ">请登录您的邮箱完成验证后才可收到我们的邮件！</div>
							<%Else%>
								<div class="succ">您的邮箱 <strong><%=email%></strong> 将会收到<strong><%=cityname%></strong>每天最新的团购信息。</div>
							<%End IF%>
						</div>

						<%
						Else
						%>
						
						<!--start-->
						<div class="sect">
							<div class="lead"><h4>把全球每天最新的精品团购信息发到您的邮箱。</h4></div>
							<div class="enter-address">
								<p>立即邮件订阅每日团购信息，不错过每一天的惊喜。</p>
								<div class="enter-address-c">
								<form class="validator" method="post" action="subscribe.asp" id="enter-address-form">
								<div class="mail">
									<label>邮件地址：</label>
									<input type="text" id="middleEmail" size="20" value="请输入你的Email..." class="f-input f-mail" name="email"  style="color: rgb(153, 153, 153);">
									<span class="tip">请放心，我们和您一样讨厌垃圾邮件</span>
								</div>
								<div class="city">
									<label>&nbsp;</label>
									<select class="f-city" name="city_id">
									<%=Dream3Team.getCategory("city",city_id)%>
									</select>
									<input type="hidden" name="act" value="save"/>
									<input type="submit" value="订阅" class="formbutton" id="enter-address-commit">
								</div>
								</form>
							</div>
							<div class="clear"></div>
						</div>
						<div class="intro">
							<p>每日精品团购包括：</p>
							<p>餐厅、酒吧、KTV、SPA、美发、健身、瑜伽、演出、影院等。</p>
						</div>
						</div>
						<!--end-->
						<%End If%>
		
						
					</div>
					<div class="login-bottom"></div>
			</div>
<script language="JavaScript" type="text/javascript"> 
	var middleEmail = document.getElementById("middleEmail"); 
	addListener(middleEmail,"click",function(){ 
		middleEmail.value = ""; 
	}) 
	addListener(middleEmail,"blur",function(){ 
		if(middleEmail.value == ""){
			middleEmail.value = "请输入你的Email..."; 
		}
	})     
</script> 