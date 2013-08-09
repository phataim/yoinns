
		<%
		If IsArray(arrU) Then
			For i = 0 to UBound(arrU, 2)
				s_face = ""
				s_username = ""
				s_user_id = CStr(arrU(1,i))
				If CStr(arrU(1,i)) <> "0" Then
					If IsArray(userMap.getv(s_user_id)) Then
						s_username = userMap.getv(s_user_id)(0)
						s_face = userMap.getv(s_user_id)(3)
					End If
					If IsNull(s_face) OR s_face = "" Then
						s_face = VirtualPath & "/images/user_normal.jpg"
					Else
						s_face = Dream3Team.FilterImage(s_face)
					End If
				Else
					s_face = VirtualPath & "/images/youke.gif"
				End If
				
				If s_username = "" Then 
					s_username = "游客"
				End If
				
				
				s_create_time = arrU(4,i)
				s_content = arrU(2,i)
				s_comment = arrU(3,i)
				If IsNull(s_comment) OR s_comment = "" Then
					s_comment = "暂无..."
				End if
				s_interval = Dream3CLS.getTimeInterval(s_create_time)
				
		%>		
        <div class="answer">
            <ul>
                <li class="ansborderb">
                    <div class="askhead"><img src="<%=s_face%>"><span class="askname"><%=s_username%></span></div>
                    <div class="askcon">
                    <p><span>时间：<%=s_interval%></span></p>
                    <p><%=s_content%></p>
                    </div>
                </li>
                <li style="background:#F7F7F7;">
                    <div class="anscon"><strong>回答：</strong>
                    <%=s_comment%>
                    </div>
                </li>
            </ul>
        </div>
        
       <%
		    Next
		Else
		%>
		<div class="answer">
            <ul>
                <li class="ansborderb">
                    <div class="askhead">
					暂无留言
                    </div>
                </li>
            </ul>
        </div>
		<%
	    End If
	   %>
	   
	   <%If IsArray(arrU) Then%>
		<div class="quotes">
		<%= strPageInfo%>
		</div>
		<%End If%>
	   
