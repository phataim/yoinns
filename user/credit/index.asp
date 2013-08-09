<!--#include file="../../conn.asp"-->
<!--#include file="../../common/inc/permission_user.asp"-->
<!--#include file="../../common/api/cls_Main.asp"-->
<!--#include file="../../common/api/cls_pageview.asp"-->
<!--#include file="../../common/api/cls_map.asp"-->
<!--#include file="../../common/api/cls_product.asp"-->
<!--#include file="../../common/api/cls_user.asp"-->
<%
Dim Action
Dim citySql,cityRs
Dim clsRecordInfo
Dim intPageSize, strPageInfo
Dim intPageNow
Dim strLocalUrl,ModeName
Dim arrU, i,GroupSettingSet
Dim sql, sqlCount
Dim searchStr
Dim money
Dim teamIdArr()

Set teamMap = new AspMap
	
	Action = Request.QueryString("act")
	Select Case Action
		Case Else
			Call Main()
	End Select


	
	Sub Main()		
	
		'得到账户余额
		Sql = "Select money from T_User Where id="&session("_UserID")

		Set Rs = Dream3CLS.Exec(Sql)
		money = Dream3CLS.FormatNumbersNil(Rs("money"))
		
		searchStr = " and user_id ="&session("_UserID")

		strLocalUrl = request.ServerVariables("SCRIPT_NAME")	
		
		intPageNow = request.QueryString("page")

		intPageSize = 10
		
		sql = "select id,user_id,admin_id,detail_id,direction,money,action,create_time from T_Fin_Record  where 1=1 "&searchStr
		sql = sql &" order by create_time desc"

		sqlCount = "SELECT Count([id]) FROM [T_Fin_Record] where 1=1 "&searchStr
		
	
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
					ReDim Preserve teamIdArr(i)
					teamIdArr(i) = arrU(3,i)
				Next
				
				Call Dream3Team.getTeamMap(teamIdArr,teamMap)
				
			End If
			
	End Sub
	
%>
<!--#include file="../../common/inc/header_user.asp"-->
<title><%=SiteConfig("SiteName")%>-我的账户</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
 
<div id="box">	
	<div class="cf">		
		<div id="credit">
			<div class="login-box" id="content">
					
					<!--#include file="../inc/menu.asp"-->
					
					<div class="login-content">
						<div class="head">
							<h2>帐户余额</h2>
						</div>
						<div class="sect">
					<p class="charge">充值到<%=SiteConfig("SiteShortName")%>帐户，方便抢购！</p>
					<h3 class="credit-title">您当前的帐户余额是 <strong><%=money%></strong> 元</h3>
					<table id="order-list" cellspacing="0" cellpadding="0" border="0" class="coupons-table">
						<tr>
						<th width="120">时间</th>
						<th width="auto">详情</th>
						<th width="50">收支</th>
						<th width="70">金额(元)</th>
						</tr>
						<%
						If IsArray(arrU) Then
							For i = 0 to UBound(arrU, 2)
								If arrU(4,i)="income" then
									direStr = "收入"
								Elseif arrU(4,i)="expense" then
									direStr = "支出"
								End If
								
								If arru(6,i) = "store" Then
									actionStr = "现金充值"
								Elseif arru(6,i) = "invbonus" Then
									actionStr = "邀请返利"
								Elseif arru(6,i) = "bonus" Then
									actionStr = "购买返利"
								Elseif arru(6,i) = "refund" Then
									actionStr = "退款"
								Elseif arru(6,i) = "cash" Then
									actionStr = "现金支付"
								Elseif arru(6,i) = "credit" Then
									actionStr = "余额支付"
								Elseif arru(6,i) = "buy" Then
									actionStr = "购买项目 - <a href='../../team.asp?id="&arrU(3,i)&"' target='_blank'>"&teamMap.getv(CStr(arrU(3,i)))&"</a>"
								Else
									actionStr = "未定义"
								End If
					
						%>	
							<tr <%If i mod 2 = 0 Then%>class="alt"<%End If%>>
							<td style="text-align:left;"><%=arrU(7,i)%></td>
							<td>
							
							<%=actionStr%>
							</td>
							<td class="expense"><%=direStr%></td>
							<td><%=Dream3CLS.FormatNumbersNil(arrU(5,i))%></td></tr>
							<%Next%>
							<tr>
							  <td colspan="4" align="right">
							  <%= strPageInfo%>
							  </td>
							</tr>
						<%End If%>
												
                    </table>
				</div>
					</div>
					<div class="login-bottom"></div>
			</div>
			<div id="sidebar" style="margin-top:28px;">
				<div class="sbox">
					<div class="sbox-top"></div>
					<div class="sbox-content">
						<div class="credit">
							<h2>帐户余额</h2>
							<p>您的帐户余额：<span class="money"><%=SiteConfig("CNYSymbol")%></span><%=Dream3User.getUserMoney(session("_UserID"))%></p>
						</div>
					</div>
					<div class="sbox-bottom"></div>
				</div>
			</div>
			
			<div id="sidebar" style="margin-top:10px;">
				<div class="sbox">
					<div class="sbox-top"></div>
					<div class="sbox-content">
						<div class="side-tip">
							<h3 class="first">什么是账户余额？</h3>
							<p>账户余额是你在<%=SiteConfig("SiteName")%>团购时可用于支付的金额。</p>
							<h3>可以往账户里充值么？</h3>
							<p>请到<a href="index.asp">账户余额</a>菜单，在线充值。</p>
							<h3>那怎样才能有余额？</h3>
							<p>邀请好友获得返利将充值到账户余额，参加团购亦可获得返利。</p>
						</div>
					</div>
					<div class="sbox-bottom"></div>
				</div>
			</div>
			
		</div>
	</div>	
</div>
<!--#include file="../../common/inc/footer_user.asp"-->
