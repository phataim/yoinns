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
dim panduan2,zipcode
	

	Action = Request.QueryString("act")

	classifier = Dream3CLS.RParam("c")
	
    Sql = "Select * From T_User Where id = "&session("_UserID")
		
		Set Rs = Dream3CLS.Exec(Sql)
		zipcode = Rs("zipcode")
		Set Rs = Nothing
	
	Select Case Action
	    case "shuaxin"
		    call shuaxin()
		Case "del"
			Call DeleteRecord()
		Case Else
			Call Main()
	End Select
	
	Sub DeleteRecord()
	    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''��ɾ���Ƶ��µ����з���--by zhihao
		s_id = Dream3CLS.RParam("id")
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "delete from  T_Product  Where hid="&s_id &" and user_id="&Session("_UserID")
		Dream3CLS.Exec(sql)
		'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''��ɾ���Ƶ�--by zhihao
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "delete from  T_hotel  Where h_id="&s_id &" and h_uid="&Session("_UserID")
		Dream3CLS.Exec(sql)
		 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''���û� �Ƿ񷢲����Ƶ� ��״̬����Ϊδ����,T_user����zipcode������¼�û��Ƿ񷢲����Ƶ�,��ֵΪ��δ����,1Ϊ�Է���,2Ϊ��������ɾ��--by zhihao
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from T_User Where id= "&Session("_UserID")
		Rs.open Sql,conn,1,2
		zipcode="2"
		Rs("zipcode") 	=zipcode
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''by--zhihao
		gMsgArr = "ɾ���ɹ���"
		gMsgFlag = "E"
		
		Call Main()
		
	End Sub
	
	
	Sub Main()	
	
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''��ү����������'''''''''''''''''''''''''''''''''''''''
	        Sql = "Select * From T_User Where id = "&session("_UserID")
	  		Set Rs = Dream3CLS.Exec(Sql)
			states = Rs("state")
			if states=1 then response.Redirect("../../index.asp")
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	   Response.Buffer = True    
       Response.ExpiresAbsolute = Now() - 1    
       Response.Expires = 0    
       Response.CacheControl = "no-cache"
		dim sql1
		sql1="select h_ordertime,h_times,h_resttimes from T_hotel"
	  	Set rs = Server.CreateObject("Adodb.recordset")
		rs.open sql1,conn,1,3
	
		if rs.recordcount>0 then
	    yesterday=DateAdd( "d", -1, now())
		do while not rs.eof		'����һ��ѭ�� ֪����
		if isnull(rs(0)) then   '������if�ṹ����ɶ�� ��´��� �������ǽ�����Ϊnull��ֵ��ʼ�� 
		
        rs(0)=yesterday
		rs(1)=&1
		rs(2)=&1
		
		end if
		

		
	    rs.movenext
	
		loop
		end if
		
		rs.close
		
		set rs=nothing 

		
	
		
		
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
	
	sub shuaxin '���Ǹ����� ���û�����˵�� ��Ȼ�ǵ��ˢ�°�ť��Ĳ���
	
	    Set rs = Server.CreateObject("Adodb.recordset")
	
	    s_id = Dream3CLS.RParam("id")
	
	    rs.open "select h_citycode,h_resttimes from T_hotel where h_id="&s_id &" and h_uid="&Session("_UserID"),conn,1,1
	    Dream3CLS.Exec("update T_hotel set h_ordertime='"&now()&"' where h_id="&s_id &" and h_uid="&Session("_UserID"))    '��h_ordertimeΪ����ʱ��
	    Dream3CLS.Exec("update T_hotel set h_resttimes='"&(rs(1)-1)&"' where h_id="&s_id &" and h_uid="&Session("_UserID"))' ��h_resttimes��һ
		
        response.Redirect "../../list.asp?city="&rs(0) '�ض�����list.aspҳ�棬��������ˢϴЧ�� �������
		rs.close
	end sub 
	

%>
<!--#include file="../../common/inc/header_user.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title><%=Dream3CLS.SiteConfig("SiteName")%>-���Ƿ���</title>

<form id="productForm" name="productForm" method="post" action="?act=save"  class="validator">
<div class="area">
	
    
    <!--#include file="../inc/top.asp"-->
    
    
	<!--#include file="../inc/menu.asp"-->
	
    
    
    <div class="layoutright mt9">
    	<div class="bor">
        	<div class="innr">
            	
                <div class="discbox"><p>�ҵľƵ�</p></div>
            	
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
							Set rs = Server.CreateObject("Adodb.recordset") '����Ҳ���¼ӵ� ʵ����ʲô�أ� �ȿ� ʵ�ֵ����жϽ����ˢ�´������������Ƚϣ����жϱ��panduan2ֵ
							rs.open "select h_resttimes from T_hotel Where h_id="&arru(0,i) &" and h_uid="&Session("_UserID"),conn,1,1
		
		                    if rs(0)>&0 then
		                         panduan2=true
		                    else
		                         panduan2=false																																											
		                    end if
		
		                    rs.close
		                    set rs=nothing	'��仹����˵ô�� ��ʾ�󹦸����		
		%>	
                    <div class="index_r1">
                        <div class="index_r1t"></div>
                        <div class="index_r1m">
                            <div class="index_r1ml">
                               <img class="img" height="100" width="150" src="<%=image%>">
                                
                                
                            </div>
                            <div class="index_r1mr">
                                <a href="<%=VirtualPath%>/hotelsend.asp?act=showedit&pid=<%=h_id%>" target=_blank><h3 class="tit_st"><%=hotelname%></h3></a>
                                <div class="room_tt">
                                    <div class="t"><h1></h1><h2><%=headname%></h2><h3></h3>(<%=createtime%>����)</div>
                                    <div class="t"><%=address%></div>
                                </div>
                                <div class="room_bb">
                                    <div class="t1"> 
									<%=left(discription,40)%></div>
                                    <div class="yym-room">
                                        <ul>
										
                                        <li class="li1">
											<a href="<%=VirtualPath%>/hotelsend.asp?act=showedit&pid=<%=h_id%>">�޸�</a>
										</li>
										
                                        <li class="li2">
										<a class="delete" href="?act=del&id=<%=h_id%>" onclick="return confirm('ɾ��������¼���þƵ꼰�����еķ�����ϢҲ����ɾ����ȷ��Ҫɾ��������¼��')">ɾ��</a>
										</li>
                                        <% if panduan2 then  %>
                                       <li class="li7">
										<a class="shuaxin" href="?act=shuaxin&id=<%=h_id%>" >ˢ��</a> <!--����˵��䣬����������shuanxin������-->
										</li>
                                        
                                        <%else%>
                                         <li class="li7unable">
										ˢ��  
										</li>
                                                                         
										 <%end if%>
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
