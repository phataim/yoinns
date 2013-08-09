<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->
<!--#include file="../common/api/cls_pageview.asp"-->
<!--#include file="../common/api/cls_map.asp"-->
<!--#include file="../common/api/cls_product.asp"-->
<!--#include file="../common/inc/share_common.asp"-->
<%
Dim Action
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim id,title,searchStr
Dim userIdArr()
Set userMap = new AspMap

	Action = Request.QueryString("act")
	Select Case Action
		Case Else
			Call Main()
	End Select
	
	
	
	Sub Main()	
		content = Dream3CLS.RSQL("content")
		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		strLocalUrl = strLocalUrl&"?content="&content
		
		intPageNow = request.QueryString("page")

		intPageSize = 5
		
		If content <> "" Then
			searchStr = " and content like '%"&content&"%'"
		End If
		
		
		sql = "select id,user_id, [content],[comment],create_time,comment_time from T_Message where 1=1"&searchStr
		sql = sql & " order by create_time desc" 
		sqlCount = "SELECT Count([id]) FROM [T_Message] where 1=1"&searchStr
	
			
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
					ReDim Preserve userIdArr(i)
					userIdArr(i) = arrU(1,i)
				Next
				
				Call Dream3Team.getUserMap(userIdArr,userMap)

			End If
		
		
	End Sub
%>
<%
G_Title_Content = "留言板"&"|"&SiteConfig("SiteName")&"-"&SiteConfig("SiteTitle")
%>

<!--#include file="../common/inc/header_user.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script type="text/javascript" src="../common/js/jquery/jquery-1.4.2.min.js"></script>  
<div id="message">
	<div class="mes_left">
	
		<div class="list_title"><span id="list_title_hot">我也要留言</span></div>
        
        <div class="post-area">
      		<textarea style="color:#666; width:660px; height:85px;overflow: auto;" id="msg_content"></textarea>
        	<div class="r"><input type="submit" value="发表留言" name="commit" class="mesbutton" onclick="saveMsg();"></div>
        </div>
    
    	<div class="list_title"><span id="list_title_hot">最新留言</span></div>
		<!--Start Ajax-->
		<div id="div_msg_list">
        <!--#include file="inc_detail.asp"-->
	    <!--End Ajax-->
        </div>
        
        
    </div>
	<div id="sidebar">
		<!--Dream3BizStart放心团-->
		<!--#include file="../common/inc/honour_common.asp"-->
		<!--Dream3BizEnd-->
		<!--Dream3BizStart邀请有礼-->
		<!--#include file="../common/inc/invite_common.asp"-->
		<!--Dream3BizEnd-->
		
		<!--#include file="../common/inc/service_common.asp"-->
		
		<div class="blank10"></div>
		
		<!--#include file="../common/inc/supply_right.asp"-->
		
		<div class="blank10"></div>
		
		<!--#include file="../common/inc/mail_right.asp"-->
    </div>
</div>

<script type="text/javascript">
function saveMsg() {
	var content;
	content = $("#msg_content").val();
	$.ajax({type:"POST", url:"<%=VirtualPath%>/message/saveMessageResult.asp", data:{content:escape(content)}, success:function (data) { 
 	if(data.indexOf("success") >= 0){
		//$("#div_msg_list").html(data); 
		//$("#msg_content").html('') ;
		alert("提交成功！");
		window.location.reload();
	}else{
 		alert(data);
	}
	
 }});
}

</script> 

<!--#include file="../common/inc/footer_user.asp"-->