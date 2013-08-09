<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim title ,citycode,provincecode

	Action = Request.QueryString("act")
	Select Case Action
		Case "delete"
			Call DeleteRecord()
		Case Else
			Call Main()
	End Select
	
	
	Sub DeleteRecord()
		districtcode = Dream3CLS.RParam("districtcode")
		
		citycode = Dream3CLS.RParam("citycode")
		

		Sql = "Delete From T_City Where citypostcode = '"&districtcode&"'"

		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		gMsgArr = "删除成功"
		Call Main()
	End Sub

	
	Sub Main()		
		
		citycode = Dream3CLS.RParam("citycode")
		s_citycode_pre = Left(citycode,4)
		
		provincecode = Left(citycode,2) & "0000"
		
		sql = "select * from T_City Where 1=1 and depth = 3 and citypostcode like '"&s_citycode_pre&"%' order by cityprefix desc"
		't(sql)
		Set cityRs = Dream3CLS.Exec(sql)
			
		
			
		title = "区域"
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl"><%=title%></span>
        <span class="fr">
        	<a href="districtEdit.asp?act=showAdd&citycode=<%=citycode%>">新增地区</a>
            <a href="city.asp?provincecode=<%=provincecode%>">返回城市</a>
        </span>
    </div>
    <div class="say">
        
    </div>
</div>

<div id="box">

					
				<div class="sect">
					<table cellspacing="0" cellpadding="0" border="0" id="orders-list" class="coupons-table">
					<tbody>
					
					<tr>
						<th nowrap="" width="200">区域名称</th>
						<th nowrap="" width="120">区域代码</th>
						<th nowrap="" width="70">首字母</th>
						<th nowrap="" width="35%" align="center">操作</th>
					</tr>
					<%
					Do While Not cityRs.EOF
						s_citycode = cityRs("citypostcode")
						s_cityname = cityRs("cityName")
						s_cityprefix = cityRs("cityprefix")
						s_zxs = cityRs("zxs")
						If s_zxs = "1" Then
							s_zxs_str = "是"
						Else
							s_zxs_str = "否"
						End If
						s_hotflag = cityRs("hotflag")
						If s_hotflag = "Y" Then
							s_hotflag_str = "是"
						Else
							s_hotflag_str = "否"
						End If
					%>			
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td><%=s_cityname%></td>
						<td><%=s_citycode%></td>
						<td><%=s_cityprefix%></td>
						<td align="center">
						
					
						<a class="ajaxlink" href="?act=delete&citycode=<%=s_citycode%>&districtcode=<%=s_citycode%>" onclick="return confirm('确信要删除？');">删除</a>
						</td>
					  </tr>
					  <%
					  		cityRs.MoveNext
						Loop
					  %>
					 
                    </tbody>
					
					</table>
				</div>

</div>
<!--#include file="../../common/inc/footer_manage.asp"-->