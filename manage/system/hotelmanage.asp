<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<%
Dim Action
Dim Recommendnum,Returntime,Returnpresent,Longtime,Discountarea

	Action = Request.QueryString("act")
	Select Case Action
		   Case "save"
		   		Call save()
		   Case Else
				Call Main()
	End Select
	
	Sub Save()
		Recommendnum = Request.Form("Recommendnum")
		Returntime = Request.Form("Returntime")
		Returnpresent = Request.Form("Returnpresent")
		Longtime = Request.Form("Longtime")
		Discountarea = Request.Form("Discountarea")
	
		If Trim(Recommendnum) = "" Then
			Recommendnum=1
		End If
		If Trim(Returntime) = "" Then
			Returntime="18:00"
		End If
		If Trim(Returnpresent) = "" Then
			Returntime=60
		End If
		If Trim(Longtime) = "" Then
			Returntime=1
		End If
		If Trim(Discountup) = "" Then
			Discountup=10
		End If
		If Trim(Discountdown) = "" Then
			Discountdown=10
		End If
	
		Set Rs = Server.CreateObject("Adodb.recordset")
		Sql = "Select * from t_hotelconfig where id=1"
		Rs.open Sql,conn,1,2
		
		Rs("Recommendnum") =Recommendnum
		Rs("Returntime") =Returntime
		Rs("Returnpresent") =Returnpresent
		Rs("Longtime") = Longtime
		Rs("Discountarea") = Discountarea
		
		Rs.Update
		Rs.Close
		Set Rs = Nothing
		
	End Sub

	
	Sub Main()		
		Sql = "Select * from t_hotelconfig where id=1"
		Set Rs = Dream3CLS.Exec(Sql)
		if not Rs.eof then
			Recommendnum = Rs("Recommendnum")
			Returntime = Rs("Returntime")
			Returnpresent = Rs("Returnpresent")
			Longtime = Rs("Longtime")
			Discountarea = Rs("Discountarea")
		end if 
	End Sub
	

%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<div class="PageTitleArea">
	<div class="PageTitle"><span class="fl">�Ƶ��������</span><span class="fr">&nbsp;</span></div>
    <div class="say">
    </div>
</div>

<div id="box">
	<div class="sect">
				<form method="post" action="hotelmanage.asp?act=save">
                     
						<div class="wholetip clear"><h3>��������</h3></div>
						
						<div class="field">
                            <label>�Ƶ��Ƽ�����</label>
							<input type="text" name="Recommendnum" value="<%=Recommendnum%>" style="width: 100px;" class="f-input" size="30"><span class="inputtip"></span>
                        </div>
						<div class="wholetip clear"><h3>�˿�����</h3></div>
						<div class="field">
                            <label>�˿�����</label>
							<input type="text" name="Returntime" value="<%=Returntime%>" style="width: 100px;" class="f-input" size="30"><span class="inputtip">�磺18��00</span>
                        </div>
						<div class="field">
                            <label>�˿����</label>
							<input type="text" name="Returnpresent" value="<%=Returnpresent%>" style="width: 100px;" class="f-input" size="30"><span class="inputtip">%</span>
                        </div>
						<div class="wholetip clear"><h3>�Ż�����</h3></div>
						<div class="field">
                            <label>�Żݳ���ʱ��</label>
							<input type="text" name="Longtime" value="<%=Longtime%>" style="width: 100px;" class="f-input" size="30"><span class="inputtip">Сʱ</span>
                        </div>
						<div class="field">
                            <label>�ۿ�����</label>
							<input type="text" name="Discountup" value="<%=Discountup%>" style="width: 100px;" class="f-input" size="30"><span class="inputtip">--&nbsp;&nbsp;&nbsp;&nbsp;</span><input type="text" name="Discountdown" value="<%=Discountdown%>" style="width: 100px;" class="f-input" size="30"><span class="inputtip">��</span>
                        </div>
						</div>
						
						
						<div class="act">
                            <input type="submit" class="formbutton" value="����">
                        </div>
						
					</form>
                </div>      
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->