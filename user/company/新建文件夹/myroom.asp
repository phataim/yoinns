<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_main.asp"-->
<!--#include file="../../common/inc/permission_user.asp"-->
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
Dim productIdArr(),userIdArr()
Dim stateStr
Dim classifier,classifierStyle
dim hid,roomdesc


	Action = Request.QueryString("act")
	classifier = Dream3CLS.RParam("c")
	
	Select Case Action
		Case "online"
			Call Online()
		Case "offline"
			Call Offline()
		Case "del"
			Call DeleteRecord()
		Case Else
			Call Main()
	End Select
	
	Sub DeleteRecord()
		s_id = Dream3CLS.RParam("id")
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "Update  T_Product set state = 'delete'  Where id="&s_id &" and user_id="&Session("_UserID")
		Dream3CLS.Exec(sql)
		
		gMsgArr = "删除成功！"
		gMsgFlag = "E"
		
		Call Main()
		
	End Sub
	
	Sub Offline()
		s_id = Dream3CLS.RParam("id")
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "Select *  from T_Product  Where id="&s_id

		Set Rs = Server.CreateObject("Adodb.recordset")
		Rs.Open sql,conn,1,2
		If Rs("user_id") = Session("_UserID") Then
			If Rs("online") = "Y" Then
				Rs("online") = "N"
				Rs.Update
			End If
			gMsgArr = "下线成功！"
			gMsgFlag = "S"
		Else
			gMsgArr = "您无权修改该信息！"
			gMsgFlag = "E"
		End If
		
		
		Rs.Close
		Set Rs = Nothing
		
		
		Call Main()
		
	End Sub
	
	Sub Online()
		s_id = Dream3CLS.RParam("id")
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "Select *  from T_Product  Where id="&s_id

		Set Rs = Server.CreateObject("Adodb.recordset")
		Rs.Open sql,conn,1,2
		If Rs("user_id") = Session("_UserID") Then
			If Rs("online") <> "Y" and Rs("state") = "normal"  Then
				Rs("online") = "Y"
				Rs.Update
			End If
			gMsgArr = "上线成功！"
			gMsgFlag = "S"
		Else
			gMsgArr = "您无权修改该信息！"
			gMsgFlag = "E"
		End If
		
		
		Rs.Close
		Set Rs = Nothing
		
		
		Call Main()
		
	End Sub

	
	Sub Main()	
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
			Case "cjz"
				searchStr = searchStr & " and state='pending'"
				classifierStyle = "cjz"
			Case "shz"
				searchStr = searchStr & " and state='auditing'"
				classifierStyle = "shz"
			Case "wtg"
				searchStr = searchStr & " and state='unpass'"
				classifierStyle = "wtg"
			Case "ytg"
				searchStr = searchStr & " and state='normal'"
				classifierStyle = "ytg"
			Case "ygq"
				searchStr = searchStr & " and state='expired'"
				classifierStyle = "ygq"
			Case else
				searchStr = searchStr & " and state <> 'delete'"
		End Select
		
		searchStr = searchStr & " and user_id="&Session("_UserID")
		
		
		Sql = "Select id,state,houseTitle,lodgetype,leasetype,roomtitle,image,create_time,address,dayrentprice,weekrentprice,monthrentprice,online,hid,roomdesc from T_Product Where 1=1 "&searchStr
		Sql = Sql &" Order By create_time Desc"
		
		sqlCount = "SELECT Count(id) FROM T_Product where 1=1"&searchStr
	
			
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

	End Sub
%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=Dream3CLS.SiteConfig("SiteName")%>-我是房东</title>

<form id="productForm" name="productForm" method="post" action="?act=save"  class="validator">
<div class="area">
	
    
    <!--#include file="../inc/top.asp"-->
    
    
	<!--#include file="../inc/menu.asp"-->
	
    
    
    <div class="layoutright mt9">
    	<div class="bor">
        	<div class="innr">
            	
                <div class="discbox"><p>我的房间</p></div>
            	
                <div class="sortbox">
                    <div class="sort_innr">
                        <div class="tags">
                            <!--#include file="menu.asp"-->
                        </div>                   
                    </div>
                </div>
                
                <div class="search_con clearfix">
                	
                    <div class="menu_myroom">
                    	<ul class="cont">
                        	<li <%If classifierStyle = "all" Then%>class="current"<%End If%>><a href="?c=all">全部房型</a></li>
                            <li <%If classifierStyle = "cjz" Then%>class="current"<%End If%>><a href="?c=cjz">创建中</a></li>
                            <li <%If classifierStyle = "shz" Then%>class="current"<%End If%>><a href="?c=shz">审核中</a></li>
                            <li <%If classifierStyle = "wtg" Then%>class="current"<%End If%>><a href="?c=wtg">未通过</a></li>
                            <li <%If classifierStyle = "ytg" Then%>class="current"<%End If%>><a href="?c=ytg">已通过</a></li>
							<li <%If classifierStyle = "ygq" Then%>class="current"<%End If%>><a href="?c=ygq">已过期</a></li>
                        </ul>
                    </div>
                    
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
							product_id = arrU(0,i)
							housetitle = arrU(5,i)
							hid = arrU(13,i)
							roomdesc = arrU(14,i)
							roomdesc=Left(roomdesc,80)
							statestr = arrU(1,i)
							onlineflag = false
							If statestr = "pending" Then
								stateimg = Dream3CLS.GetStylePath() &"/img/cjz.png"
							Elseif  statestr = "normal" Then
								onlineflag = true
								stateimg = Dream3CLS.GetStylePath() &"/img/ytg.png"
							Elseif  statestr = "unpass" Then
								stateimg = Dream3CLS.GetStylePath() &"/img/wtg.png"
							Elseif  statestr = "auditing" Then
								stateimg = Dream3CLS.GetStylePath() &"/img/shz.png"
							Elseif  statestr = "expired" Then
								stateimg = Dream3CLS.GetStylePath() &"/img/ygq.png"
							End If
							lodgeType = arrU(3,i)
							leasetype = arrU(4,i)
							lodgeType = Dream3Static.GetLodgeType(lodgeType)
							leasetype = Dream3Static.GetLeaseType(leaseType)
							
							image = arrU(6,i)
							If image <> "" Then 
								image = "../../"&image
							Else
								image = VirtualPath & "/images/noimage.gif"
							End If
							createTime = Dream3CLS.Formatdate(arrU(7,i),2)
							address = arrU(8,i)
							dayrentprice  = arrU(9,i)
							If dayrentprice = 0 Then 
								dayrentpriceStr = "未设置"
							Else
								dayrentpriceStr = dayrentprice
							End if
							weekrentprice = arrU(10,i)
							If weekrentprice = 0 Then 
								weekrentpriceStr = "未设置"
							Else
								weekrentpriceStr = weekrentprice
							End if
							
							monthrentprice = arrU(11,i)
							If monthrentprice = 0 Then 
								monthrentpriceStr = "未设置"
							Else
								monthrentpriceStr = monthrentprice
							End if
							
							s_online = arrU(12,i)
							If IsNull(s_online) Then s_online = ""
							houseTitle = arrU(2,i)
					%>	
                    <div class="index_r1">
                        <div class="index_r1t"></div>
                        <div class="index_r1m">
                            <div class="index_r1ml">
                                <a target="_blank" href="../../preview.asp?pid=<%=product_id%>"><img class="img" height="100" width="150" src="<%=image%>"></a>
                                <div class="button_tt"><a href="#"><img src="<%=stateimg%>"></a></div>
                                <div class="bt_title"><%=createTime%></div>
                            </div>
                            <div class="index_r1mr">
                                <h3 class="tit_st">
								</h3>
                                <div class="room_tt">
                                    <div class="t"><h1></h1><h2>
									<%=houseTitle%>——
									<%
								Sql = "Select * from T_hotel where h_id="&hid
								Set Rs = Dream3CLS.Exec(Sql)
								%>
								<%=Rs("h_hotelname")%> 
								<%Rs.close%></h2><h3></h3>(<%=createTime%>发布)</div>
                                    <div class="t"><%=roomdesc%></div>
                                </div>
                                <div class="room_bb">
                                    <div class="t1"> 
									日租价: <b><%=dayrentpriceStr%></b><%If dayrentprice <> 0 Then%>元/晚<%End If%> · 
									周末价: <b><%=weekrentpriceStr%></b><%If weekrentprice <> 0 Then%>元/周<%End If%> · 
									月租价: <b><%=monthrentpriceStr%></b><%If monthrentprice <> 0 Then%>元/月<%End If%></div>
                                    <div class="yym-room">
                                        <ul>
										<%
										s_alert_str = ""
										If statestr = "normal" Then
											s_alert_str = "onclick=""return confirm('修改已审核过的订单将需要重新审核 ,且未付款完成的订单将失效\n确信要修改？')"""
										End If
										%>
                                        <li class="li1">
											<a href="<%=VirtualPath%>/pstep1.asp?act=showedit&pid=<%=product_id%>" <%=s_alert_str%>>修改</a>
										</li>
										
                                        <li class="li2">
										<a class="delete" href="?c=<%=classifier%>&act=del&id=<%=product_id%>" onclick="return confirm('确定要删除这条记录吗？')">删除</a>
										</li>
										<%If onlineflag and s_online <> "Y" Then%>
                                        <li class="li6">
											<a href="?c=<%=classifier%>&act=online&id=<%=product_id%>">上线</a>
										<%Else%>
											<li class="li6unable">上线
										<%End If%>
										</li>
										
										<%If onlineflag and s_online = "Y" Then%>
                                        <li class="li3">
											<a href="?c=<%=classifier%>&act=offline&id=<%=product_id%>">下线</a>
										<%Else%>
											<li class="li3unable">下线
										<%End If%>
										</li>                    
                                    
										<%If statestr = "auditing" Then%>
                                        <li class="li5">
											<a href="<%=VirtualPath%>/pstep4.asp?pid=<%=product_id%>">改价格</a>
										<%Else%>
											<li class="li5unable">改价格
										<%End If%>
										</li>
										
                                      
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="ceng_tp" style="display:none ">
                              <p class="tiptip ceng_tm"><a href="#"> 请填写支付账号，请填写手机号码。</a></p>
                            </div>
                        </div>
                        <div class="index_r1b"></div>
                    </div>
                    <%
						Next
					  End If
					%>
                    
					<%If IsArray(arrU) Then%>
					<div class="quotes">
					<%= strPageInfo%>
					</div>
					<%End If%>
                    
                </div>
                
            </div>
        </div>
    </div>
    
    
    
</div>
</form>
<!--#include file="../../common/inc/footer_user.asp"-->
