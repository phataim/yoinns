<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/inc/permission_user.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_static.asp"-->
<!--#include file="../../common/api/obj_order.asp"-->
<%
Dim Action
Dim orderId
Dim orderObj
Dim classifier,usertype,returnUrl


	Action = Request.QueryString("act")
	classifier = Dream3CLS.RParam("c")
	usertype = Dream3CLS.RParam("u")
	
	Select Case Action
		Case Else
			Call Main()
	End Select
	

	
	
	Sub Main()	
		orderId = Dream3CLS.RParam("id")
		
		If usertype = "lodger" Then
			returnUrl = VirtualPath & "/user/lodger/order.asp?c="&classifier
		Else
			returnUrl = VirtualPath & "/user/owner/order.asp?c="&classifier
		End If
	
			
		Set orderObj = New Obj_Order
			orderObj.inOrderId = orderId

		orderObj.objConn = Conn		
		orderResult = orderObj.orderResult
		'Set orderObj = nothing
		

	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=Dream3CLS.SiteConfig("SiteName")%>-��������</title>

<div class="area">
	
    <!--#include file="../inc/top.asp"-->
    
    
	<!--#include file="../inc/menu.asp"-->
    
    <div class="layoutright mt9">
    	<div class="bor">
        	<div class="innr">
            	
                <div class="discbox"><p>��������<span class="right"><a href="<%=returnUrl%>">&raquo; ���� </a></span></p></div>
                
                <div class="search_con clearfix">
                	
                    <div id="con">
                    	
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="house-adr1">
						  <tr>
                            <td colspan="4">�µ��ˣ�<%=orderObj.userrealname%></td>
							<td colspan="4">�ֻ���<%=orderObj.usermobile%></td>
                          </tr>
						  <tr>
                            <td colspan="4">email��<%=orderObj.useremail%></td>
							<td colspan="4">����״̬��<%=orderObj.orderStateDisplay%></td>
                          </tr>
                          <tr>
                            <td colspan="4">������ţ�<%=orderObj.orderNo%></td>
							<td colspan="4">��ס���ڣ�<%=orderObj.orderstartDate%></td>
                          </tr>
                          <tr>
                            <td colspan="4">�����Ƶ�/�õ꣺<a href="<%=VirtualPath%>/show.asp?hid=<%=orderObj.hid%>" target="_blank"><%=orderObj.hotelname%></a></td>
							<td colspan="4">������ڣ�<%=orderObj.orderendDate%></td>
							<%If orderObj.orderstate = "pay" Then%>
							֧��ʱ�䣺<%=orderObj.orderPayTime%>
							<%End If%>
							</td>
                          </tr>
                          <tr>
                          <td colspan="8">�õ��ַ��<%=orderObj.hoteladdress %></td>
                          </tr>
                          <tr>
                          <td colspan="8">��ͨ·�ߣ�<%=orderObj.hotelline %></td></tr>
						  <%
						  If orderObj.orderstate = "failed" Then
						  	  s_failed_reason = ""
							  Set transRs = orderObj.GetOrderTrans(orderId)
							  Do While Not transRs.EOF
							  
							  	trans_user_type = transRs("user_type")
								trans_order_status = transRs("order_status")
								trans_action = transRs("action")
								If trans_action = "reedit" Then
									s_failed_reason = "���ڷ�Դ�����±༭���������Ķ�����ʧЧ��"
								elseif trans_action = "expire" Then
									s_failed_reason = "�����ѹ��ڣ�"
								End if
							  	
							  	exit do
							  Loop
						  %>
						  <tr>
                            <td colspan="8">ʧ��ԭ��<%=s_failed_reason%></td>
                          </tr>
						  <%End If%>
						  
						  <%If orderObj.orderstate = "pay" Then%>
                          <tr>
                            <td colspan="8">֧����ʽ��<%=orderObj.orderpaywaydisplay%></td>
                          </tr>
						  <%End If%>
                          <tr>
                            <th>��������</th>
							<th>��������</th>
                            <th>����</th>
							<th>������</th>
                            <th>����</th>
                            <th>�ܼ�</th>
							<th>����</th>
                            <th>״̬</th>
                          </tr>
                          <tr>
                            <td align="center"><a href="<%=VirtualPath%>/detail.asp?pid=<%=orderObj.productId%>" target="_blank"><%=orderObj.housetitle%></a></td>
                            <td align="center"><%=orderObj.ordercheckinTypeDisplay%></td>
							<td align="center">��<%=orderObj.ordersingleprice%></td>
							<td align="center"><%=orderObj.orderRoomNum%></td>
                            <td align="center"><%=orderObj.ordercheckindays%></td>
                            <td align="center">��<%=orderObj.orderTotalMoney%></td>
							<td align="center">��<%=orderObj.orderReserve%></td>
                            <td align="center"><%=orderObj.orderstatedisplay%></td>
                          </tr>
                          <tr>
                            <td colspan="8"></td>
                          </tr>
                          
                                   <tr>
                                                <td colspan="8"><%If usertype = "lodger" Then%>
                                                      <a id="pinglun"  onclick="pinglun()">&raquo; ���� </a> <a href="<%=VirtualPath%>/detail.asp?pid=<%=orderObj.productId%>#3" target="_blank"> &raquo; �鿴���� </a>
                                                      <div class="myform" id="myform" style="display:none">
                                                      <form action="../../commentssubmit.asp" method="post" name="addpinglun"  onsubmit="return submitbutton(pinglunarea)" >
                                                            <textarea name="pinglunarea" id="pinglunarea" cols="112" rows="5"></textarea>
                                                            <input name="href" type="hidden" value="<%= VirtualPath&"/user/order/view.asp?u="&usertype&"&id="&orderId&"&c="&classifier%>" />
                                                            <input name="hid" type="hidden" value=<%=orderObj.hid%> />
                                                            <input name="fangdong" type="hidden" value=<%=fangdong%> />
                                                            <input name="roomid" type="hidden" value=<%=orderObj.productId%> />
                                                            <input name="hotelname" type="hidden" value=<%=orderObj.hotelname%> />
                                                            <input name="username" type="hidden" value=<%=Session("_UserName")%> />
                                                            <input name="houseTitle" type="hidden" value=<%=orderObj.houseTitle%> />
                                                            <input name="fabiao" id="fabiao" type="submit" value="��������" />
                                                            <input name="reset" type="reset" value="ȡ��"  onclick="cancelbutton(reset)"/>
                                                      </form>
                                                      <%else%>
                                                      <a href="<%=VirtualPath%>/detail.asp?pid=<%=orderObj.productId%>#3" target="_blank"> &raquo; �鿴���� </a>
                                                      <%End If%></td>
                                          </tr>
                          
                          <tr>
                            <td colspan="8"><a href="<%=returnUrl%>">&raquo; �����ҵĶ��� </a></td>
                          </tr>
                        </table>
                        
                    </div>
                    
              </div>                
                
                
            </div>
        </div>
    </div>
    
    
    
</div>
<script language="javascript" type="text/javascript">
function pinglun(){
		
	
	
	var textarea =document.getElementById("myform")
		
		//alert(textarea);
	
����if (textarea.style.display=="block")
����{
��������textarea.style.display="none";
����}
����else
����{
��������textarea.style.display="block";
        textarea.pinglunarea.focus();
     }
 

	}
	function submitbutton(text){
		
		 if (text.value.length>200){
			  alert("�������ݲ��ó���200�֣�");
			  
			  return false;
			  }
    
		if(text.value==""){alert("���������ظ����ݣ�")
        return false;
        }
		else
		{
		
		 document.getElementById("myform").style.display="none"
         return ture;
		}
	    
��  }
	
	function cancelbutton(commentid){
	
	document.getElementById("myform").style.display="none"
��}
	function opencomment(){
	
   
��}
</script> 


<!--#include file="../../common/inc/footer_user.asp"-->
