<%

Dim pageintPageSize, pagestrPageInfo,pagestrTotalRecord

Dim pageclsRecordInfo
Dim pagearrU

dim pagesqlCount

dim pageismanager
dim pageisfangdong

dim pageusername
dim pageid
dim ownername
dim callback
pageaction=request.QueryString("pageaction")
pageid =request.QueryString("id")
callback = request.QueryString("callback")
	Select Case pageaction
	    case "shanchu"
		   call shanchu()
		Case "tongguo"
			call tongguo()
		case "huifu"
		    call huifu()
		case "chongshen"
		    call chongshen()
	End Select

	


 pageintPageNow = request.QueryString("page")

pagesql=pagesql&" order by createtime desc"
 
 
	   Set clsRecordInfo = New Cls_PageView
			clsRecordInfo.intRecordCount = 2816
			
			clsRecordInfo.strSql = pagesql
			clsRecordInfo.intPageSize = pageintPageSize
			clsRecordInfo.intPageNow = pageintPageNow
			clsRecordInfo.strPageUrl = pagestrLocalUrl
			clsRecordInfo.strPageVar = "page"
		 clsRecordInfo.objConn = Conn		
		 pagearrU = clsRecordInfo.arrRecordInfo
		 pagestrPageInfo = clsRecordInfo.strPageInfo
		 pagestrTotalRecord  = clsRecordInfo.strTotalRecord
		Set clsRecordInfo = nothing
 
 sub shanchu()
 Dream3CLS.Exec("delete from T_Comments where id='"&pageid&"'")
 response.Redirect(pagestrLocalUrl)
 end sub
 sub tongguo()
 Dream3CLS.Exec("update  T_Comments set state='Y' where id='"&pageid&"'")
 response.Redirect(pagestrLocalUrl)
 
 end sub
 sub huifu()
 
 Dream3CLS.Exec("update  T_Comments set callback='"&callback&"',callbacktime='"&now()&"' where id='"&pageid&"'")
 response.Redirect(pagestrLocalUrl)
 end sub
sub chongshen()
 Dream3CLS.Exec("update  T_Comments set state='N' where id='"&pageid&"'")
 response.Redirect(pagestrLocalUrl)
end sub
 %>


<div class="pinglun" style="display:block ">
      <%
  if isArray(pagearrU) then
  
 
	for i=0 to ubound(pagearrU,2)
	    
	 
	  commentid=pagearrU(0,i)
	  pageusername=pagearrU(1,i)
	  userface=pagearrU(2,i)
	  hotelname=pagearrU(3,i)
	  housetitle=pagearrU(4,i)
	  contenttext=pagearrU(5,i)
	  pagestate=pagearrU(6,i)
	  textcreatime=pagearrU(7,i)	 
	  ownername =pagearrU(8,i)	 	 
	  callback=pagearrU(9,i)	
	  callbacktime=pagearrU(10,i)	
  %>
      <div class="pinglun_box">
            <div class="pl_img"> <img width="60" height="60" title=<%=pageusername%> src=<%=userface%>>
                  <p> <%=pageusername%> </p>
            </div>
            <div class="pl_text">
                  <div class="pl_text_center"> <span class="pl_sanjiao"></span>
                  
                        <div class="moreinfo">
                              <p> <%=contenttext%>
                                   
                              </p>
                               <%if pagestate="N" then%>
                                    <span style="color:red; position:relative;left:400px;"> 未审核评论 </span>
                                   <%end if%>
                              
                        </div>
                        
                        <div >
                        <p class="detail_comment"> <span > 评论内容</span> <span style="position:relative;left:250px;"> 评论时间： <%=textcreatime%> </span></p>
                        </div>
                        
                        
                        
                  </div>
            </div>
            <%if not isnull(callback) then  %>
            <div class="pl_text">
                  <div class="pl_text_center">
                        <div class="moreinfo">
                              <p > <%=callback%> </p>
                        </div>
                        
                        <p class="detail_comment"> <span > 房东回复</span><span style="position:relative;left:250px;"> 回复时间： <%=callbacktime%> </span> </p>
                  </div>
            </div>
            <%end if%>
            <!-- <dl class="fav-dl">
   <dd>整洁卫生（好评）</dd>
   <dd>安全程度（好评）</dd>
   <dd>描述相符（好评）</dd>
   <dd>交通位置（好评）</dd>
   <dd>性价比（好评）</dd>
  </dl>-->
            <dl class="fav-dl">
              <span class="yym-room" style="width:200px">
                        <ul>
                              <%if bigpage="manager" then %>
                              <li class="li7">
                                    <%if pagestate="Y" then%>
                                    <a  href="<%=pagestrLocalUrl&"&page="&pageintPageNow%>&pageaction=chongshen&id=<%=commentid%>#3">重审</a>
                                    <%else%>
                                    <a  href="<%=pagestrLocalUrl&"&page="&pageintPageNow%>&pageaction=tongguo&id=<%=commentid%>">通过</a>
                                    <%end if%>
                              </li>
                              <!---->
                              
                              <li class="li2"> <a href="<%=pagestrLocalUrl&"&page="&pageintPageNow%>&pageaction=shanchu&id=<%=commentid%>#3" >删除</a> </li>
                              <%elseif trim(pageiswho)=trim(ownername) and bigpage="fangdong" then %>
                              <%if isnull(callback) then  %>
                              <li class="li8"  > <a  onclick="huifupinglun(<%=commentid%>)">回复</a> </li>
                              <%else %>
                              <li class="li8"  > <a   onclick="huifupinglun(<%=commentid%>)">修改回复</a> </li>
                              <%end if%>
                              <%elseif trim(pageiswho)=trim( pageusername) and bigpage="user"then %>
                              <li class="li2"> <a  href="<%=pagestrLocalUrl&"&page="&pageintPageNow%>&pageaction=shanchu&id=<%=commentid%>#3" >删除</a> </li>
                              <%end if%>
                        </ul>
                  </span>
                  <dd>旅馆：<%=hotelname%>&nbsp房间：<%=housetitle%></dd>
                
                  <div id="<%=commentid%>" style="display:none ;text-align:left">
                        <textarea  id="text<%=commentid%>" name="huifu" cols="88" rows="5" value="dsfkl"></textarea>
                        <input type="button" value="提交回复"  onclick="submitbutton(text<%=commentid%>,'<%=pagestrLocalUrl&"&page="&pageintPageNow%>&pageaction=huifu&id=<%=commentid%>')"/>
                        <input type="button" value="取消" onclick="cancelbutton(<%=commentid%>)" />
                  </div>
            </dl>
      </div>
      <% next%>
</div>
<div> <%=pagestrPageInfo%> </div>
<%else%>
<div class="pinglun" style="display:block; "> 暂无评论或评论尚未审核(评论3条一页) </div>
</div>
<%end if%>
<script language="javascript" type="text/javascript">
    function huifupinglun(commentsobj){
		
		
		//alert(commentsobj);
		var textarea=document.getElementById(commentsobj);
		
	
	
　　if (textarea.style.display=="block")
　　{
　　　　textarea.style.display="none";
　　}
　　else
　　{
　　　　textarea.style.display="block";
     }
 

	}
	function submitbutton(text,href){
		if(text.value==""){alert("请输入具体回复内容！")}
		else
		{window.location=href+"&callback="+text.value+"#3"}
	
　  }
	
	function cancelbutton(commentid){
	
	document.getElementById(commentid).style.display="none"
　}



</script> 
