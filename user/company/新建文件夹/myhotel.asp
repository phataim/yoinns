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
Dim userid,h_id,h_hotelname,h_address,h_img,image,h_discription,h_createtime


	Action = Request.QueryString("act")
	classifier = Dream3CLS.RParam("c")
	
	Select Case Action
		Case "del"
			Call DeleteRecord()
		Case Else
			Call Main()
	End Select
	
	Sub DeleteRecord()
		s_id = Dream3CLS.RParam("id")
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "delete from  T_hotel  Where h_id="&s_id &" and h_uid="&Session("_UserID")
		Dream3CLS.Exec(sql)
		
		gMsgArr = "删除成功！"
		gMsgFlag = "E"
		
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
		
		searchStr = " and h_uid="&Session("_UserID")
		
		
		Sql = "Select * from T_hotel Where 1=1 "&searchStr
		Sql = Sql &" Order By h_createtime Desc"
		
		sqlCount = "SELECT Count(h_id) FROM T_hotel where 1=1 "&searchStr
	
			
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
            	
                <div class="discbox"><p>我的酒店</p></div>
            	
                <div class="sortbox">
                    <div class="sort_innr">
                        <div class="tags">
                            <!--#include file="menu.asp"-->
                        </div>                   
                    </div>
                </div>
                
                <div class="search_con clearfix">
                	
					<%
					If IsArray(arrU) Then
						For i = 0 to UBound(arrU, 2)
							h_id = arrU(0,i)
							hotelname = arrU(1,i)
							headname = arrU(2,i)
							address= arrU(5,i)
							h_img= arrU(6,i)
							If h_img <> "" Then 
								image = "../../"&h_img
							Else
								image = VirtualPath & "/images/noimage.gif"
							End If
							createtime= arrU(12,i)
							discription = arrU(7,i)
							
					%>	
                    <div class="index_r1">
                        <div class="index_r1t"></div>
                        <div class="index_r1m">
                            <div class="index_r1ml">
                                <a target="_blank" href="#"><img class="img" height="100" width="150" src="<%=image%>"></a>
                                
                                
                            </div>
                            <div class="index_r1mr">
                                <h3 class="tit_st"><%=hotelname%></h3>
                                <div class="room_tt">
                                    <div class="t"><h1></h1><h2><%=headname%></h2><h3></h3>(<%=createtime%>发布)</div>
                                    <div class="t"><%=address%></div>
                                </div>
                                <div class="room_bb">
                                    <div class="t1"> 
									<%=discription%></div>
                                    <div class="yym-room">
                                        <ul>
										
                                        <li class="li1">
											<a href="<%=VirtualPath%>/hotelsend.asp?act=showedit&pid=<%=h_id%>">修改</a>
										</li>
										
                                        <li class="li2">
										<a class="delete" href="?act=del&id=<%=h_id%>" onclick="return confirm('删除此条记录，相关房屋信息也将被删除，确定要删除这条记录吗？')">删除</a>
										</li>
										 
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="ceng_tp" style="display:none ">
                            
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
