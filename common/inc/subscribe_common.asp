<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>�ʼ�����</h2></div>
						
						<%
						If opFlag = "success" Then
						%>
						<div class="sect">
							<%IF sendMailFlag="Y" Then%>
								<div class="succ">���¼�������������֤��ſ��յ����ǵ��ʼ���</div>
							<%Else%>
								<div class="succ">�������� <strong><%=email%></strong> �����յ�<strong><%=cityname%></strong>ÿ�����µ��Ź���Ϣ��</div>
							<%End IF%>
						</div>

						<%
						Else
						%>
						
						<!--start-->
						<div class="sect">
							<div class="lead"><h4>��ȫ��ÿ�����µľ�Ʒ�Ź���Ϣ�����������䡣</h4></div>
							<div class="enter-address">
								<p>�����ʼ�����ÿ���Ź���Ϣ�������ÿһ��ľ�ϲ��</p>
								<div class="enter-address-c">
								<form class="validator" method="post" action="subscribe.asp" id="enter-address-form">
								<div class="mail">
									<label>�ʼ���ַ��</label>
									<input type="text" id="middleEmail" size="20" value="���������Email..." class="f-input f-mail" name="email"  style="color: rgb(153, 153, 153);">
									<span class="tip">����ģ����Ǻ���һ�����������ʼ�</span>
								</div>
								<div class="city">
									<label>&nbsp;</label>
									<select class="f-city" name="city_id">
									<%=Dream3Team.getCategory("city",city_id)%>
									</select>
									<input type="hidden" name="act" value="save"/>
									<input type="submit" value="����" class="formbutton" id="enter-address-commit">
								</div>
								</form>
							</div>
							<div class="clear"></div>
						</div>
						<div class="intro">
							<p>ÿ�վ�Ʒ�Ź�������</p>
							<p>�������ưɡ�KTV��SPA�������������٤���ݳ���ӰԺ�ȡ�</p>
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
			middleEmail.value = "���������Email..."; 
		}
	})     
</script> 