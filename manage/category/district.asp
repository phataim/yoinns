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
		gMsgArr = "ɾ���ɹ�"
		Call Main()
	End Sub

	
	Sub Main()		
		
		citycode = Dream3CLS.RParam("citycode")
		s_citycode_pre = Left(citycode,4)
		
		provincecode = Left(citycode,2) & "0000"
		
		sql = "select * from T_City Where 1=1 and depth = 3 and citypostcode like '"&s_citycode_pre&"%' order by cityprefix desc"
		't(sql)
		Set cityRs = Dream3CLS.Exec(sql)
			
		
			
		title = "����"
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl"><%=title%></span>
        <span class="fr">
        	<a href="districtEdit.asp?act=showAdd&citycode=<%=citycode%>">��������</a>
            <a href="city.asp?provincecode=<%=provincecode%>">���س���</a>
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
						<th nowrap="" width="200">��������</th>
						<th nowrap="" width="120">�������</th>
						<th nowrap="" width="70">����ĸ</th>
						<th nowrap="" width="35%" align="center">����</th>
					</tr>
					<%
					Do While Not cityRs.EOF
						s_citycode = cityRs("citypostcode")
						s_cityname = cityRs("cityName")
						s_cityprefix = cityRs("cityprefix")
						s_zxs = cityRs("zxs")
						If s_zxs = "1" Then
							s_zxs_str = "��"
						Else
							s_zxs_str = "��"
						End If
						s_hotflag = cityRs("hotflag")
						If s_hotflag = "Y" Then
							s_hotflag_str = "��"
						Else
							s_hotflag_str = "��"
						End If
					%>			
					<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
						<td><%=s_cityname%></td>
						<td><%=s_citycode%></td>
						<td><%=s_cityprefix%></td>
						<td align="center">
						
					
						<a class="ajaxlink" href="?act=delete&citycode=<%=s_citycode%>&districtcode=<%=s_citycode%>" onclick="return confirm('ȷ��Ҫɾ����');">ɾ��</a>
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