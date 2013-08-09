<div id="myinfo_wrap">
        <div class="ele_inner clearfix">
            <h1 class="myinfo_film_nav">
            
                <span><img  src="<%If IsNull(face) or face="" Then response.Write("../../images/noimage.gif") else response.Write("../../"&face)%>" class="img v_m"></span>
                <span class="ml9 px28 yahei c_333"><%=Session("_UserName")%></span>
                <span class="ml9 yahei px18 c_999">ÄãºÃ!</span>
                <em class="ml9 c_999"></em>
            </h1>
        </div>
    </div>