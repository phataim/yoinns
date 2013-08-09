<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim title

	Action = Request.QueryString("act")
	Select Case Action
		Case "sethot"
				Call SetHot()
		Case "delete"
				Call DeleteRecord()
		Case "cancelhot"
				Call CancelHot()
		Case Else
				Call Main()
	End Select
	
	Sub DeleteRecord()
		provincecode = Dream3CLS.ChkNumeric(Request.QueryString("provincecode"))
		
		s_provincecode = left(provincecode,2)

		Sql = "Delete From T_City Where citypostcode like '"&s_provincecode&"%'"
		
		Dream3CLS.Exec(Sql)
		gMsgFlag = "S"
		gMsgArr = "ɾ���ɹ�"
		Call Main()
	End Sub
	
	Sub SetHot()
		s_citypostcode = Dream3CLS.RParam("provincecode")
		
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "Select *  from T_City  Where citypostcode ='"&s_citypostcode&"'"

		Set Rs = Server.CreateObject("Adodb.recordset")
		Rs.Open sql,conn,1,2
		Rs("hotflag") = "Y"
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		gMsgArr = "�������ųɹ���"
		gMsgFlag = "S"
		
		Call Main()
		
	End Sub
	
	Sub CancelHot()
		s_citypostcode = Dream3CLS.RParam("provincecode")
		Set Rs = Server.CreateObject("Adodb.recordset")
		sql = "Select *  from T_City  Where citypostcode ='"&s_citypostcode&"'"

		Set Rs = Server.CreateObject("Adodb.recordset")
		Rs.Open sql,conn,1,2
		Rs("hotflag") = "N"
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
		gMsgArr = "ȡ�����ųɹ���"
		gMsgFlag = "S"
			
		Call Main()
		
	End Sub
	

	
	Sub Main()		
		
		
		sql = "select * from T_City Where 1=1 and depth =1 order by cityprefix "
		
		Set cityRs = Dream3CLS.Exec(sql)
			
		
			
		title = "ʡ��"
		
	End Sub
	
%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->

<div class="PageTitleArea">
	<div class="PageTitle">
        <span class="fl"><%=title%></span>
        <span class="fr">
        	<a class="ajaxlink" href="provinceEdit.asp?act=showAdd">�½�<%=title%></a>
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
						<th nowrap="" width="120">���д���</th>
						<th nowrap="" width="70">����ĸ</th>
						<th nowrap="" width="120">�Ƿ�ֱϽ��</th>
						<th nowrap="" width="60">����</th>
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
						<td><%=s_zxs_str%></td>
						<td><%=s_hotflag_str%></td>
						<td align="center">
						
					
						<%If s_hotflag = "Y" then%>
						<a class="ajaxlink" href="?act=cancelhot&provincecode=<%=s_citycode%>">ȡ������</a>
						<%Else%>
						<a class="ajaxlink" href="?act=sethot&provincecode=<%=s_citycode%>">��Ϊ����</a>
						<%End If%>
						 |
						
						
						<a class="ajaxlink" href="province.asp?act=delete&provincecode=<%=s_citycode%>" onclick="return window.confirm('��ȷ��Ҫɾ��������¼?')">ɾ��ʡ��</a>|
						<a class="ajaxlink" href="city.asp?provincecode=<%=s_citycode%>">�鿴����</a>
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
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->