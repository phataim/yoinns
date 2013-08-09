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
	
	'开始保存
	
	
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
		'这里补上其他状态的语句
		'如果是修改原有的，那么状态不变
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
	Dream3CLS.showMsg "保存成功","S",directPage
	
End Sub

Sub ShowEdit()
	pid = Dream3CLS.ChkNumeric(Request.QueryString("pid"))
	Sql = "Select * from T_Product Where id="&Pid
	Set Rs = Dream3CLS.Exec(Sql)
	If Rs.EOF Then
		Call Dream3CLS.MsgBox2("无法找到资源！",0,"0")
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
		gMsgArr = gMsgArr&"|请选择团购分类！"
	End If
	If title = "" Then
		gMsgArr = gMsgArr&"|团购标题不能为空！"
	End If
	If market_price ="" Then
		gMsgArr = gMsgArr&"|市场价不能为空！"
	End If
	If team_price ="" Then
		gMsgArr = gMsgArr&"|团购价不能为空！"
	End If
	If min_number <=0 Then
		gMsgArr = gMsgArr&"|最低数量必须大于0！"
	End If
	If per_number ="" Then
		gMsgArr = gMsgArr&"|请输入每人限购数量！"
	End If
	
	'日期的验证
	'If DateDiff("d",start_time,now) >0   Then
		'gMsgArr = gMsgArr&"|起始时间不能小于当前时间！"
	'End If
	If DateDiff("d",end_time,start_time) >0   Then
		gMsgArr = gMsgArr&"|结束时间不能小于起始时间！"
	End If
	If DateDiff("d",expire_time,start_time) >0   Then
		gMsgArr = gMsgArr&"|券有效期不能小于开始时间！"
	End If
	
	If summary = "" Then
		gMsgArr = gMsgArr&"|本团简介不能为空！"
	End If
	If notice = "" Then
		gMsgArr = gMsgArr&"|特别提示不能为空！"
	End If
	'图片必须至少上传一个
	If img1="" Then
		gMsgArr = gMsgArr&"|商品图片必须至少上传第一个！"
	End If
	
	If partner_id = "" Or partner_id = 0 Then
		gMsgArr = gMsgArr&"|请选择商户！"
	End If
	
	If product = "" Then
		gMsgArr = gMsgArr&"|商品名称不能为空！"
	End If
	If notice = "" Then
		gMsgArr = gMsgArr&"|本单详情不能为空！"
	End If
	If systemreview = "" Then
		gMsgArr = gMsgArr&"|推广辞不能为空！"
	End If
	'如果为自取，必须输入联系电话和地址
	If delivery = "pickup" Then
		If mobile="" Then
			gMsgArr = gMsgArr & "|" & "联系电话不能为空！"
		End If
		If address="" Then
			gMsgArr = gMsgArr & "|" & "提货地址不能为空！"
		End If
	End If
End Sub

Sub validateDraft()

	'虚拟购买如果为空，则默认为0
	If pre_number = "" Then
		pre_number = 0
	End If
	'如果商户为选择如果为空，则暂时设置为0
	If partner_id = "" Then
		partner_id = 0
	End If
	
	If  Len(title) > 255   Then
		gMsgArr = gMsgArr&"|标题不能超过255个字符！"
	End If
	
	'判断日期类型
	If  Not IsDate(start_time)   Then
		gMsgArr = gMsgArr&"|开始日期格式不正确！"
	End If
	If  Not IsDate(end_time)   Then
		gMsgArr = gMsgArr&"|结束日期格式不正确！"
	End If
	If  Not IsDate(expire_time)   Then
		gMsgArr = gMsgArr&"|券有效期格式不正确！"
	End If
	
	
	
	
	'如果为快递，才判断是否为数字
	If delivery = "express" Then
		If Not IsNumeric(fare) Then
			gMsgArr = gMsgArr & "|" & "快递费用必须为数字！"
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
	//删除商品图片
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
					<h2><%If pid="" or pid=0 Then Response.Write("新建") else Response.Write("编辑")%>房源</h2>
				</div> 
					
				<div class="sect">
				<form class="validator"  action="createProduct.asp?act=save" method="post" id="productForm" name="productForm">
					<div class="wholetip clear"><h3>1、基本信息</h3></div>
					<div class="field">
						<label>区域</label>
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
						<label>便利设施</label>
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
 						<input type="submit" class="formbutton" id="leader-submit" name="commit" value="好了，提交" onclick="setDraft('0')">
						<%
						If pid =0 Or pid=""  Then
						%>
						<input type="submit" class="formbutton" id="leader-submit" name="draft" value="保存为草稿" onclick="setDraft('-1')">
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