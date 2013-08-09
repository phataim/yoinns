<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<!--#include file="../../onlinepay/onlinepaycode.asp"-->

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
Dim classifier

Dim user_id,product_id

Dim productIdArr()
Dim userIdArr()
Set productMap = new AspMap
Set userMap = new AspMap


	Action = Request.QueryString("act")
	classifier = Dream3CLS.RParam("classifier")
	
	Select Case Action
		Case "cash"
		   	Call SetOrderCash()
		Case "admincancel"
		    Call AdminCancel()
		Case Else
			Call Main()
	End Select

	'为订单付款
	'暂时定线下支付的金额为origin - credit
	Sub SetOrderCash()
		order_no = Dream3CLS.RSQL("orderno")
		Sql = "Select * From T_Order Where order_no='"&order_no&"'"
		

		Set Rs = Server.CreateObject("Adodb.recordset")
		Rs.open Sql,conn,1,2
		s_checkintype = Rs("checkintype")
		s_singleprice = CDBL(Rs("singleprice"))
		s_reserve = CDBL(Rs("reserve"))
		s_user_id = Rs("user_id")
		s_product_id = Rs("product_id")
		s_order_no = Rs("order_no")
		s_state = Rs("state")
		
		If s_state <> "unpay" Then
			'gMsgArr = "请查看订单状态是否已改变，目前无法进行现金支付！"
			'gMsgFlag = "E"
			'Call Main()
			'Exit Sub
		End If

		'Rs("state") = "pay"
		'Rs("pay_time") = now()
		
		'Rs.Update()
		'Rs.Close
		'Set Rs =Nothing
		
		'设置订单状态
		SetOrderState s_order_no,"cash","",s_reserve
	
		
		gMsgFlag = "S"
		gMsgArr = "现金支付成功"
		Call Main()
	End Sub
	
	
	
	'''''''''''''''''''''''霸爷新增内容'''''''''''''''''''''''''''''''''''''''''''''
	Sub AdminCancel()
		orderid = Dream3CLS.RNum("orderid")
		sql = "select * from T_Order where id = " & orderid 
		Set Rs = Dream3CLS.Exec(Sql)
		If Rs.EOF Then
			Call Dream3CLS.MsgBox2("无法找到该订单！",0,"0")
			response.End()
		End If
		
		If (Rs("state") <> "unconfirm" and  Rs("state") <> "unpay")  Then
			Call Dream3CLS.MsgBox2("无法取消该订单！",0,"0")
			response.End()
		End If
		
		Sql = "Update  T_Order set state = 'admincancel' Where id = " & orderid
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		gMsgArr = "取消成功"
		Call Main()
	End Sub
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	
	
	
	Sub Main()	
	
		user_id = Dream3CLS.RParam("user_id")
		product_id= Dream3CLS.RParam("product_id")
		
		If not IsNumeric(user_id) Then user_id=""
		If not IsNumeric(product_id) Then product_id=""
		 
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl &"?classifier="&classifier&"&user_id="&user_id&"&product_id="&product_id
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
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
			Case "failed"
				searchStr = searchStr & " and state='failed'"
			Case "admincancel"
				searchStr = searchStr & " and state='admincancel'"
			
		End Select
		
		If Dream3CLS.ChkNumeric(user_id) <> 0 Then
			searchStr = searchStr & " and user_id="&user_id
		End If
		
		If Dream3CLS.ChkNumeric(product_id) <> 0 Then
			searchStr = searchStr & " and product_id="&product_id
		End If

		
		Sql = "Select id,order_no,product_id,city_code,checkindays,state,roomnum,checkintype,reserve,singleprice,pay_time,create_time,user_id  from T_Order Where 1=1 "&searchStr
		Sql = Sql &" Order By create_time Desc"
		
		sqlCount = "SELECT Count(id) FROM T_Order where 1=1"&searchStr

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
				ReDim Preserve productIdArr(i)
				ReDim Preserve userIdArr(i)
				productIdArr(i) = arrU(2,i)
				userIdArr(i) = arrU(12,i)
			Next
			
			Call Dream3Product.getproductItemMap(productIdArr,productMap)
			Call Dream3Product.getUserMap(userIdArr,userMap)
			
		End If

	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<script type="text/javascript" src="../../common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="../../common/js/jquery/thickbox-compressed.js"></script>
<style type="text/css" media="all">
@import "../../common/static/style/thickbox.css";
</style>

<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl">订单查询</span>
        <span class="fr">
        	
        </span>
    </div>
    <div class="say">
        <form method="post" action="index.asp?classifier=<%=classifier%>">
					用户编号：<input type="text" value="<%=user_id%>" class="h-input" name="user_id">&nbsp;
					项目编号：<input type="text" value="<%=product_id%>" class="h-input number" name="product_id">&nbsp;
					<input type="submit" style="padding: 1px 6px;" class="formbutton" value="筛选">
					</form>
    </div>
</div>

<div id="box">

					
				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" class="coupons-table" id="orders-list">
					<tbody>
					<tr>
					<th width="40">ID</th>
					
					<!--------做个标记防止忘记---------------->
					<th width="160">旅馆</th>
					<th width="120">房型</th>
					<th width="140">用户</th>
					<th>租用类型</th>
					<th>入住天数</th>
					<th>总金额</th>
					<th>订金</th>
					<th>状态</th>
					<th>操作</th>
					</tr>
					
					
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
							s_id = arrU(0,i)
							s_order_no = arrU(1,i)
							s_product_id = arrU(2,i)
							s_city_code = arrU(3,i)
							s_checkindays = arrU(4,i)
							s_state = arrU(5,i)
							s_roomnum = arrU(6,i)
							s_checkintype = arrU(7,i)
							s_royalties = arrU(8,i)
							single_price= cdbl(arrU(9,i))
							s_pay_time = arrU(10,i)
							s_create_time = arrU(11,i)
							s_user_id  = arrU(12,i)
							
							
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
								Case "failed"
									s_state_str = "失败"
								Case "admincancel"
								    s_state_str = "管理员取消"
							End Select
							
							Select Case s_checkintype
								Case "perDay"	
									s_checkintype_str = "日租"
								Case "perWeek"	
									s_checkintype_str = "周租"
								Case "perMonth"	
									s_checkintype_str = "月租"
							End Select
							
							s_total_price = single_price * s_roomnum * s_checkindays
							
								'xiaoyaohang 这里原来的getMap有问题。获取不到数据，暂时改为重新查询数据库，以后若有性能瓶颈再修改
							Dim houseTitle
							Sql = "Select  *  from  T_Product Where  id ="&s_product_id
							Set titleRs = Dream3CLS.Exec(Sql)
							If Not titleRs.EOF Then
							titleRs.MoveFirst
							houseTitle = titleRs("houseTitle")
							
							'''''以下是霸爷新增内容''''''''''''
							hid=titleRs("hid")
							    sql_hotel="select * from T_hotel where h_id="&hid
							    set hotelRS=Dream3CLS.Exec(sql_hotel)
							    if Not hotelRs.EOF then 
							    	hotelRs.MoveFirst
							    	hotelname=hotelRs("h_hotelname")
							    	h_uid=hotelRs("h_uid")
							    	   user_sql="select * from T_User where id="&h_uid
							         set userRs=Dream3CLS.Exec(user_sql)
							         if Not userRs.EOF then
							         	 userRs.MoveFirst
							         	 mobile=userRs("mobile")
							         end if
							    end if
							    
							End If
							
							s_housetitle = houseTitle
					%>		
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td>
						<%=s_id%>
						</td>
						
						<!--下行为霸爷新增内容-->
						<td><a href="http://www.yoinns.com/show.asp?hid=<%=hid%>" target="_blank"><%=hotelname%></a><br><%=mobile%></td>
						<td><%=s_housetitle%>&nbsp;(<a target="_blank" href="../../detail.asp?pid=<%=s_product_id%>" class="deal-title"><%=s_product_id%></a>)</td>
						<td>
						<a class="ajaxlink" href="../user/userDetail.asp?act=showEdit&pid=<%=s_user_id%>">
						
						<%=Dream3User.GetUserFromMap(userMap,s_user_id)%>
						</a>
						</td>
						<td><%=s_checkintype_str%></td>
						<td><%=s_checkindays%>天</td>   
						<td><%=s_royalties%>元</td>   <!--原本的变量是<%=s_total_price%>,暂时没想到办法解决,只好替换成下面的变量-----BY农民工-->
						<td><%=s_royalties%>元</td>
						<td><%=s_state_str%></td>
						
						
						<td nowrap="" class="op">
						<%If s_state = "unpay" then%>
						<a class="ajaxlink" onclick="return window.confirm('确认本订单为现金付款?')" href="index.asp?act=cash&classifier=<%=classifier%>&orderno=<%=s_order_no%>">现金</a>|
						<%End If%>
						<a class="ajaxlink" href="orderDetail.asp?id=<%=s_id%>">详情</a>
						
						
						
						<!--霸爷新增功能-->
						
						<%
										If  s_state = "unconfirm" Then
						%>
										
						<a href="?act=admincancel&orderid=<%=s_id%>" onclick="return window.confirm('您确定要取消该订单?')">取消</a>
			
						<%End If%>
						
						
						
						
						
						</td>
						
						
					</tr>
					  <%
						Next
					  End If
					  %>
					<%
					If IsArray(arrU) Then
					%>	
					  <tr>
						  <td colspan="10" align="right">
						  <%= strPageInfo%>
						  </td>
					  </tr>
					 <%End If%>
                    </tbody></table>
				</div>
				
           
</div>

<!--#include file="../../common/inc/footer_manage.asp"-->