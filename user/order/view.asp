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
<title><%=Dream3CLS.SiteConfig("SiteName")%>-订单详情</title>

<div class="area">
	
    <!--#include file="../inc/top.asp"-->
    
    
	<!--#include file="../inc/menu.asp"-->
    
    <div class="layoutright mt9">
    	<div class="bor">
        	<div class="innr">
            	
                <div class="discbox"><p>订单详情<span class="right"><a href="<%=returnUrl%>">&raquo; 返回 </a></span></p></div>
                
                <div class="search_con clearfix">
                	
                    <div id="con">
                    	
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="house-adr1">
						  <tr>
                            <td colspan="4">下单人：<%=orderObj.userrealname%></td>
							<td colspan="4">手机：<%=orderObj.usermobile%></td>
                          </tr>
						  <tr>
                            <td colspan="4">email：<%=orderObj.useremail%></td>
							<td colspan="4">订单状态：<%=orderObj.orderStateDisplay%></td>
                          </tr>
                          <tr>
                            <td colspan="4">订单编号：<%=orderObj.orderNo%></td>
							<td colspan="4">入住日期：<%=orderObj.orderstartDate%></td>
                          </tr>
                          <tr>
                            <td colspan="4">所属酒店/旅店：<a href="<%=VirtualPath%>/show.asp?hid=<%=orderObj.hid%>" target="_blank"><%=orderObj.hotelname%></a></td>
							<td colspan="4">离店日期：<%=orderObj.orderendDate%></td>
							<%If orderObj.orderstate = "pay" Then%>
							支付时间：<%=orderObj.orderPayTime%>
							<%End If%>
							</td>
                          </tr>
                          <tr>
                          <td colspan="8">旅店地址：<%=orderObj.hoteladdress %></td>
                          </tr>
                          <tr>
                          <td colspan="8">交通路线：<%=orderObj.hotelline %></td></tr>
						  <%
						  If orderObj.orderstate = "failed" Then
						  	  s_failed_reason = ""
							  Set transRs = orderObj.GetOrderTrans(orderId)
							  Do While Not transRs.EOF
							  
							  	trans_user_type = transRs("user_type")
								trans_order_status = transRs("order_status")
								trans_action = transRs("action")
								If trans_action = "reedit" Then
									s_failed_reason = "由于房源被重新编辑，导致您的订单已失效！"
								elseif trans_action = "expire" Then
									s_failed_reason = "订单已过期！"
								End if
							  	
							  	exit do
							  Loop
						  %>
						  <tr>
                            <td colspan="8">失败原因：<%=s_failed_reason%></td>
                          </tr>
						  <%End If%>
						  
						  <%If orderObj.orderstate = "pay" Then%>
                          <tr>
                            <td colspan="8">支付方式：<%=orderObj.orderpaywaydisplay%></td>
                          </tr>
						  <%End If%>
                          <tr>
                            <th>房间名称</th>
							<th>租用类型</th>
                            <th>单价</th>
							<th>房间数</th>
                            <th>天数</th>
                            <th>总价</th>
							<th>定金</th>
                            <th>状态</th>
                          </tr>
                          <tr>
                            <td align="center"><a href="<%=VirtualPath%>/detail.asp?pid=<%=orderObj.productId%>" target="_blank"><%=orderObj.housetitle%></a></td>
                            <td align="center"><%=orderObj.ordercheckinTypeDisplay%></td>
							<td align="center">￥<%=orderObj.ordersingleprice%></td>
							<td align="center"><%=orderObj.orderRoomNum%></td>
                            <td align="center"><%=orderObj.ordercheckindays%></td>
                            <td align="center">￥<%=orderObj.orderTotalMoney%></td>
							<td align="center">￥<%=orderObj.orderReserve%></td>
                            <td align="center"><%=orderObj.orderstatedisplay%></td>
                          </tr>
                          <tr>
                            <td colspan="8"></td>
                          </tr>
                          
                                   <tr>
                                                <td colspan="8"><%If usertype = "lodger" Then%>
                                                      <a id="pinglun"  onclick="pinglun()">&raquo; 评论 </a> <a href="<%=VirtualPath%>/detail.asp?pid=<%=orderObj.productId%>#3" target="_blank"> &raquo; 查看评论 </a>
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
                                                            <input name="fabiao" id="fabiao" type="submit" value="发表评论" />
                                                            <input name="reset" type="reset" value="取消"  onclick="cancelbutton(reset)"/>
                                                      </form>
                                                      <%else%>
                                                      <a href="<%=VirtualPath%>/detail.asp?pid=<%=orderObj.productId%>#3" target="_blank"> &raquo; 查看评论 </a>
                                                      <%End If%></td>
                                          </tr>
                          
                          <tr>
                            <td colspan="8"><a href="<%=returnUrl%>">&raquo; 返回我的订单 </a></td>
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
	
　　if (textarea.style.display=="block")
　　{
　　　　textarea.style.display="none";
　　}
　　else
　　{
　　　　textarea.style.display="block";
        textarea.pinglunarea.focus();
     }
 

	}
	function submitbutton(text){
		
		 if (text.value.length>200){
			  alert("评论内容不得超过200字！");
			  
			  return false;
			  }
    
		if(text.value==""){alert("请输入具体回复内容！")
        return false;
        }
		else
		{
		
		 document.getElementById("myform").style.display="none"
         return ture;
		}
	    
　  }
	
	function cancelbutton(commentid){
	
	document.getElementById("myform").style.display="none"
　}
	function opencomment(){
	
   
　}
</script> 


<!--#include file="../../common/inc/footer_user.asp"-->
