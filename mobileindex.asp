


<!--#include file="conn.asp"-->
<!--#include file="common/api/cls_Main.asp"-->
<!--#include file="common/api/cls_pageview.asp"-->
<!--#include file="common/api/cls_map.asp"-->
<!--#include file="common/api/cls_product.asp"-->
<!--#include file="common/api/cls_static.asp"-->
<!--#include file="common/inc/city_common.asp"-->

<!--#include file="common/api/cls_quartz.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim sitename,group_id,enabled,to_group_id,city_id
Dim starttime,sitetitle
Dim groupComboItem,cityComboItem

Dim  totalCitys, totalOwners, totalProducts

	
	sql = "Select count(*) From T_User where state=2"
	Set userRs = Dream3CLS.Exec(sql)
	totalOwners = userRs(0)
	
	'sql = "Select count(*) From T_Product where state='normal'"
	'Set totalProductRs = Dream3CLS.Exec(sql)
	'totalProducts = totalProductRs(0)
	
	'orange��������
	sql = "Select * From T_Product where state='normal'"
	Set totalProductRs = Dream3CLS.Exec(sql)
	totalProducts=0
	Do While Not totalProductRs.EOF
		temp=totalProductRs("roomsnum")
		totalProducts=totalProducts+temp
		totalProductRs.Movenext
	Loop
	
%>
<head>
<meta name="viewport" content="width=device-width, minimum-scale=1, maximum-scale=1">
<link rel="stylesheet" href="http://code.jquery.com/mobile/1.0a4.1/jquery.mobile-1.0a4.1.min.css">
<script src="http://code.jquery.com/jquery-1.5.min.js"></script>
<script src="http://code.jquery.com/mobile/1.0a4.1/jquery.mobile-1.0a4.1.min.js"></script>

</head>
<body>



<div data-role="page">

   <header data-role="header" >
      <h1>���ù�</h1>
   </header><!-- /header -->
   
   
	   
		<div style = "text-align:center">
		<img  src="./images/mobile_logo.png" width="200" height="120"/>
		</br>
		<b>���ݴ�ѧ�Ǽ��ܱ�<%=totalOwners%>���õ�</b>
		</br>
		<b><%=totalProducts%>����෿�ݵȴ���</b>
	   </div>
	   <form id="searchNameForm" date-role="none"  action="mobile.asp" method="post" >
		<input type="search" name="searchname" id="searchname" value="�����õ�����" />
		
	   </form>
	   
	    <img  src="./images/mobile_search2.png"  />
		<nav data-role="navbar" >
			<ul>
				<li><a id="120101" href="mobile.asp?city=120101" rel="external">����</a></li>
				<li><a id="140101" >��ͤ</a></li>
				<li><a id="150101" >��ʯ</a></li>
				<li><a id="130101" >��ͤ</a></li>
			</ul>
		</nav>
		</br>
	   
	    <img  src="./images/mobile_search1.png"/>
		 
		<nav data-role="navbar">
			<ul>
				<li><a id="univer01">�д�</a></li>
				<li><a id="univer02">����</a></li>
				<li><a id="univer03">�Ǻ�</a></li>
				<li><a id="univer04">���</a></li>
				<li><a id="univer05">��ʦ</a></li>		
			</ul>
		  
			<ul>
				<li><a id="univer06">�㹤</a></li>
				<li><a id="univer07">����</a></li>
				<li><a id="univer08">��ҩ</a></li>
				<li><a id="univer09">����</a></li>
				<li><a id="univer10">����ҽ</a></li>
			
			</ul>
	   </nav>
	
</div><!-- /page -->

</body>


   <script>
 

jQuery(document).ready(function() { 
		
	//	$("#120101").bind("tap",function (e) { 		
	//	$.mobile.changePage("mobile.asp?city=120101" ,{transition:"slidedown"});
	//	});
		$("#140101").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=140101")
		});
		$("#150101").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=150101")
		});
		$("#130101").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=130101")
		});
		
		$("#univer01").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=120101")
		});
		$("#univer02").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=120101")
		});
		$("#univer03").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=140101")
		});
		$("#univer04").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=140101")
		});
		$("#univer05").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=120101")
		});
	                         	$("#univer06").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=130101")
		});
		$("#univer07").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=130101")
		});
		$("#univer08").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=130101")
		});
		$("#univer09").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=150101")
		});
		$("#univer10").bind("tap",function (e) { 		
		$.mobile.changePage("mobile.asp?city=130101")
		});
	
		$("#searchname").bind("blur",function (e) { 
					
			if(document.getElementsByName("searchname")[0].value!=""&&
				document.getElementsByName("searchname")[0].value!="�����õ�����"){
					submitSearch();
			}		
		});	
		$("#searchname").bind("focus",function (e) { 
			document.getElementsByName("searchname")[0].value="";	
		});	
    });
</script>

<script>
//�����Ľ��б������ύ
function submitSearch(){
	var searchNameStr;
	searchNameStr = document.getElementsByName("searchname")[0].value;
	searchNameStr = escape(searchNameStr);
	searchNameForm.submit();
}


</script>