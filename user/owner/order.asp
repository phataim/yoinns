<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/inc/permission_user.asp"-->
<!--#include file="../../common/api/cls_sms.asp"-->
<!--#include file="../../common/api/cls_xml.asp"-->
<!--#include file="../../common/api/cls_tpl.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_static.asp"-->

<%
Dim Action
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim Sql, sqlCount
Dim rs, searchStr
Dim stateStr
Dim classifier,classifierStyle

Dim productIdArr()
Set productMap = new AspMap


	Action = Request.QueryString("act")
	classifier = Dream3CLS.RParam("c")
	
	Select Case Action
		Case "ownerconfirm"
			Call OwnerConfirm()
		Case "ownercancel"
			Call OwnerCancel()
		Case Else
			Call Main()
	End Select
	

	Sub OwnerConfirm()
		orderid = Dream3CLS.RNum("orderid")
		sql = "select * from T_Order where id = " & orderid & " and owner_id=" & Session("_UserID")
		
		Set Rs = Dream3CLS.Exec(Sql)
		
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到该订单！",0,"0")
			response.End()
		End If
		
		If (Rs("state") <> "unconfirm")  Then
			Call Dream3CLS.MsgBox2("无法取消该订单！",0,"0")
			response.End()
		End If
		
		f_order_no = Rs("order_no")
		f_mobile = Rs("mobile")
		
		Sql = "Update  T_Order set state = 'unpay' Where id = " & orderid
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		gMsgArr = "确认订单成功！"
		
		sendsmsresult = ""
		
		Dream3Product.SendOwnerConfirmSMS sendsmsresult, f_mobile, f_order_no
		
		Call Main()
	End Sub
	
	
	Sub OwnerCancel()
		orderid = Dream3CLS.RNum("orderid")
		sql = "select * from T_Order where id = " & orderid & " and owner_id=" & Session("_UserID")
		
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到该订单！",0,"0")
			response.End()
		End If
		
		If (Rs("state") <> "unconfirm" and  Rs("state") <> "unpay")  Then
			Call Dream3CLS.MsgBox2("无法取消该订单！",0,"0")
			response.End()
		End If
		
		f_order_no = Rs("order_no")
		f_mobile = Rs("mobile")
		
		Sql = "Update  T_Order set state = 'ownercancel' Where id = " & orderid
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		gMsgArr = "取消成功"
		
		sendsmsresult = ""
		
		Dream3Product.SendOwnerCancelSMS sendsmsresult, f_mobile, f_order_no
		
		Call Main()
	End Sub
	
	Sub Main()	
		'classifier = Dream3CLS.RParam("c")
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl &"?c="&classifier
		
		intPageNow = request.QueryString("page")

		intPageSize = 5
		If IsSQLDataBase = 1 Then
			'searchStr = "and Datediff(s,start_time,GetDate())>=0"
		Else
			'searchStr = "and Datediff('s',start_time,Now())>=0"
		End If
		
		classifierStyle = "all"

		Select Case classifier
			Case "unconfirm"
				searchStr = searchStr & " and state='unconfirm'"
			Case "unpay"
				searchStr = searchStr & " and state='unpay'"
			Case "pay"
				searchStr = searchStr & " and state='pay'"
			Case "lodgercancel"
				searchStr = searchStr & " and state='lodgercancel'"
			Case "ownercancel"
				searchStr = searchStr & " and state='ownercancel'"
			Case "refund"
				searchStr = searchStr & " and state='refund'"
			Case "failed"
				searchStr = searchStr & " and state='failed'"
			
		End Select
		
		searchStr = searchStr & " and owner_id=" & Session("_UserID")
		
		Sql = "Select id,order_no,product_id,city_code,checkindays,state,roomnum,checkintype,reserve,singleprice,pay_time,create_time,totalmoney  from T_Order Where 1=1 "&searchStr
		Sql = Sql &" Order By create_time Desc"
		
		
		sqlCount = "SELECT Count(id) FROM T_Order where 1=1 "&searchStr
	
			
		Set clsRecordInfo = New Cls_PageView
			clsRecordInfo.intRecordCount = 2816
			clsRecordInfo.strSqlCount = sqlCount
			clsRecordInfo.strSql = sql
			clsRecordInfo.intPageSize = intPageSize
			clsRecordInfo.intPageNow = intPageNow
			clsRecordInfo.strPageUrl = strLocalUrl
			clsRecordInfo.strPageVar = "page"
		clsRecordInfo.objConn = Conn		
		arrU = clsRecordInfo.arrRecordInfo
		strPageInfo = clsRecordInfo.strPageInfo
		Set clsRecordInfo = nothing
		
		
		'循环数组，搜寻id并存入数组
		If IsArray(arrU) Then
			For i = 0 to UBound(arrU, 2)
				If (Not IsNull(arrU(2,i)) and arrU(2,i) <> "") Then
					ReDim Preserve productIdArr(i)
					productIdArr(i) = arrU(2,i)
				End If
			Next
			
			Call Dream3Product.getproductItemMap(productIdArr,productMap)
			
		End If
		
	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=Dream3CLS.SiteConfig("SiteName")%>-我的订单</title>

<form id="productForm" name="productForm" method="post" action="?act=save"  class="validator">
<div class="area">
	
    
    <!--#include file="../inc/top.asp"-->
    
    
	<!--#include file="../inc/menu.asp"-->
	
    
    
    <div class="layoutright mt9">
    	<div class="bor">
        	<div class="innr">
            	
                <div class="discbox"><p>我的订单</p></div>
            	
               
                
                <div class="search_con clearfix">
                
                    <div id="con">
                        <!--#include file="ordertypemenu.asp"-->
                        <div id="tagContent" class="blue_link">
							<%If IsArray(arrU) Then%>
                            <div class="tagContent selectTag" id=tagContent0>
                                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="house-adr">
                                    <tr>
                                        <th>订单号</th>
                                        <th>所属酒店</th>
                                        <th class="w2">房间类型</th>
                                        <th>租用类型</th>
                                        <th>入住天数</th>
                                        <th>总金额</th>
                                        <th>订金</th>
                                        <th>状态</th>
                                        <th>操作</th>
                                    </tr>
									<%
	
										For i = 0 to UBound(arrU, 2)
										
											s_id = arrU(0,i)
											s_order_no = arrU(1,i)
											s_product_id = arrU(2,i)
											s_city_code = arrU(3,i)
											s_checkindays = arrU(4,i)
											s_state = arrU(5,i)
											s_roomnum = arrU(6,i)
											s_checkintype = arrU(7,i)
											s_reserve = arrU(8,i)
											single_price= arrU(9,i)
											s_pay_time = arrU(10,i)
											s_create_time = arrU(11,i)
											s_total_price = arrU(12,i)
											
											s_state_str = ""
											Select Case s_state
												Case "unconfirm"
													s_state_str = "待房东确认"
												Case "unpay"
													s_state_str = "待付款"
												Case "pay"
													s_state_str = "已完成"
												Case "lodgercancel"
													s_state_str = "房客取消"
												Case "ownercancel"
													s_state_str = "房东取消"
												Case "refund"
													s_state_str = "已退款"
											    Case "admincancel"
											        s_state_str = "管理员取消"
												Case "failed"
													s_state_str = "失败"
											End Select
											
											Select Case s_checkintype
												Case "perMonth"	
													s_checkintype_str = "月租"
											
												Case Else
													s_checkintype_str = "日租"
											End Select
											
										
											
											If isNull(s_product_id) Then
												't(">>" & i)
											End If
											
											s_product_id = cstr(s_product_id)
											
											s_housetitle = productMap.getV(s_product_id)(0)
											sql = "select * from t_product where id="&s_product_id
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Dream3CLS.showMsg "您要查询的信息不存在！","S","error.asp"
			Response.End()
		End If
		
		hid=Rs("hid")
		sql2="select * from T_hotel where h_id="&hid
		Set Rs2 = Dream3CLS.Exec(Sql2)
		If Rs2.EOF Then
			Dream3CLS.showMsg "您要查询的信息不存在！","S","error.asp"
			Response.End()
		End If
		hotelname=Rs2("h_hotelname")
		
		Set rs2=nothing
		
		Set rs = nothing

											
									%>	
                                    <tr class="tr">
                                        <td height="30"><%=s_order_no%></td>
                                        <td><a href="<%=VirtualPath%>/show.asp?hid=<%=hid%>" target=_blank><%=hotelname%></a></td>
                                        <td><a href="<%=VirtualPath%>/detail.asp?pid=<%=s_product_id%>" target=_blank><%=s_housetitle%></a></td>
                                        <td><%=s_checkintype_str%></td>
                                        <td><%=s_checkindays%>天</td>
                                        <td><%=s_total_price%>元</td>
                                        <td><%=s_reserve%>元</td>
                                        <td><%=s_state_str%></td>
                                        <td>
										<a href="<%=VirtualPath%>/user/order/view.asp?u=owner&c=<%=classifier%>&id=<%=s_id%>">详情</a>
										<%
										If s_state = "unconfirm"  Then
										%>
										<a href="?act=ownerconfirm&orderid=<%=s_id%>" onclick="return window.confirm('您确定要确认该订单?')">确认</a>
										<a href="?act=ownercancel&orderid=<%=s_id%>" onclick="return window.confirm('您确定要取消该订单?')">取消</a>
										<%End If%>
										<%
										If  s_state = "unpay" Then
										%>
										
										<a href="?act=ownercancel&orderid=<%=s_id%>" onclick="return window.confirm('您确定要取消该订单?')">取消</a>
										<%End If%>
										
										</td>
                                    </tr>
                                    <%
										Next						 
									%>
									<%If IsArray(arrU) Then%>
									<tr class="tr">
									<td colspan="15">
									<%= strPageInfo%>
									</td>
									</tr>
									<%End If%>
                                </table>
                            </div>
							<%Else%>
                            <div class="tagContent" id=tagContent1>
                                <p style="height:200px; padding:10px 50px; text-align:center; line-height:200px; font-size:14px;"> 
                                	您目前没有该类型的订单
                                </p>
                            </div>
							<%End If%>
                            
                        </div>
                    </div>
                    
              
                    
                </div>                
                
                
            </div>
        </div>
    </div>
    
    
    
</div>
</form>
<!--#include file="../../common/inc/footer_user.asp"-->
