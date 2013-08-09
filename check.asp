<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/inc/permission_user.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->

<%
'--------��ֹ����------------  
Response.Expires   =   -1   
Response.ExpiresAbsolute   =   Now()   -   1   
Response.cachecontrol   =   "no-cache"   
%>

<%
Dim Action
Dim order_Id 

Dim dayrentprice,weekrentprice,monthrentprice
Dim checkinRoomNum,startdate,enddate,checkintype
Dim checkindays, singlePrice ,totalmoney 
Dim onlinepayamount '����֧�����
Dim offlinepayamount '����֧�����

Action = Request.QueryString("act")
Select Case Action
	Case "saveorder"
		Call SaveOrder()
	Case Else
		Call Main()
End Select



Sub Main()
		'֧����ť����
		canBtnEnabled = true
		If Session("_UserID") = "" Then
			Response.Redirect("user/account/login.asp")
		End If
		order_id = Dream3CLS.ChkNumeric(Request("id"))
		
		Sql = "Select * From T_Order Where id="&order_id&" and user_id="&Session("_UserID")
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ�������Ϣ��",0,"0")
			Response.End()
		End If
		
		product_id = Rs("product_id")
		checkintype = Rs("checkintype")
		checkinRoomNum = Rs("roomnum")
		checkindays = Rs("checkindays")
		totalmoney = CDBL(Rs("totalmoney"))
		Rs.Close

		
		Sql = "Select * From T_Product Where id="&product_id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("�޷��ҵ���Ӧ��Ŀ��",0,"0")
			Response.End()
		End If
	 	
		dayrentprice = Rs("dayrentprice") 
		weekrentprice = Rs("weekrentprice") 
		monthrentprice = Rs("monthrentprice") 
		
		If checkintype = "perDay" Then
			singlePrice = dayrentprice
		Elseif checkintype = "perWeek" Then
			singlePrice = weekrentprice
		Elseif checkintype = "perMonth" Then
			singlePrice = monthrentprice
		End If
		
		
		onlinepayamount = Dream3Product.GetReserve(totalmoney)
		offlinepayamount = totalmoney - onlinepayamount
		
		
	End Sub
	
%>
	
	

<!--#include file="common/inc/header_user.asp"-->
<title><%=Dream3CLS.SiteConfig("SiteName")%>-ȷ�϶���</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="content_wrapper">
	
    <div class="yuding_box">
        
        <div class="part1_bg">
            <ul>
                <li class="num_01"><h2>�ͷ�Ԥ��</h2></li>
                <li class="num_07"><h2>֧������</h2></li>
                <li class="num_03"><h3>���</h3></li>
            </ul>
        </div>
        
        <div class="line_one"></div>
        
        <div class="part2_cc">
        	<div class="part2_cct"></div>
            <div class="part2_ccm">
                 <table cellspacing="0" cellpadding="0" border="0" width="100%" class="house-adr">
                <tbody>
                    <tr>
                        <th>���</th>
                        <th>����</th>
                        <th>����</th>
                        <th>����</th>
                        <th>�ܼ�</th>
                        <th>����Ӧ������<%=Dream3CLS.SiteConfig("ReserveRate")%>%��</th>
                        <th>����֧������</th>                        
                    </tr>
                    <tr class="tr">
                        <td>�ܼ�</td>
                        <td>��<%=singlePrice%></td>
                        <td><%=checkinRoomNum%></td>
                        <td><%=checkindays%></td>
                        <td  class="jq">��<%=totalmoney%></td>
                        <td  class="jq">��<%=onlinepayamount%></td>
                        <td  class="jq">��<%=offlinepayamount%></td>                        
                    </tr>
                </tbody>
                </table>
                <div class="dingjin">����:��<%=totalmoney%> x <%=Dream3CLS.SiteConfig("ReserveRate")%>% = ��<%=onlinepayamount%></div>
				<form method="post" name="orderForm" action="pay.asp">
				<input type="hidden" name="order_id" value="<%=order_id%>"/>
                <ul class="pay">
                    <h3>��ѡ��֧����ʽ</h3>
					<%If Dream3CLS.SiteConfig("AlipayID")<>"" Then%>
                    <li>
                    <input id="check-yeepay" type="radio" name="paytype" value="alipay" checked />
                    <img src="images/onlinepay/alipay.gif">
                    <label class="bill" for="check-bill">֧������ȫ�����ȵĶ���������֧��ƽ̨</label>
                    </li>
					<%End If%>
					<%If Dream3CLS.SiteConfig("TenpayID")<>"" Then%>
                    <li>
                    <input id="check-tenpay" type="radio" name="paytype" value="tenpay"  />
                    <img src="images/onlinepay/tenpay.jpg">
                    <label class="bill" for="check-bill">�Ƹ�ͨ���ף��Ƽ�QQ�û�ʹ��</label>
                    </li>
					<%End If%>
					
					
<!--	�������ݱ�D�Ը�ע�͵�				
					<%If Dream3CLS.SiteConfig("YeepayID")<>"" Then%>
                    <li>
                    <input id="check-yeepay" type="radio" name="paytype" value="yeepay" />
                    <img src="images/onlinepay/yeepay.gif"/>
                    <label for="check-bill" class="bill">�ױ����ף������������ָ��ӱ��</label>
                    </li>
					<%End If%>
					<%If Dream3CLS.SiteConfig("ChinaBankID")<>"" Then%>
                    <li>
					<input id="check-yeepay" type="radio" name="paytype" value="chinabank" />
					<img src="images/onlinepay/chinabank.gif"/>
					<label for="check-bill" class="bill">�������ף���ʱ��ؿ�ݰ�ȫ����</label>
					</li>
					<%End If%>
					<%
					If Dream3CLS.Dream3_OtherPay <>"" Then
					%>
					<li>
					<input id="check-yeepay" type="radio" name="paytype" value="other"/>
					<label for="check-bill" class="bill">����֧����ʽ</label>
					</li>
					<%
					End If
					%>		
					-->
                </ul>
                <div></div>
                <div>
                   
					<input type="submit" id="searchBt" value="ȷ������,����!" class="input_next">
					
                </div>
                 </form>
            </div>
            <div class="part2_ccb"></div>            
        </div>
        
    </div>
    
</div>

<!--#include file="common/inc/footer_user.asp"-->