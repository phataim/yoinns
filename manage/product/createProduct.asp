<!--#include file="../../conn.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/inc/permission_manage.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<%
Dim Action
Dim town_select
Dim default_province,default_city,default_town

Dim city_code,facilities
Dim city_id,title,partner_id
Dim start_time,end_time,expire_time
Dim img1,img2,img3,flv,seqno
Dim hidDraft,directPage,pid

Action = Request.QueryString("act")
Select Case Action
	Case "save"
		Call SaveRecord()
	Case "showedit"
		Call ShowEdit()
	Case Else
		Call Main()
End Select

Sub SaveRecord()
 	pid = Dream3CLS.ChkNumeric(Request.Form("pid"))
 	hidDraft = request.Form("hidDraft")
	city_code = Dream3CLS.RParam("town_select")
	facilities = Dream3CLS.RParam("facilities")
	
	
	
	If(len(trim(facilities)) > 0 ) Then	
		facilityArr = Split(facilities,",")
		facilities = ""
		For i = 0 To UBound(facilityArr)
			If i = 0 Then 
				facilities = Trim(facilityArr(i))
			Else
				facilities = facilities & "," & Trim(facilityArr(i))
			End If
			
		Next
	End If
	
	
	
	If hidDraft = "-1" Then
		'Call validateDraft()
	Else
		'validate Form
		'Call validateDraft()
		'Call validateSubmit()
	End If
	

	
	
	If len(gMsgArr) > 0 Then 
		gMsgFlag = "E"
		Exit Sub
	End If
	
	'��ʼ����
	
	
	Set Rs = Server.CreateObject("Adodb.recordset")
	Sql = "Select * from T_Product"
	If pid <> 0 Then
		Sql = Sql & " Where ID="&pid
	End If
	
	Rs.open Sql,conn,1,2
	If pid = 0  Then 
		Rs.AddNew
	End If
	Rs("city_code") = city_code
	Rs("facilities") = facilities
	
	
	If hidDraft = "-1" then
		'Rs("state") = "draft" 
	Else
		'���ﲹ������״̬�����
		'������޸�ԭ�еģ���ô״̬����
		If pid = 0 Then
			'Rs("state") = "normal"
		Else
			'If Rs("state")="draft" Then
				'Rs("state") = "normal"
			'End If
			
		End If 
		 
	End If
	
	Rs.Update

	Rs.Close
	Set Rs = Nothing
	
	If hidDraft="-1" Then
		'directPage = "index.asp?classifier=draft"
	else
		directPage = "index.asp"
	End If
	Dream3CLS.showMsg "����ɹ�","S",directPage
	
End Sub

Sub ShowEdit()
	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	Sql = "Select * from T_Product Where id="&Pid
	Set Rs = Dream3CLS.Exec(Sql)
	If Rs.EOF Then
		Call Dream3CLS.MsgBox2("�޷��ҵ���Դ��",0,"0")
		response.End()
	End If
	
	city_code = Rs("city_code") 
	default_province = mid(cstr(city_code),1,2) & "0000"
	default_city = mid(cstr(city_code),1,4) & "00"
	default_town = city_code
	
	't(default_province)
	
	facilities = Rs("facilities") 
	facilities = ","&facilities&","
	
	

End Sub

Sub validateSubmit()
	If group_id = 0 Then
		gMsgArr = gMsgArr&"|��ѡ���Ź����࣡"
	End If
	If title = "" Then
		gMsgArr = gMsgArr&"|�Ź����ⲻ��Ϊ�գ�"
	End If
	If market_price ="" Then
		gMsgArr = gMsgArr&"|�г��۲���Ϊ�գ�"
	End If
	If team_price ="" Then
		gMsgArr = gMsgArr&"|�Ź��۲���Ϊ�գ�"
	End If
	If min_number <=0 Then
		gMsgArr = gMsgArr&"|��������������0��"
	End If
	If per_number ="" Then
		gMsgArr = gMsgArr&"|������ÿ���޹�������"
	End If
	
	'���ڵ���֤
	'If DateDiff("d",start_time,now) >0   Then
		'gMsgArr = gMsgArr&"|��ʼʱ�䲻��С�ڵ�ǰʱ�䣡"
	'End If
	If DateDiff("d",end_time,start_time) >0   Then
		gMsgArr = gMsgArr&"|����ʱ�䲻��С����ʼʱ�䣡"
	End If
	If DateDiff("d",expire_time,start_time) >0   Then
		gMsgArr = gMsgArr&"|ȯ��Ч�ڲ���С�ڿ�ʼʱ�䣡"
	End If
	
	If summary = "" Then
		gMsgArr = gMsgArr&"|���ż�鲻��Ϊ�գ�"
	End If
	If notice = "" Then
		gMsgArr = gMsgArr&"|�ر���ʾ����Ϊ�գ�"
	End If
	'ͼƬ���������ϴ�һ��
	If img1="" Then
		gMsgArr = gMsgArr&"|��ƷͼƬ���������ϴ���һ����"
	End If
	
	If partner_id = "" Or partner_id = 0 Then
		gMsgArr = gMsgArr&"|��ѡ���̻���"
	End If
	
	If product = "" Then
		gMsgArr = gMsgArr&"|��Ʒ���Ʋ���Ϊ�գ�"
	End If
	If notice = "" Then
		gMsgArr = gMsgArr&"|�������鲻��Ϊ�գ�"
	End If
	If systemreview = "" Then
		gMsgArr = gMsgArr&"|�ƹ�ǲ���Ϊ�գ�"
	End If
	'���Ϊ��ȡ������������ϵ�绰�͵�ַ
	If delivery = "pickup" Then
		If mobile="" Then
			gMsgArr = gMsgArr & "|" & "��ϵ�绰����Ϊ�գ�"
		End If
		If address="" Then
			gMsgArr = gMsgArr & "|" & "�����ַ����Ϊ�գ�"
		End If
	End If
End Sub

Sub validateDraft()

	'���⹺�����Ϊ�գ���Ĭ��Ϊ0
	If pre_number = "" Then
		pre_number = 0
	End If
	'����̻�Ϊѡ�����Ϊ�գ�����ʱ����Ϊ0
	If partner_id = "" Then
		partner_id = 0
	End If
	
	If  Len(title) > 255   Then
		gMsgArr = gMsgArr&"|���ⲻ�ܳ���255���ַ���"
	End If
	
	'�ж���������
	If  Not IsDate(start_time)   Then
		gMsgArr = gMsgArr&"|��ʼ���ڸ�ʽ����ȷ��"
	End If
	If  Not IsDate(end_time)   Then
		gMsgArr = gMsgArr&"|�������ڸ�ʽ����ȷ��"
	End If
	If  Not IsDate(expire_time)   Then
		gMsgArr = gMsgArr&"|ȯ��Ч�ڸ�ʽ����ȷ��"
	End If
	
	
	
	
	'���Ϊ��ݣ����ж��Ƿ�Ϊ����
	If delivery = "express" Then
		If Not IsNumeric(fare) Then
			gMsgArr = gMsgArr & "|" & "��ݷ��ñ���Ϊ���֣�"
		End If
	Else
		fare = 0
	End If
End Sub




Sub Main()	
	
	default_province = 440000
	default_city = 440300
	default_town = 440303
						
	seqno = 0
	start_time = FormatDateTime(DateAdd("d",1,now),2)
	end_time = FormatDateTime(DateAdd("d",2,now),2)
	expire_time = FormatDateTime(DateAdd("m",3,start_time),2)
End Sub

%>
<!--#include file="../../common/inc/header_manage.asp"-->
<!--#include file="menu.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="../../common/js/jquery/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="../../xheditor/xheditor-zh-cn.min.js"></script>
<script type="text/javascript" src="../../common/api/Wo_Modal.js"></script>
<script type="text/javascript" src="../../common/js/tools.js"></script>

<script type="text/javascript" src="../../common/js/city_common.js"></script>



<script type="text/javascript" >
	//ɾ����ƷͼƬ
	function deleteImage(value){
		document.getElementById("src_img_"+value).src = "../../images/noimage.gif";
		document.getElementById("src_img_h"+value).value = "";
	}
</script>
<script type="text/javascript">
$(pageInit);
function pageInit()
{
	//$('#notice').xheditor({upImgUrl:"../../common/upload/upload.asp",upImgExt:"jpg,jpeg,gif,png",shortcuts:{'ctrl+enter':submitForm}});
	//$('#detail').xheditor({upImgUrl:"../../common/upload/upload.asp",upImgExt:"jpg,jpeg,gif,png",shortcuts:{'ctrl+enter':submitForm}});
}
//function submitForm(){$('#teamForm').submit();}
</script>
<div id="box">
<div class="clear mainwide" id="content">
        <div class="clear box">
            
            <div class="box-content">
                <div class="head">				
					<h2><%If pid="" or pid=0 Then Response.Write("�½�") else Response.Write("�༭")%>��Դ</h2>
				</div> 
					
				<div class="sect">
				<form class="validator"  action="createProduct.asp?act=save" method="post" id="productForm" name="productForm">
					<div class="wholetip clear"><h3>1��������Ϣ</h3></div>
					<div class="field">
						<label>����</label>
						<script type="text/javascript" charset="gb2312">
						<!--
						var default_province = <%=default_province%>;
						var default_city = <%=default_city%>;
						var default_town = <%=default_town%>;
					  //-->
					  </script>
					  <!--#include file="../../common/js/city_select.asp"-->
					</div>
				  <div class="field">
						<label>������ʩ</label>
						<%
						Set facilityRs = Server.CreateObject("adodb.recordset")			
						Sql = "select id,cname from T_Facility Where  enabled='Y' order by seqno desc"
						facilityRs.open Sql,conn,1,2
						i = 0
						Do While Not facilityRs.EOF 
							
							If instr(facilities,","&facilityRs("id")&",") Then
								isChecked = "checked"
							Else
								isChecked = ""
							End If
							'response.Write("<option "&isSelected&" value='"&categoryRs("id")&"'>"&categoryRs("cname")&"</option>")
							response.Write(facilityRs("cname")&"<input type=""checkbox"" "&isChecked&" name=""facilities"" value="&facilityRs("id")&" />")
							facilityRs.Movenext
							i = i + 1
							if(i mod 2 = 0) Then response.Write("<BR>")
						Loop
						%>
                      			
					</div>
					
					<div class="act">
						<input type="hidden" id="hidDraft" name="hidDraft" value=""/>
						<input type="hidden" id="pid" name="pid" value="<%=pid%>"/>
 						<input type="submit" class="formbutton" id="leader-submit" name="commit" value="���ˣ��ύ" onclick="setDraft('0')">
						<%
						If pid =0 Or pid=""  Then
						%>
						<input type="submit" class="formbutton" id="leader-submit" name="draft" value="����Ϊ�ݸ�" onclick="setDraft('-1')">
						<%
						End If
						%>
					</div>
				</form>
                </div>
				
            </div>
            
        </div>
	</div>
</div>
<!--#include file="../../common/inc/footer_manage.asp"-->