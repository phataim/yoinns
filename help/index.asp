<!--#include file="../conn.asp"-->
<!--#include file="../common/api/cls_Main.asp"-->

<%
Dim Sql,Rs
Dim PageKey

PageKey = Dream3CLS.RSQL("c")

if PageKey = "" Then pagekey = "aboutus"

Sql = "Select [category],[Description],[Content] From T_Page Where ID='"&PageKey&"'"
Set Rs = Dream3CLS.Exec(Sql)
category = Rs("category")
title = Rs("Description")
content = Rs("content")
%> 
<!--#include file="../common/inc/header_user.asp"-->
<div class="area">
	
    <div class="crumbs"><a href="../index.asp">首页</a> &gt; <%=category%> &gt; <%=title%></div>
    
    <div class="help_zu">
    	
        <div class="i_sidebar">
        	<div class="help_menu">
                <dl class="mod_menu">
                    <dt class="mod_hd">
                    <h3> 用户帮助</h3>
                    </dt>
                    <dd class="mod_bd">
                        <ul class="list_menu">
                            <li <%If PageKey= "question" Then%>class="status_hover"<%End If%>><a href="?c=question">常见问题</a></li>
                            <li <%If PageKey= "pay" Then%>class="status_hover"<%End If%>><a href="?c=pay">如何付款</a></li>
                            <li <%If PageKey= "roomspec" Then%>class="status_hover"<%End If%>><a href="?c=roomspec">房间审核规范</a></li>
                        </ul>
                    </dd>
                </dl>
                
                <dl class="mod_menu">
                    <dt class="mod_hd">
                    <h3> 合作与联系</h3>
                    </dt>
                    <dd class="mod_bd">
                        <ul class="list_menu">
                            <li <%If PageKey= "friendlink" Then%>class="status_hover"<%End If%>><a href="?c=friendlink">友情链接</a></li>
                            <li <%If PageKey= "cooperation" Then%>class="status_hover"<%End If%>><a href="?c=cooperation">商务合作</a></li>
                        </ul>
                    </dd>
                </dl>
                <dl class="mod_menu">
                    <dt class="mod_hd">
                    <h3> 公司信息</h3>
                    </dt>
                    <dd class="mod_bd">
                        <ul class="list_menu">
                            <li <%If PageKey= "aboutus" Then%>class="status_hover"<%End If%>><a href="?c=aboutus">关于我们</a></li>
                            <li <%If PageKey= "terms" Then%>class="status_hover"<%End If%>><a href="?c=terms">用户协议</a></li>
                            <li <%If PageKey= "privacy" Then%>class="status_hover"<%End If%>><a href="?c=privacy">隐私声明</a></li>
                        </ul>
                    </dd>
                </dl>
            </div>      
        </div>
        
        <div class="i_content">
        	<div class="help_content">
            	<div class="hd">
                	<h4><%=title%></h4>
                </div>
                <div class="bd">
					<%If PageKey = "friendlink" then%>
					<div class="index_link">
						<ul>
							<%
							Sql = "Select sitename,siteurl,logo From T_FriendLink Where 1=1 order by seqno Desc"
							Set Rs = Dream3CLS.Exec(Sql)
							Do While Not Rs.EOF 
							%>
							<li><a href="<%=Rs("siteurl")%>" target="_blank"><%=Rs("sitename")%></a></li>
							<%
								Rs.Movenext
							Loop
							%>
						</ul>
                    </div>
                    <br /><br />
					<%End If%>
                	<%=content%>
                </div>
            </div>
        </div>
        
    </div>
    
</div>



<!--#include file="../common/inc/footer_user.asp"-->
