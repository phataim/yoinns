<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_user.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../onlinepay/md5.inc"-->
<!--#include file="../../onlinepay/alipay/alipay_md5.asp"-->
<!--#include file="../../onlinepay/chinabank/md5.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../../common/api/cls_sms.asp"-->
<!--#include file="../../common/api/cls_xml.asp"-->
<%
Dim Action
Dim Sql,Rs
Dim money
	
	Action = Request.QueryString("act")
	Select Case Action
		Case Else
			Call Main()
	End Select


	
	Sub Main()		
		money = 1
		
			
	End Sub
	
%>
<!--#include file="../../common/inc/header_user.asp"-->
<title><%=SiteConfig("SiteName")%>-�ҵ��˻�</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="../../common/js/tools.js"></script>
<div id="box">	
	<div class="cf">		
		<div id="recent-deals">
			<div class="login-box" id="content">
					<div class="login-top"></div>
					<div class="login-content">
						<div class="head"><h2>��ֵ</h2></div>
						
						<div class="sect">
							<div class="charge">
								<form class="validator" method="post" action="pay.asp" id="account-charge-form">
									<p>�������ֵ��</p>
									<p class="number">
										<input type="text" value="<%=money%>" name="money" class="f-text " maxlength="6" onkeypress="NumericKeyPress(6,0)" onkeyup="NumericKeyUp(6,0)"
 onblur="NumericKeyUp(6,0)">
										<span class="validTip"></span> Ԫ ����֧��С������� 1 Ԫ��
									</p>
									<p style="visibility: hidden;" class="tip" id="account-charge-tip"></p>
									
									<div class="choose">
										<p class="choose-pay-type">��ѡ��֧����ʽ��</p>
										<ul class="typelist">
										<%If SiteConfig("AlipayID")<>"" Then%>
										<li>
										<input id="check-yeepay" type="radio" name="paytype" value="alipay" checked />
										<img src="<%=VirtualPath%>/images/onlinepay/alipay.gif"/>
֧�������ף��Ƽ��Ա��û�ʹ��
										</li>	
										<%End If%>																				
										</ul>
										<ul class="typelist">
										<%If SiteConfig("YeepayID")<>"" Then%>
										<li>
										<input id="check-yeepay" type="radio" name="paytype" value="yeepay" />
										<img src="<%=VirtualPath%>/images/onlinepay/yeepay.gif"/>
										�ױ����ף������������ָ��ӱ��
										</li>	
										<%End If%>																			
										</ul>
										<ul class="typelist">
										<%If SiteConfig("ChinaBankID")<>"" Then%>
										<li>
										<input id="check-yeepay" type="radio" name="paytype" value="chinabank" />
										<img src="<%=VirtualPath%>/images/onlinepay/chinabank.gif"/>
										�������ף���ʱ��ؿ�ݰ�ȫ����
										</li>	
										<%End If%>
										</ul>
									</div>
									<br />
									
									<div class="clear"></div>
									<p class="commit">
										<input type="submit" class="formbutton" value="ȷ����ȥ����">
									</p>
								</form>
							</div>
						</div>
						
					</div>
					<div class="login-bottom"></div>
			</div>
			<div id="sidebar">
				<!--#include file="../../common/inc/mail_right.asp"-->
			</div>
		</div>
	</div>	
</div>
<!--#include file="../../common/inc/footer_user.asp"-->
